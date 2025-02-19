extends Interactable
class_name CustomerSupport

var taskTimer: float = 0.0
var timeBetweenTasks: float = 40.0

static var numComplaints: int = 0

func _ready() -> void:
	shouldWearHeadset = true
	taskTimer = timeBetweenTasks

func _process(delta: float) -> void:
	super._process(delta)
	
	taskTimer -= delta * BugManager.aliveBugs.size()
	if taskTimer <= 0:
		taskCount += 1
		taskTimer = timeBetweenTasks
	
	numComplaints = taskCount

func interactionComplete():
	taskCount -= 1
