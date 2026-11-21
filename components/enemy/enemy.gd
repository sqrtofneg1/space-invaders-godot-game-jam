class_name Enemy
extends CharacterBody2D


signal destroyed

const PROJECTILE_SCENE := preload("uid://dpieyslanfybp") as PackedScene

@onready var shoot_sfx: AudioStreamPlayer = %ShootSFX
@onready var projectile_spawn_position: Marker2D = %ProjectileSpawnPosition


var move_speed: float = 320.0
var move_speed_down: float = 10
var move_speed_randomizer: float = 1.0
var min_decision_time: float = 0.5
var max_decision_time: float = 2.0

var direction: float = 0.0
var decision_timer: float = 0.0

# Fire projectile
func shoot() -> void:
	var game := get_tree().current_scene
	var projectile := PROJECTILE_SCENE.instantiate() as Projectile
	projectile.direction = Vector2.DOWN
	projectile.set_collision_mask_player()
	projectile.modulate = Color.AQUA
	game.add_child(projectile)
	projectile.global_position = projectile_spawn_position.global_position
	shoot_sfx.play()


# Take damage (destroyed)
func hit() -> void:
	destroyed.emit()
	queue_free()


func _physics_process(delta: float) -> void:
	decision_timer -= delta
	if decision_timer <= 0.0:
		_pick_random_direction()

	if not is_on_floor():
		velocity.y += move_speed_down * delta * move_speed_randomizer

	velocity.x = direction * move_speed * move_speed_randomizer
	move_and_slide()


func _pick_random_direction() -> void:
	# -1 = left, 0 = idle/pause, 1 = right
	var choices := [-1.0, 0.0, 1.0]
	direction = choices.pick_random()
	move_speed_randomizer = randf_range(0.75, 1.25)
	decision_timer = randf_range(min_decision_time, max_decision_time)
