extends Node3D
class_name Interactable

# Exports
@export var shapeCast: ShapeCast3D
@export var progressBarManager: ProgressBarManager
@export var interactionTime: float = 0.5
var shouldWearHeadset: bool = false
var indicatorPrefab: PackedScene = preload("res://prefabs/indicator.tscn")

# Local vars
var curInteractiontime: float = 0.0
var taskCount: int = 0
var indicators: Array[Node3D] = []
var INDICATOR_GAP: float = 0.3
var INDICATOR_HEIGHT: float = 2.5

# Static vars
static var interactablesInRange: Dictionary = {}
static var currentInteraction: Interactable = null
static var currentTasks: Array[TaskType] = []

func _process(delta: float) -> void:
	checkPlayerInRange()
	handleInteraction(delta)
	showIndicators()

func checkPlayerInRange():
	var player: Node3D = null
	
	if canInteract() && shapeCast.is_colliding():
		for i in range(shapeCast.get_collision_count()):
			if shapeCast.get_collider(i) is PlayerController:
				player = shapeCast.get_collider(i)
	
	if player != null:
		interactablesInRange[self] = (player.position - position).length()
	else:
		if interactablesInRange.has(self):
			interactablesInRange.erase(self)

func handleInteraction(delta: float):
	if currentInteraction == null || currentInteraction != self:
		resetProgress()
		return
	
	curInteractiontime += delta
	progressBarManager.set_visible(true)
	progressBarManager.updateProgress(clamp(curInteractiontime / interactionTime, 0.0, 1.0))
	
	if curInteractiontime >= interactionTime:
		resetProgress()
		interactionComplete()

func resetProgress():
	progressBarManager.set_visible(false)
	curInteractiontime = 0.0
	progressBarManager.updateProgress(0)

func interactionComplete():
	pass
	
func canInteract() -> bool:
	return taskCount > 0

func showIndicators():
	if (indicators.size() < taskCount):
		var indicator: Node3D = indicatorPrefab.instantiate()
		add_child(indicator)
		indicators.append(indicator)
		indicator.position = Vector3.UP * INDICATOR_HEIGHT
		
	if (indicators.size() > 0 && indicators.size() > taskCount):
		var indicator: Node3D = indicators.pop_back()
		remove_child(indicator)
		indicator.queue_free()
	
	if indicators.size() % 2 != 0:
		indicators[0].position.x = 0
		for i in range(1, indicators.size()):
			indicators[i].position.x = (i + 1) / 2 * INDICATOR_GAP * (-1 if i % 2 == 0 else 1)
	else:
		for i in range(0, indicators.size()):
			indicators[i].position.x = ((i / 2) + 0.5) * INDICATOR_GAP * (-1 if i % 2 == 0 else 1)

enum TaskType {
	BUG,
	FEATURE
}
