extends Interactable
class_name CoffeeMachine

var brewTimer: float = 0.0
var brewTime: float = 10.0
var isBrewing: bool = false

@onready var coffeeVisuals: Node3D = $mug/Coffee
@onready var coffeeStream: Node3D = $mug/CoffeeStream

@onready var prompt: Node3D = $Prompt
@onready var powerPrompt: Node3D = $Prompt/Power
@onready var brewProgressPrompt: Node3D = $Prompt/Progress
@onready var brewProgressBar: TextureProgressBar = $Prompt/SubViewport/TextureProgressBar

var hadCoffeeFinishedBrewing: bool = false

func _ready():
	indicatorMiddle = Vector3(1.9, 2.5, 0)
	prompt.hide()
	powerPrompt.hide()
	brewProgressPrompt.hide()
	
	brewProgressBar.value = 0

func _process(delta: float) -> void:
	super._process(delta)
	
	var coffeeFinishedBrewing = isBrewing && brewTimer >= brewTime
	
	if coffeeFinishedBrewing && !hadCoffeeFinishedBrewing:
		Sound.stopSound(Sound.SFX.COFFEE)

	if isBrewing && !coffeeFinishedBrewing:
		brewTimer += delta
		coffeeStream.show()
	else:
		coffeeStream.hide()
	
	coffeeVisuals.scale.y = clamp(brewTimer / brewTime, 0, 1)
	
	taskCount = 1 if coffeeFinishedBrewing else 0
	
	brewProgressBar.value = brewTimer / brewTime * 100
	
	if Interactable.closestInteractable == self && !isBrewing:
		prompt.show()
		powerPrompt.show()
		brewProgressPrompt.hide()
	elif isBrewing && !coffeeFinishedBrewing:
		prompt.show()
		powerPrompt.hide()
		brewProgressPrompt.show()
	else:
		prompt.hide()
		powerPrompt.hide()
		brewProgressPrompt.hide()
		
	hadCoffeeFinishedBrewing = coffeeFinishedBrewing
		
func canInteract() -> bool:
	return !isBrewing || brewTimer >= brewTime
	
func interactionComplete():
	if isBrewing && brewTimer >= brewTime:
		isBrewing = false
		brewTimer = 0 
		Events.drankCoffee.emit()
	elif !isBrewing:
		isBrewing = true
		brewTimer = 0
		Sound.playSound(Sound.SFX.COFFEE)
