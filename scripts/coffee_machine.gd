extends Interactable
class_name CoffeeMachine

var brewTimer: float = 0.0
var brewTime: float = 10.0
var isBrewing: bool = false
@onready var coffeeVisuals: Node3D = $mug/Coffee

func _ready():
	indicatorMiddle = Vector3(1.9, 2.5, 0)

func _process(delta: float) -> void:
	super._process(delta)
	
	if isBrewing:
		brewTimer += delta
	coffeeVisuals.scale.y = clamp(brewTimer / brewTime, 0, 1)
	
	var coffeeFinishedBrewing = isBrewing && brewTimer >= brewTime
	
	taskCount = 1 if coffeeFinishedBrewing else 0

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
