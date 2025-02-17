extends Interactable
class_name TaskGiver

@export var taskType: TaskType
@export var timeBetweenTasks: float = 10.0

var taskTimer: float = 0.0

func _process(delta: float):
	super._process(delta)
	
	taskTimer -= delta
	if taskTimer <= 0:
		taskCount += 1
		taskTimer = timeBetweenTasks
		

func interactionComplete():
	if taskCount > 0:
		currentTasks.append(taskType)
		taskCount -= 1
