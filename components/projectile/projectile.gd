class_name Projectile
extends Area2D


var direction: Vector2 = Vector2.RIGHT
var speed: float = 750.0


# Connect signals
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Move using velocity and check for collisions
func _physics_process(delta: float) -> void:
	var velocity := direction * speed * delta
	position += velocity


# Only hit player, to be called by enemies shooting
func set_collision_mask_player() -> void:
	collision_mask = 2


# Only hit enemies, to be called by player shooting
func set_collision_mask_enemy() -> void:
	collision_mask = 4


# Attempt to damage what was hit
func _on_body_entered(body: Object) -> void:
	if body is Player or body is Enemy:
		body.hit()
		queue_free()
