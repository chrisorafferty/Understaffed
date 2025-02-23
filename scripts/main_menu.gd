extends Control

@export var playButton: TextureButton
@export var quitButton: TextureButton

func _ready() -> void:
	
	playButton.pressed.connect(playGame)
	quitButton.pressed.connect(quit)

func playGame():
	get_tree().change_scene_to_file("res://main.tscn")

func quit():
	get_tree().quit()
