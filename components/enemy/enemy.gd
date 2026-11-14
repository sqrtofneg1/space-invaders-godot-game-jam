class_name Enemy
extends CharacterBody2D


signal destroyed

const PROJECTILE_SCENE := preload("uid://dpieyslanfybp") as PackedScene

@onready var shoot_sfx: AudioStreamPlayer = %ShootSFX
@onready var projectile_spawn_position: Marker2D = %ProjectileSpawnPosition


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
