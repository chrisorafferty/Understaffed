extends Interactable
class_name SocialMedia

@onready var prompt: Node3D = $Prompt

func _process(delta: float):
	if !isInteracting:
		prompt.show()
	else:
		prompt.hide()

func interactionComplete():
	Events.socialMediaPosted.emit()
	Sound.stopSound(Sound.SFX.KEYBOARD)

func interactionStarted():
	Sound.playSoundLoop(Sound.SFX.KEYBOARD)

func interactionCancelled():
	Sound.stopSound(Sound.SFX.KEYBOARD)

func canInteract():
	return true
