extends Interactable
class_name CustomerSupport

var taskTimer: float = 0.0
var timeBetweenTasks: float = 40.0

static var numComplaints: int = 0

@onready var prompt: Node3D = $Prompt

func _ready() -> void:
	shouldWearHeadset = true
	taskTimer = timeBetweenTasks
	numComplaints = 0
	prompt.hide()

func _process(delta: float) -> void:
	super._process(delta)
	
	taskTimer -= delta * BugManager.aliveBugs.size()
	if taskTimer <= 0:
		taskCount += 1
		taskTimer = timeBetweenTasks
	
	numComplaints = taskCount
	
	if taskCount > 0:
		prompt.show()
	else:
		prompt.hide()

func interactionComplete():
	taskCount -= 1
	Sound.stopSound(Sound.SFX.CS_YAP)

func interactionStarted():
	Sound.playSoundLoop(Sound.SFX.CS_YAP)
	
func interactionCancelled():
	Sound.stopSound(Sound.SFX.CS_YAP)
