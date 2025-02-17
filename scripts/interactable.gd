extends Node3D
class_name Interactable

# Exports
@export var shapeCast: ShapeCast3D
@export var progressBarManager: ProgressBarManager
@export var interactionTime: float = 0.5

# Local vars
var curInteractiontime: float = 0.0
var finishedInteraction: bool = false

# Static vars
static var interactablesInRange: Dictionary = {}
static var currentInteraction: Interactable = null

func _process(delta: float) -> void:
	checkPlayerInRange()
	handleInteraction(delta)

func checkPlayerInRange():
	var player: Node3D = null
	
	if shapeCast.is_colliding():
		for i in range(shapeCast.get_collision_count()):
			if shapeCast.get_collider(i) is PlayerController:
				player = shapeCast.get_collider(i)
	
	if player != null:
		interactablesInRange[self] = (player.position - position).length()
	else:
		if interactablesInRange.has(self):
			interactablesInRange.erase(self)

func handleInteraction(delta: float):
	if currentInteraction != self:
		progressBarManager.set_visible(false)
		curInteractiontime = 0.0
		finishedInteraction = false
		return
	
	curInteractiontime += delta
	if (!finishedInteraction):
		progressBarManager.set_visible(true)
		progressBarManager.updateProgress(clamp(curInteractiontime / interactionTime, 0.0, 1.0))
	
	if !finishedInteraction && curInteractiontime >= interactionTime:
		finishedInteraction = true
		progressBarManager.set_visible(false)
		print("Done!")
