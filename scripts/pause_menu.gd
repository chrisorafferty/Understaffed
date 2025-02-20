extends Node

@export var resumeButton: TextureButton
@export var mainMenuButton: TextureButton
@export var quitButton: TextureButton
@export var menuRoot: Control

var paused: bool = false

func _ready() -> void:
	menuRoot.hide()
	
	resumeButton.pressed.connect(resume)
	mainMenuButton.pressed.connect(goToMainMenu)
	quitButton.pressed.connect(quit)

func _process(delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		if paused:
			resume()
		else:
			pause()

func pause():
	menuRoot.show()
	resumeButton.grab_focus()
	Engine.time_scale = 0
	paused = true

func resume():
	menuRoot.hide()
	Engine.time_scale = 1
	paused = false

func goToMainMenu():
	pass

func quit():
	get_tree().quit()
