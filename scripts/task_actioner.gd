extends Interactable

@export var allowedTasks: Array[TaskType] = []

func _process(delta: float):
	super._process(delta)
	
	taskCount = getActionableTasks().size()
		

func interactionComplete():
	var curTaskType = getActionableTasks().front()
	
	if (curTaskType != null):
		currentTasks.erase(curTaskType)
	
func getActionableTasks() -> Array[TaskType]:
	return currentTasks.filter(func(task): return allowedTasks.has(task))
