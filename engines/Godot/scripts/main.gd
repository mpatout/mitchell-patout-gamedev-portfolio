extends Node2D

enum GameState {
	PLAYING,
	PAUSED,
	ROUND_OVER
}

const PLAYER_RADIUS := 18.0
const TARGET_RADIUS := 12.0
const ENEMY_RADIUS := 14.0
const HAZARD_RADIUS := 22.0
const POWERUP_RADIUS := 11.0
const PLAYER_SPEED := 370.0
const BASE_ENEMY_SPEED := 120.0
const ENEMY_SPEED_STEP := 16.0
const ROUND_TIME_SECONDS := 60.0
const TARGET_TIME_BONUS := 1.3
const POWERUP_TIME_BONUS := 6.0
const EDGE_PADDING := 24.0
const STARTING_LIVES := 3
const HIT_INVULNERABILITY_SECONDS := 1.1
const COMBO_WINDOW_SECONDS := 2.6
const POWERUP_SPAWN_INTERVAL := 13.0
const STASIS_DURATION_SECONDS := 4.0
const SAVE_FILE_PATH := "user://signal_chase_save.json"
const TRACE_FILE_PATH := "user://signal_chase_latest_run.json"
const SEED_ENV_VAR := "SIGNAL_CHASE_SEED"
const INPUT_SAMPLE_INTERVAL_SECONDS := 0.2
const MAX_TRACE_EVENTS := 900
const BASE_PRESSURE := 0.35
const PRESSURE_TARGET_BONUS := 0.055
const PRESSURE_COMBO_BONUS := 0.02
const PRESSURE_HIT_PENALTY := 0.22
const PRESSURE_DECAY_PER_SECOND := 0.06
const PRESSURE_STASIS_RELIEF_PER_SECOND := 0.14
const POWERUP_INTERVAL_MIN := 8.5
const POWERUP_INTERVAL_MAX := 16.5

@onready var score_label: Label = $HUD/Overlay/ScoreLabel
@onready var timer_label: Label = $HUD/Overlay/TimerLabel
@onready var lives_label: Label = $HUD/Overlay/LivesLabel
@onready var level_label: Label = $HUD/Overlay/LevelLabel
@onready var combo_label: Label = $HUD/Overlay/ComboLabel
@onready var best_label: Label = $HUD/Overlay/BestLabel
@onready var state_label: Label = $HUD/Overlay/StateLabel
@onready var pause_label: Label = $HUD/Overlay/PauseLabel

var rng := RandomNumberGenerator.new()
var player_position := Vector2.ZERO
var target_position := Vector2.ZERO
var powerup_position := Vector2.ZERO
var enemies: Array[Vector2] = []
var hazards: Array[Vector2] = []
var score := 0
var best_score := 0
var lives := STARTING_LIVES
var level := 1
var combo_count := 0
var combo_timer := 0.0
var time_remaining := ROUND_TIME_SECONDS
var hit_invulnerability_remaining := 0.0
var powerup_spawn_cooldown := POWERUP_SPAWN_INTERVAL
var stasis_remaining := 0.0
var powerup_active := false
var state := GameState.PLAYING
var seed_locked := false
var seed_base := 0
var run_index := 0
var current_run_seed := 0
var run_elapsed := 0.0
var input_sample_timer := 0.0
var run_trace_events: Array[Dictionary] = []
var pressure_level := BASE_PRESSURE


