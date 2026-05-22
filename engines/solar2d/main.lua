display.setStatusBar(display.HiddenStatusBar)

local json = require("json")

math.randomseed(os.time())

local screenW = display.contentWidth
local screenH = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local ROUND_DURATION = 75
local STARTING_LIVES = 3
local LEVEL_SCORE_STEP = 10
local MAX_LEVEL = 10
local BASE_SPAWN_INTERVAL = 0.95
local MIN_SPAWN_INTERVAL = 0.26
local BASE_FALL_SPEED = 220
local OVERCHARGE_DURATION = 6
local OVERCHARGE_COOLDOWN = 8
local TRACE_FILE_NAME = "spark_catch_latest_run.json"
local SEED_ENV_VAR = "SPARK_CATCH_SEED"
local TRACE_MAX_EVENTS = 700

local state = "title"
local score = 0
local bestScore = 0
local combo = 0
local lives = STARTING_LIVES
local level = 1
local roundTime = ROUND_DURATION

local drops = {}
local spawnTimer = 0
local overchargeTimer = 0
local overchargeCooldown = 0
local lastFrameTime = system.getTimer()
local runElapsed = 0
local traceEvents = {}
local lastLoggedLevel = 1
local seedLocked = false
local seedBase = os.time()
local runIndex = 0
local currentRunSeed = 0

local savePath = system.pathForFile("spark_catch_save.json", system.DocumentsDirectory)
local tracePath = system.pathForFile(TRACE_FILE_NAME, system.DocumentsDirectory)

local rootGroup = display.newGroup()
local gameGroup = display.newGroup()
local hudGroup = display.newGroup()
rootGroup:insert(gameGroup)
rootGroup:insert(hudGroup)

local background = display.newRect(gameGroup, centerX, centerY, screenW + 8, screenH + 8)
background:setFillColor(0.04, 0.06, 0.1)

local catcher = display.newRect(gameGroup, centerX, screenH - 100, 180, 28)
catcher:setFillColor(0.2, 0.85, 0.95)
catcher.anchorY = 0.5

local titleText = display.newText({
  parent = hudGroup,
  text = "SPARK CATCH",
  x = centerX,
  y = 72,
  font = native.systemFontBold,
  fontSize = 42
})

local hudText = display.newText({
  parent = hudGroup,
  text = "",
  x = centerX,
  y = 120,
  font = native.systemFont,
  fontSize = 20
})

local promptText = display.newText({
  parent = hudGroup,
  text = "Tap to Start",
  x = centerX,
  y = centerY,
  font = native.systemFontBold,
  fontSize = 32,
  align = "center"
})

local detailText = display.newText({
  parent = hudGroup,
  text = "Drag the catcher. Catch sparks. Avoid shards.",
  x = centerX,
  y = centerY + 48,
  font = native.systemFont,
  fontSize = 18,
  align = "center"
})

local function clamp(value, minValue, maxValue)
  if value < minValue then
    return minValue
  end
  if value > maxValue then
    return maxValue
  end
  return value
end

local function roundNumber(value, decimals)
  local factor = 10 ^ decimals
  return math.floor((value * factor) + 0.5) / factor
end

