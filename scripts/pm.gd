extends Interactable
class_name PM

@export var timeBetweenTasks: float = 10.0

var taskTimer: float = 0.0

static var undeliveredFeatures: int = 0

func _process(delta: float):
	super._process(delta)
	
	taskTimer -= delta
	if taskTimer <= 0:
		taskCount += 1
		taskTimer = timeBetweenTasks
	
	undeliveredFeatures = taskCount

func canInteract() -> bool:
	return taskCount > 0 && !PlayerController.hasPickedUpFeature

func interactionComplete():
	if taskCount > 0:
		PlayerController.hasPickedUpFeature = true
		taskCount -= 1