func _ready() -> void:
	_configure_seed_mode()
	_load_best_score()
	_restart_round(false)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and state != GameState.ROUND_OVER:
		_toggle_pause()

	if state == GameState.ROUND_OVER:
		if Input.is_action_just_pressed("ui_accept"):
			_restart_round(true)
		return

	if state == GameState.PAUSED:
		return

	run_elapsed += delta
	var move_vector := _get_move_vector()
	player_position += move_vector * PLAYER_SPEED * delta
	_clamp_player_to_viewport()
	_sample_input_vector(delta, move_vector)

	hit_invulnerability_remaining = max(hit_invulnerability_remaining - delta, 0.0)
	combo_timer = max(combo_timer - delta, 0.0)
	if combo_timer == 0.0:
		combo_count = 0

	stasis_remaining = max(stasis_remaining - delta, 0.0)
	powerup_spawn_cooldown = max(powerup_spawn_cooldown - delta, 0.0)
	_update_pressure_director(delta)

	_update_enemy_positions(delta)
	_check_hazard_collisions()
	_check_enemy_collisions()

	if powerup_active and player_position.distance_to(powerup_position) <= PLAYER_RADIUS + POWERUP_RADIUS:
		powerup_active = false
		stasis_remaining = STASIS_DURATION_SECONDS
		time_remaining = min(ROUND_TIME_SECONDS + 20.0, time_remaining + POWERUP_TIME_BONUS)
		state_label.text = "Stasis core collected. Enemy speed reduced."
		_log_run_event("powerup_collected", {
			"x": snapped(player_position.x, 0.01),
			"y": snapped(player_position.y, 0.01),
			"time_remaining": snapped(time_remaining, 0.01)
		})

	if not powerup_active and powerup_spawn_cooldown <= 0.0:
		_spawn_powerup()
		powerup_spawn_cooldown = _get_powerup_interval_from_pressure()

	time_remaining = max(time_remaining - delta, 0.0)
	if time_remaining <= 0.0:
		_end_round("Time elapsed. Press Enter to restart.")

	if state == GameState.PLAYING and player_position.distance_to(target_position) <= PLAYER_RADIUS + TARGET_RADIUS:
		_collect_target()
		_spawn_target()
		_update_difficulty_from_score()

	if lives <= 0 and state == GameState.PLAYING:
		_end_round("All lives lost. Press Enter to restart.")

	_update_hud()
	queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, get_viewport_rect().size)
	draw_rect(rect, Color(0.07, 0.09, 0.14, 1.0), true)

	# Visual frame to make movement boundaries readable without external art assets.
	draw_rect(rect.grow(-8.0), Color(0.16, 0.2, 0.29, 1.0), false, 2.0)

	for hazard in hazards:
		draw_circle(hazard, HAZARD_RADIUS, Color(0.79, 0.22, 0.22, 0.95))
		draw_circle(hazard, HAZARD_RADIUS - 6.0, Color(0.43, 0.1, 0.1, 0.95))

	for enemy in enemies:
		draw_circle(enemy, ENEMY_RADIUS, Color(0.85, 0.38, 0.92, 1.0))

	if powerup_active:
		draw_circle(powerup_position, POWERUP_RADIUS + 3.0, Color(0.52, 0.83, 0.98, 0.25))
		draw_circle(powerup_position, POWERUP_RADIUS, Color(0.36, 0.74, 0.97, 1.0))

	draw_circle(target_position, TARGET_RADIUS, Color(0.96, 0.72, 0.25, 1.0))

	var player_color := Color(0.28, 0.86, 0.74, 1.0)
	if hit_invulnerability_remaining > 0.0:
		var flash := int(Time.get_ticks_msec() / 100) % 2
		player_color = Color(0.95, 0.95, 0.95, 1.0) if flash == 0 else player_color
	draw_circle(player_position, PLAYER_RADIUS, player_color)


