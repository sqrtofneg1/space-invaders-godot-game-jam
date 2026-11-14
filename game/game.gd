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


# Game setup
func _ready() -> void:
	# Hook up all enemies in the enemy container node
	for child in enemy_container.get_children():
		if child is Enemy:
			child.destroyed.connect(_on_enemy_destroyed.bind(child))
			enemies.append(child)
	
	# Signals
	enemy_shoot_timer.timeout.connect(_on_enemy_shoot_timer_timeout)
	game_restart_delay.timeout.connect(_on_game_restart_delay_timeout)
	player.destroyed.connect(_on_player_destroyed)


# Restart game by reloading the current scene
func restart() -> void:
	get_tree().reload_current_scene()


# Check for victory by all enemies destroyed (unless already game over)
func check_for_victory() -> void:
	if not enemies.is_empty() or not game_restart_delay.is_stopped():
		return
	
	announcement_label.text = "VICTORY"
	game_restart_delay.start()
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
