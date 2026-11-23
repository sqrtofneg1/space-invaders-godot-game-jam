class_name Game
extends Node2D


var enemies: Array[Enemy] = []

@onready var enemy_shoot_timer: Timer = %EnemyShootTimer
@onready var enemy_container: Node2D = %EnemyContainer
@onready var announcement_label: Label = %AnnouncementLabel
@onready var game_restart_delay: Timer = %GameRestartDelay
@onready var player: Player = %Player
@onready var hit_sfx: AudioStreamPlayer = %HitSFX
@onready var victory_sfx: AudioStreamPlayer = %VictorySFX
@onready var spawn_point: Marker2D = %SpawnPoint
const ENEMY = preload("res://components/enemy/enemy.tscn")
@onready var hud_player_name: Label = %HudPlayerName
@onready var hud_ship_name: Label = %HudShipName

# Game setup
func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	_do_dialog(GameState.level)
	enemy_shoot_timer.timeout.connect(_on_enemy_shoot_timer_timeout)
	game_restart_delay.timeout.connect(_on_game_restart_delay_timeout)
	player.destroyed.connect(_on_player_destroyed)
	_add_enemies(5)

func _on_dialogue_started(_resource: DialogueResource) -> void:
	get_tree().paused = true

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	get_tree().paused = false

func _next_level() -> void:
	if GameState.level == 3:
		victory()
		return
	GameState.level += 1
	_do_dialog(GameState.level)
	enemy_shoot_timer.timeout.connect(_on_enemy_shoot_timer_timeout)
	game_restart_delay.timeout.connect(_on_game_restart_delay_timeout)
	player.destroyed.connect(_on_player_destroyed)
	_add_enemies(5 * GameState.level)


# Restart game by reloading the current scene
func restart() -> void:
	pass


# Check for victory by all enemies destroyed (unless already game over)
func check_for_victory() -> void:
	if not enemies.is_empty() or not game_restart_delay.is_stopped():
		return
	for timer in get_tree().get_nodes_in_group("enemy_spawn_timers"):
		if timer is Timer and not timer.is_stopped():
			return
	_next_level()
	#announcement_label.text = "VICTORY"
	#game_restart_delay.start()
	#victory_sfx.play()

func victory() -> void:
	announcement_label.text = "And so, {name} annihilated the entire alien race.\nVICTORY?".format({"name": GameState.real_player_name})
	victory_sfx.play()


# Play SFX on enemy destroyed and check for victory
func _on_enemy_destroyed(enemy: Enemy) -> void:
	hit_sfx.play()
	enemies.erase(enemy)
	check_for_victory()


# Random enemy shoots every X seconds
func _on_enemy_shoot_timer_timeout() -> void:
	if enemies.is_empty():
		return
	
	var enemy := enemies.pick_random() as Enemy
	enemy.shoot()


# Restart game after a few seconds have passed
func _on_game_restart_delay_timeout() -> void:
	restart()


# Game over (unless victory is already playing out)
func _on_player_destroyed() -> void:
	hit_sfx.play()
	
	if not game_restart_delay.is_stopped():
		return
	
	announcement_label.text = "GAME OVER"
	enemy_shoot_timer.stop()
	game_restart_delay.start()


func _add_enemies(number_to_add: int) -> void:
	print("in add enemies")
	for i in number_to_add:
		var timer = Timer.new()
		timer.add_to_group("enemy_spawn_timers")
		timer.wait_time = i + 0.5
		timer.timeout.connect(_spawn_enemy)
		timer.one_shot = true
		timer.autostart = true
		add_child(timer)

func _spawn_enemy() -> void:
	var new_enemy = ENEMY.instantiate()
	enemy_container.add_child(new_enemy)
	new_enemy.global_position = spawn_point.global_position
	new_enemy.global_position.x = randf_range(10, 1800)
	enemies.append(new_enemy)
	new_enemy.destroyed.connect(_on_enemy_destroyed.bind(new_enemy))
	if GameState.level < 3:
		hud_player_name.text = GameState.player_name
		hud_ship_name.text = GameState.player_ship_name
	else:
		hud_player_name.text = GameState.real_player_name
		hud_ship_name.text = GameState.real_player_ship_name

func _on_bottom_boundary_body_entered(body: Node2D) -> void:
	print(body.position)
	if body is Enemy:
		body.global_position.y = spawn_point.global_position.y


func _do_dialog(level: int) -> void:
	DialogueManager.show_dialogue_balloon(load("res://mission{level}.dialogue".format({"level":level})))
	
