extends Node2D

@onready var main_menu_audio_player: AudioStreamPlayer2D = %MainMenuAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_audio_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")
	main_menu_audio_player.stop()
