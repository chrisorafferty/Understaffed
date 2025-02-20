extends Control

@export var playAgainButton: Button
@export var mainMenuButton: Button
@export var quitButton: Button
@export var menuRoot: Control

func _ready() -> void:
	menuRoot.hide()
	Events.gameOver.connect(onGameOver)
	
	playAgainButton.pressed.connect(restartScene)
	mainMenuButton.pressed.connect(goToMainMenu)
	quitButton.pressed.connect(quit)

func onGameOver():
	menuRoot.show()
	playAgainButton.grab_focus()

func restartScene():
	get_tree().reload_current_scene()

func goToMainMenu():
	pass

func quit():
	get_tree().quit()