func _restart_round(from_restart_prompt: bool) -> void:
	_prepare_round_rng()
	var viewport_size := get_viewport_rect().size
	player_position = viewport_size / 2.0
	time_remaining = ROUND_TIME_SECONDS
	score = 0
	lives = STARTING_LIVES
	level = 1
	combo_count = 0
	combo_timer = 0.0
	hit_invulnerability_remaining = 0.0
	stasis_remaining = 0.0
	powerup_spawn_cooldown = POWERUP_SPAWN_INTERVAL
	powerup_active = false
	state = GameState.PLAYING
	run_elapsed = 0.0
	input_sample_timer = 0.0
	pressure_level = BASE_PRESSURE
	run_trace_events.clear()
	_log_run_event("round_start", {
		"seed": current_run_seed,
		"from_prompt": from_restart_prompt,
		"seed_locked": seed_locked
	})
	_pause_label_visibility(false)
	_rebuild_threat_layout()
	_spawn_target()
	if from_restart_prompt:
		state_label.text = "New run started (seed %d). Secure fast chains." % current_run_seed
	else:
		state_label.text = "Collect targets, avoid threats, and survive. Seed %d." % current_run_seed
	_update_hud()
	queue_redraw()


func _spawn_target() -> void:
	var viewport_size := get_viewport_rect().size
	var min_bound := Vector2(TARGET_RADIUS + EDGE_PADDING, TARGET_RADIUS + EDGE_PADDING)
	var max_bound := viewport_size - min_bound

	for _i in range(12):
		var candidate := Vector2(
			rng.randf_range(min_bound.x, max_bound.x),
			rng.randf_range(min_bound.y, max_bound.y)
		)
		if candidate.distance_to(player_position) < (PLAYER_RADIUS + TARGET_RADIUS + 80.0):
			continue

		var too_close_to_hazard := false
		for hazard in hazards:
			if candidate.distance_to(hazard) < (TARGET_RADIUS + HAZARD_RADIUS + 24.0):
				too_close_to_hazard = true
				break

		if too_close_to_hazard:
			continue

		target_position = candidate
		return

	target_position = viewport_size / 2.0


func _clamp_player_to_viewport() -> void:
	var viewport_size := get_viewport_rect().size
	var min_bound := Vector2(PLAYER_RADIUS + EDGE_PADDING, PLAYER_RADIUS + EDGE_PADDING)
	var max_bound := viewport_size - min_bound
	player_position.x = clamp(player_position.x, min_bound.x, max_bound.x)
	player_position.y = clamp(player_position.y, min_bound.y, max_bound.y)


func _update_hud() -> void:
	score_label.text = "Score: %d" % score
	timer_label.text = "Time: %.1f" % time_remaining
	lives_label.text = "Lives: %d" % lives
	level_label.text = "Level: %d" % level
	combo_label.text = "Combo: x%d" % max(combo_count, 1)
	best_label.text = "Best: %d" % best_score


func _get_move_vector() -> Vector2:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_physical_key_pressed(Key.A):
		vector.x -= 1.0
	if Input.is_physical_key_pressed(Key.D):
		vector.x += 1.0
	if Input.is_physical_key_pressed(Key.W):
		vector.y -= 1.0
	if Input.is_physical_key_pressed(Key.S):
		vector.y += 1.0
	if vector.length() > 1.0:
		vector = vector.normalized()
	return vector


func _toggle_pause() -> void:
	if state == GameState.PAUSED:
		state = GameState.PLAYING
		_pause_label_visibility(false)
		state_label.text = "Run resumed."
	else:
		state = GameState.PAUSED
		_pause_label_visibility(true)
		state_label.text = "Paused. Press Esc to continue."


func _pause_label_visibility(visible_state: bool) -> void:
	pause_label.visible = visible_state


func _collect_target() -> void:
	if combo_timer > 0.0:
		combo_count += 1
	else:
		combo_count = 1
	combo_timer = COMBO_WINDOW_SECONDS

	var points := 1 + int(combo_count / 3)
	score += points
	pressure_level = min(1.0, pressure_level + PRESSURE_TARGET_BONUS + min(0.08, float(combo_count) * PRESSURE_COMBO_BONUS))
	time_remaining = min(ROUND_TIME_SECONDS + 20.0, time_remaining + TARGET_TIME_BONUS)

	if score > best_score:
		best_score = score
		_save_best_score()

	_log_run_event("target_collected", {
		"score": score,
		"combo": combo_count,
		"pressure": snapped(pressure_level, 0.001),
		"time_remaining": snapped(time_remaining, 0.01),
		"x": snapped(target_position.x, 0.01),
		"y": snapped(target_position.y, 0.01)
	})

	state_label.text = "Target secured (+%d). Keep chain alive." % points


