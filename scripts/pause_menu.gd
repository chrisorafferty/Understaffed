extends Node

@export var resumeButton: TextureButton
@export var mainMenuButton: TextureButton
@export var quitButton: TextureButton
@export var menuRoot: Control

var paused: bool = false

func _ready() -> void:
	GameManager.onMainSceneLoad()
	menuRoot.hide()
	
	resumeButton.pressed.connect(resume)
	mainMenuButton.pressed.connect(goToMainMenu)
	quitButton.pressed.connect(quit)

func _process(delta: float):
	if GameManager.isGameOver: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if paused:
			resume()
		else:
			pause()

func pause():
	menuRoot.show()
	resumeButton.grab_focus()
	paused = true
	Events.gamePaused.emit(true)

func resume():
	menuRoot.hide()
	paused = false
	Events.gamePaused.emit(false)

func goToMainMenu():
	pass

func quit():
	get_tree().quit()
