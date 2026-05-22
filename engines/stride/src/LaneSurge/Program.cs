using System.Text.Json;

var runtimeDir = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "runtime"));
Directory.CreateDirectory(runtimeDir);

var saveFile = Path.Combine(runtimeDir, "lane_surge_save.json");
var traceFile = Path.Combine(runtimeDir, "lane_surge_latest_run.json");

var seedText = Environment.GetEnvironmentVariable("STRIDE_SEED");
var seeded = int.TryParse(seedText, out var seedValue);
var rng = seeded ? new Random(seedValue) : new Random();

var trace = new List<object>();
void Log(string name, object payload) => trace.Add(new { evt = name, payload });

var bestScore = 0;
if (File.Exists(saveFile))
{
    try
    {
        using var saveDoc = JsonDocument.Parse(File.ReadAllText(saveFile));
        if (saveDoc.RootElement.TryGetProperty("bestScore", out var scoreNode))
        {
            bestScore = scoreNode.GetInt32();
        }
    }
    catch
    {
        bestScore = 0;
    }
}

const int laneCount = 5;
const int maxTicks = 1000;
const double spawnStart = 12.0;
const double spawnFloor = 3.0;
const double speedStart = 0.35;
const double speedCap = 1.15;

var lane = laneCount / 2;
var score = 0;
var spawnCounter = spawnStart;
var speed = speedStart;

var obstacles = new List<(int lane, double distance)>();

Log("run_start", new { seeded, seed = seeded ? seedValue : 0 });

for (var tick = 0; tick < maxTicks; tick++)
{
    score += 1;

    var inputRoll = rng.NextDouble();
    if (inputRoll < 0.33)
    {
        lane = Math.Max(0, lane - 1);
    }
    else if (inputRoll > 0.67)
    {
        lane = Math.Min(laneCount - 1, lane + 1);
    }

    spawnCounter -= 1;
    if (spawnCounter <= 0)
    {
        var obsLane = rng.Next(0, laneCount);
        obstacles.Add((obsLane, 18.0));
        Log("spawn", new { tick, lane = obsLane, score });

        var difficulty = score * 0.0025;
        spawnCounter = Math.Max(spawnFloor, spawnStart - score * 0.01);
        speed = Math.Min(speedCap, speedStart + difficulty);
    }

    for (var i = obstacles.Count - 1; i >= 0; i--)
    {
        var obs = obstacles[i];
        var newDistance = obs.distance - speed;

        if (newDistance <= 0.8 && obs.lane == lane)
        {
            Log("collision", new { tick, lane, score });
            goto EndRun;
        }

        if (newDistance < -2.0)
        {
            obstacles.RemoveAt(i);
            continue;
        }

        obstacles[i] = (obs.lane, newDistance);
    }
}

EndRun:
bestScore = Math.Max(bestScore, score);
File.WriteAllText(saveFile, JsonSerializer.Serialize(new { bestScore }, new JsonSerializerOptions { WriteIndented = true }));

Log("run_end", new { score, bestScore, activeObstacles = obstacles.Count });

var tracePayload = new
{
    seeded,
    seed = seeded ? seedValue : 0,
    score,
    bestScore,
    events = trace
};
File.WriteAllText(traceFile, JsonSerializer.Serialize(tracePayload, new JsonSerializerOptions { WriteIndented = true }));

Console.WriteLine($"Lane Surge complete. Score={score} Best={bestScore}");
Console.WriteLine($"Trace: {traceFile}");