func _update_difficulty_from_score() -> void:
	var next_level := 1 + int(score / 6)
	next_level = min(next_level, 8)
	if next_level != level:
		var previous_level := level
		level = next_level
		_rebuild_threat_layout()
		_log_run_event("level_up", {
			"from": previous_level,
			"to": level,
			"score": score,
			"pressure": snapped(pressure_level, 0.001),
			"time_remaining": snapped(time_remaining, 0.01)
		})
		state_label.text = "Threat level %d engaged." % level


func _rebuild_threat_layout() -> void:
	enemies.clear()
	hazards.clear()

	var enemy_count := clamp(2 + level, 2, 9)
	var hazard_count := clamp(1 + int(level / 2), 1, 5)

	for _i in range(enemy_count):
		enemies.append(_get_safe_spawn_point(140.0))

	for _j in range(hazard_count):
		hazards.append(_get_safe_spawn_point(180.0))


func _get_safe_spawn_point(min_distance_from_player: float) -> Vector2:
	var viewport_size := get_viewport_rect().size
	var min_bound := Vector2(EDGE_PADDING + 20.0, EDGE_PADDING + 20.0)
	var max_bound := viewport_size - min_bound

	for _i in range(24):
		var candidate := Vector2(
			rng.randf_range(min_bound.x, max_bound.x),
			rng.randf_range(min_bound.y, max_bound.y)
		)
		if candidate.distance_to(player_position) >= min_distance_from_player:
			return candidate

	return viewport_size * 0.75


func _update_enemy_positions(delta: float) -> void:
	for index in range(enemies.size()):
		var to_player := player_position - enemies[index]
		if to_player.length_squared() == 0.0:
			continue

		var speed := BASE_ENEMY_SPEED + float(level - 1) * ENEMY_SPEED_STEP + float(index) * 4.0
		speed *= (0.82 + pressure_level * 0.7)
		if stasis_remaining > 0.0:
			speed *= 0.35

		enemies[index] += to_player.normalized() * speed * delta
		enemies[index] = _clamp_position(enemies[index], ENEMY_RADIUS)


func _clamp_position(position: Vector2, radius: float) -> Vector2:
	var viewport_size := get_viewport_rect().size
	var min_bound := Vector2(radius + EDGE_PADDING, radius + EDGE_PADDING)
	var max_bound := viewport_size - min_bound
	position.x = clamp(position.x, min_bound.x, max_bound.x)
	position.y = clamp(position.y, min_bound.y, max_bound.y)
	return position


func _check_enemy_collisions() -> void:
	for enemy in enemies:
		if player_position.distance_to(enemy) <= PLAYER_RADIUS + ENEMY_RADIUS:
			_apply_hit("Intercepted by hunter drone.")
			return


func _check_hazard_collisions() -> void:
	for hazard in hazards:
		if player_position.distance_to(hazard) <= PLAYER_RADIUS + HAZARD_RADIUS:
			_apply_hit("Entered hazard field.")
			return


func _apply_hit(message: String) -> void:
	if hit_invulnerability_remaining > 0.0:
		return

	lives -= 1
	hit_invulnerability_remaining = HIT_INVULNERABILITY_SECONDS
	combo_count = 0
	combo_timer = 0.0
	pressure_level = max(0.0, pressure_level - PRESSURE_HIT_PENALTY)
	_log_run_event("player_hit", {
		"reason": message,
		"lives": max(lives, 0),
		"pressure": snapped(pressure_level, 0.001),
		"time_remaining": snapped(time_remaining, 0.01),
		"x": snapped(player_position.x, 0.01),
		"y": snapped(player_position.y, 0.01)
	})
	state_label.text = "%s Lives remaining: %d" % [message, max(lives, 0)]


