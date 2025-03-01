extends Interactable

func _process(delta: float):
	super._process(delta)
	
	taskCount = 1 if PlayerController.hasPickedUpFeature else 0

func interactionComplete():
	Events.featureDeveloped.emit()
	Sound.stopSound(Sound.SFX.KEYBOARD)

func interactionStarted():
	Sound.playSoundLoop(Sound.SFX.KEYBOARD)
	
func interactionCancelled():
	Sound.stopSound(Sound.SFX.KEYBOARD)
