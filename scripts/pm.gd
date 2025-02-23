extends Interactable
class_name PM

var timeBetweenTasks: float = 20.0
var taskTimer: float = 0.0

static var undeliveredFeatures: int = 0

@onready var speechBubble: Node3D = $SpeechBubble
@onready var speechBubbleText: Label3D = $SpeechBubble/Speech

var featureIdeas: Array[String] = [
	"How about you just create a new AI model for us to use",
	"Can you just set up authentication for us real quick",
	"Can you run an A/B test real quick about whether customers like us charging $80 extra?",
	"Can you quickly implement integration with facebook and instagram and myspace",
]

var featurePrompt: String = "Head over to your laptop and implement that ASAP before our share price drops to $0!!!"

func _ready() -> void:
	undeliveredFeatures = 0
	speechBubble.hide()

func _process(delta: float):
	super._process(delta)
	
	taskTimer -= delta
	if taskTimer <= 0:
		taskCount += 1
		taskTimer = timeBetweenTasks
	
	undeliveredFeatures = taskCount
	
	if PlayerController.hasPickedUpFeature:
		speechBubble.show()
		speechBubbleText.text = featurePrompt
	
	if speechBubble.visible && !PlayerController.hasPickedUpFeature && speechBubbleText.text == featurePrompt:
		speechBubble.hide()
	
	if !speechBubble.visible && taskCount > 0 && !isInteracting:
		speechBubble.show()
		speechBubbleText.text = featureIdeas.pick_random()

func canInteract() -> bool:
	return taskCount > 0 && !PlayerController.hasPickedUpFeature

func interactionComplete():
	if taskCount > 0:
		PlayerController.hasPickedUpFeature = true
		taskCount -= 1
	
	Sound.stopSound(Sound.SFX.PM_YAP)

func interactionStarted():
	Sound.playSoundLoop(Sound.SFX.PM_YAP)
	speechBubble.hide()
	
func interactionCancelled():
	Sound.stopSound(Sound.SFX.PM_YAP)