func _spawn_powerup() -> void:
	powerup_active = true
	powerup_position = _get_safe_spawn_point(120.0)
	_log_run_event("powerup_spawned", {
		"x": snapped(powerup_position.x, 0.01),
		"y": snapped(powerup_position.y, 0.01),
		"pressure": snapped(pressure_level, 0.001),
		"time_remaining": snapped(time_remaining, 0.01)
	})


func _end_round(message: String) -> void:
	state = GameState.ROUND_OVER
	_pause_label_visibility(false)
	_log_run_event("round_end", {
		"reason": message,
		"score": score,
		"lives": max(lives, 0),
		"pressure": snapped(pressure_level, 0.001),
		"time_remaining": snapped(time_remaining, 0.01)
	})
	_write_run_trace(message)
	state_label.text = "%s Final score: %d" % [message, score]


func _load_best_score() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		best_score = 0
		return

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		best_score = 0
		return

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY and parsed.has("best_score"):
		best_score = int(parsed["best_score"])
	else:
		best_score = 0


func _save_best_score() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(JSON.stringify({"best_score": best_score}))


func _configure_seed_mode() -> void:
	var env_seed := OS.get_environment(SEED_ENV_VAR)
	if env_seed.strip_edges() != "":
		seed_base = int(env_seed)
		seed_locked = true
	else:
		seed_base = int(Time.get_unix_time_from_system())
		seed_locked = false


func _prepare_round_rng() -> void:
	if seed_locked:
		current_run_seed = seed_base
	else:
		current_run_seed = seed_base + run_index * 7919
	run_index += 1
	rng.seed = current_run_seed


func _sample_input_vector(delta: float, move_vector: Vector2) -> void:
	input_sample_timer += delta
	if input_sample_timer < INPUT_SAMPLE_INTERVAL_SECONDS:
		return

	input_sample_timer = 0.0
	_log_run_event("input_sample", {
		"x": snapped(move_vector.x, 0.001),
		"y": snapped(move_vector.y, 0.001),
		"player_x": snapped(player_position.x, 0.01),
		"player_y": snapped(player_position.y, 0.01)
	})


func _log_run_event(event_type: String, payload: Dictionary = {}) -> void:
	if run_trace_events.size() >= MAX_TRACE_EVENTS:
		return

	var event: Dictionary = {
		"t": snapped(run_elapsed, 0.001),
		"type": event_type
	}
	for key in payload.keys():
		event[key] = payload[key]
	run_trace_events.append(event)


func _write_run_trace(end_reason: String) -> void:
	var file := FileAccess.open(TRACE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		return

	var trace_payload := {
		"engine": "Godot",
		"project": "Signal Chase",
		"seed": current_run_seed,
		"seed_locked": seed_locked,
		"run_index": run_index,
		"duration_seconds": snapped(run_elapsed, 0.001),
		"score": score,
		"best_score": best_score,
		"level": level,
		"pressure": snapped(pressure_level, 0.001),
		"lives": max(lives, 0),
		"end_reason": end_reason,
		"events": run_trace_events
	}

	file.store_string(JSON.stringify(trace_payload, "\t"))


func _update_pressure_director(delta: float) -> void:
	var pressure_before := pressure_level
	pressure_level = max(0.0, pressure_level - PRESSURE_DECAY_PER_SECOND * delta)
	if stasis_remaining > 0.0:
		pressure_level = max(0.0, pressure_level - PRESSURE_STASIS_RELIEF_PER_SECOND * delta)

	if absf(pressure_before - pressure_level) >= 0.08:
		_log_run_event("pressure_shift", {
			"from": snapped(pressure_before, 0.001),
			"to": snapped(pressure_level, 0.001),
			"time_remaining": snapped(time_remaining, 0.01)
		})


func _get_powerup_interval_from_pressure() -> float:
	return lerp(POWERUP_INTERVAL_MAX, POWERUP_INTERVAL_MIN, pressure_level)