local function logTrace(eventType, payload)
  if #traceEvents >= TRACE_MAX_EVENTS then
    return
  end

  local entry = {
    t = roundNumber(runElapsed, 3),
    type = eventType
  }

  if payload then
    for key, value in pairs(payload) do
      entry[key] = value
    end
  end

  traceEvents[#traceEvents + 1] = entry
end

local function writeTrace(endReason)
  local file = io.open(tracePath, "w")
  if not file then
    return
  end

  local payload = {
    engine = "Solar2D",
    project = "Spark Catch",
    seed = currentRunSeed,
    seedLocked = seedLocked,
    runIndex = runIndex,
    durationSeconds = roundNumber(runElapsed, 3),
    score = score,
    bestScore = bestScore,
    level = level,
    lives = lives,
    endReason = endReason,
    events = traceEvents
  }

  file:write(json.encode(payload))
  io.close(file)
end

local function configureSeedMode()
  local envSeed = os.getenv(SEED_ENV_VAR)
  local parsed = tonumber(envSeed)
  if parsed then
    seedBase = parsed
    seedLocked = true
  else
    seedBase = os.time()
    seedLocked = false
  end
end

local function prepareRoundSeed()
  if seedLocked then
    currentRunSeed = seedBase
  else
    currentRunSeed = seedBase + (runIndex * 9973)
  end
  runIndex = runIndex + 1
  math.randomseed(currentRunSeed)
end

local function loadBestScore()
  local file = io.open(savePath, "r")
  if not file then
    return 0
  end

  local contents = file:read("*a")
  io.close(file)

  local decoded = json.decode(contents)
  if decoded and tonumber(decoded.bestScore) then
    return tonumber(decoded.bestScore)
  end
  return 0
end

local function saveBestScore()
  local file = io.open(savePath, "w")
  if not file then
    return
  end

  file:write(json.encode({ bestScore = bestScore }))
  io.close(file)
end

bestScore = loadBestScore()

local function updateHud()
  local overchargeLabel = "off"
  if overchargeTimer > 0 then
    overchargeLabel = string.format("%.1fs", overchargeTimer)
  end

  hudText.text = string.format(
    "Score %d   Best %d   Lives %d   Combo %d   Level %d   Time %ds   Overcharge %s",
    score,
    bestScore,
    lives,
    combo,
    level,
    math.max(0, math.ceil(roundTime)),
    overchargeLabel
  )
end

local function clearDrops()
  for i = #drops, 1, -1 do
    local entry = drops[i]
    if entry.node and entry.node.removeSelf then
      display.remove(entry.node)
    end
    drops[i] = nil
  end
end

local function setPrompt(prompt, detail)
  promptText.text = prompt
  detailText.text = detail or ""
  promptText.isVisible = true
  detailText.isVisible = true
end

local function hidePrompt()
  promptText.isVisible = false
  detailText.isVisible = false
end

local function resetRoundState()
  score = 0
  combo = 0
  lives = STARTING_LIVES
  level = 1
  roundTime = ROUND_DURATION
  spawnTimer = 0
  overchargeTimer = 0
  overchargeCooldown = 0
  runElapsed = 0
  traceEvents = {}
  lastLoggedLevel = 1
  catcher.x = centerX
  clearDrops()
  updateHud()
end

local function endRound()
  state = "round_over"
  if score > bestScore then
    bestScore = score
    saveBestScore()
  end
  logTrace("round_end", {
    reason = (lives <= 0) and "lives_depleted" or "time_elapsed",
    score = score,
    level = level,
    lives = lives
  })
  writeTrace((lives <= 0) and "lives_depleted" or "time_elapsed")
  setPrompt("Round Complete", "Tap to restart")
  updateHud()
end

local function applySparkCatch()
  local bonus = 1 + math.min(3, math.floor(combo / 4))
  local multiplier = 1
  if overchargeTimer > 0 then
    multiplier = 2
  end

  score = score + (bonus * multiplier)
  combo = combo + 1
  logTrace("spark_catch", {
    score = score,
    combo = combo,
    overcharge = overchargeTimer > 0
  })
end

local function applyShardCatch()
  combo = 0
  lives = lives - 1
  logTrace("shard_catch", {
    lives = lives
  })
end

local function applyOverchargeCatch()
  combo = 0
  overchargeTimer = OVERCHARGE_DURATION
  score = score + 2
  logTrace("overcharge_catch", {
    score = score,
    duration = OVERCHARGE_DURATION
  })
end

local function spawnDrop()
  local dropType
  if overchargeCooldown <= 0 and math.random() < 0.10 then
    dropType = "overcharge"
    overchargeCooldown = OVERCHARGE_COOLDOWN
    logTrace("overcharge_spawn", {
      cooldown = OVERCHARGE_COOLDOWN
    })
  else
    local roll = math.random()
    if roll < 0.24 then
      dropType = "shard"
    else
      dropType = "spark"
    end
  end

  local radius = 18
  if dropType == "overcharge" then
    radius = 20
  end

  local node = display.newCircle(
    gameGroup,
    math.random(30, screenW - 30),
    -30,
    radius
  )

  if dropType == "spark" then
    node:setFillColor(0.2, 0.9, 0.45)
  elseif dropType == "shard" then
    node:setFillColor(0.95, 0.35, 0.35)
  else
    node:setFillColor(0.95, 0.85, 0.25)
  end

  local speed = BASE_FALL_SPEED + ((level - 1) * 22) + math.random(0, 35)
  drops[#drops + 1] = {
    type = dropType,
    speed = speed,
    radius = radius,
    node = node
  }
end

local function startRound()
  prepareRoundSeed()
  resetRoundState()
  state = "playing"
  logTrace("round_start", {
    seed = currentRunSeed,
    seedLocked = seedLocked
  })
  hidePrompt()
end

local function setPaused(enabled)
  if enabled and state == "playing" then
    state = "paused"
    logTrace("pause", { paused = true })
    setPrompt("Paused", "Press P to resume")
    return
  end

  if (not enabled) and state == "paused" then
    state = "playing"
    logTrace("pause", { paused = false })
    hidePrompt()
  end
end

local function isCollision(drop)
  local halfW = catcher.width * 0.5
  local halfH = catcher.height * 0.5
  local dx = math.abs(drop.node.x - catcher.x)
  local dy = math.abs(drop.node.y - catcher.y)
  return dx <= (halfW + drop.radius) and dy <= (halfH + drop.radius)
end

local function onTap()
  if state == "title" or state == "round_over" then
    startRound()
  end
  return true
end

local function onCatcherTouch(event)
  if state ~= "playing" then
    return true
  end

  if event.phase == "began" or event.phase == "moved" then
    local minX = catcher.width * 0.5
    local maxX = screenW - (catcher.width * 0.5)
    catcher.x = clamp(event.x, minX, maxX)
  end

  return true
end

local function onKey(event)
  if event.phase ~= "up" then
    return false
  end

  if event.keyName == "p" then
    if state == "playing" then
      setPaused(true)
    elseif state == "paused" then
      setPaused(false)
    end
    return true
  end

  return false
end

local function updateFrame(event)
  local now = event.time
  local dt = (now - lastFrameTime) / 1000
  lastFrameTime = now

  if state ~= "playing" then
    return
  end

  if dt > 0.05 then
    dt = 0.05
  end

  runElapsed = runElapsed + dt

  roundTime = roundTime - dt
  if roundTime <= 0 then
    endRound()
    return
  end

  level = math.min(MAX_LEVEL, 1 + math.floor(score / LEVEL_SCORE_STEP))
  if level > lastLoggedLevel then
    logTrace("level_up", {
      from = lastLoggedLevel,
      to = level,
      score = score
    })
    lastLoggedLevel = level
  end

  if overchargeTimer > 0 then
    overchargeTimer = math.max(0, overchargeTimer - dt)
  end

  if overchargeCooldown > 0 then
    overchargeCooldown = math.max(0, overchargeCooldown - dt)
  end

  local spawnInterval = BASE_SPAWN_INTERVAL - ((level - 1) * 0.06)
  spawnInterval = math.max(MIN_SPAWN_INTERVAL, spawnInterval)

  if overchargeTimer > 0 then
    spawnInterval = spawnInterval * 0.72
  end

  spawnTimer = spawnTimer - dt
  while spawnTimer <= 0 do
    spawnDrop()
    spawnTimer = spawnTimer + spawnInterval
  end

  for i = #drops, 1, -1 do
    local entry = drops[i]
    entry.node.y = entry.node.y + (entry.speed * dt)

    local remove = false

    if isCollision(entry) then
      if entry.type == "spark" then
        applySparkCatch()
      elseif entry.type == "shard" then
        applyShardCatch()
      else
        applyOverchargeCatch()
      end
      remove = true
    elseif entry.node.y > (screenH + 40) then
      if entry.type == "spark" then
        combo = 0
        lives = lives - 1
        logTrace("spark_missed", {
          lives = lives
        })
      end
      remove = true
    end

    if remove then
      display.remove(entry.node)
      table.remove(drops, i)
    end
  end

  if lives <= 0 then
    endRound()
    return
  end

  updateHud()
end

catcher:addEventListener("touch", onCatcherTouch)
Runtime:addEventListener("tap", onTap)
Runtime:addEventListener("key", onKey)
Runtime:addEventListener("enterFrame", updateFrame)

configureSeedMode()
setPrompt("Tap to Start", "Drag the catcher. Catch sparks. Avoid shards.")
updateHud()
