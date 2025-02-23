extends Control

@export var playAgainButton: TextureButton
@export var mainMenuButton: TextureButton
@export var quitButton: TextureButton
@export var menuRoot: Control
@export var timeText: Label
@export var featureText: Label
@export var bugText: Label
@export var coffeeText: Label

var time: float = 0
var featureCount: int = 0
var bugCount: int = 0
var coffeeCount: int = 0

func _ready() -> void:
	menuRoot.hide()
	Events.gameOver.connect(onGameOver)
	Events.bugSquashed.connect(onBugSquashed)
	Events.featureDeveloped.connect(onFeatureDeveloped)
	Events.drankCoffee.connect(onDrankCoffee)
	
	playAgainButton.pressed.connect(restartScene)
	mainMenuButton.pressed.connect(goToMainMenu)
	quitButton.pressed.connect(quit)

func _process(delta: float) -> void:
	time += delta

func onGameOver():
	menuRoot.show()
	playAgainButton.grab_focus()
	
	var timeFloored: int = int(time)

	timeText.text = "- You survived for %d seconds" % timeFloored
	featureText.text = "- You developed %d feature%s" % [featureCount, "" if featureCount == 1 else "s"]
	bugText.text = "- You squashed %d bug%s" % [bugCount, "" if bugCount == 1 else "s"]
	coffeeText.text = "- You drank %d coffee%s" % [coffeeCount, "" if coffeeCount == 1 else "s"]
	
func onDrankCoffee():
	coffeeCount += 1

func onBugSquashed(bug: BugController):
	bugCount += 1

func onFeatureDeveloped():
	featureCount += 1

func restartScene():
	get_tree().reload_current_scene()

func goToMainMenu():
	get_tree().change_scene_to_file("res://main_menu.tscn")

func quit():
	get_tree().quit()
