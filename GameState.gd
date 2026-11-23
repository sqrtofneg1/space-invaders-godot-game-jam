extends Node

var player_name: String = ""
var player_ship_name: String = ""
var real_player_name: String = ""
var real_player_ship_name: String = ""
var level: int = 1

func _get_os_env_variables() -> void:
	if OS.has_environment("USERNAME"):
		real_player_name = OS.get_environment("USERNAME")
	if OS.has_environment("COMPUTERNAME"):
		real_player_ship_name = OS.get_environment("COMPUTERNAME")
	elif OS.has_environment("HOSTNAME"):
		real_player_ship_name = OS.get_environment("HOSTNAME")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_os_env_variables()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
