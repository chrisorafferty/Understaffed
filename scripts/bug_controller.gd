extends Node3D
class_name BugController

@export var shapeCast: ShapeCast3D

const MAX_DIST: float = 8.0
const MOVE_SPEED: float = 5.0
var target: Vector3 = Vector3.ZERO

@onready var aliveVisuals: Node3D = $cockroach
@onready var squashedVisuals: Node3D = $cockroach_squashed

var squashed: bool = false

func _ready():
	chooseTarget()
	aliveVisuals.show()
	squashedVisuals.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if squashed:
		return
	
	var moveDir: Vector3 = (target - position).normalized()
	look_at(position + moveDir)
	position += moveDir * MOVE_SPEED * delta
	
	if ((target - position).length_squared() < 0.2):
		chooseTarget()
	
	var player: Node3D = null
	
	if shapeCast.is_colliding():
		for i in range(shapeCast.get_collision_count()):
			if shapeCast.get_collider(i) is PlayerController && shapeCast.get_collider(i).velocity:
				squashed = true
				aliveVisuals.hide()
				squashedVisuals.show()
				Events.bugSquashed.emit(self)
				Sound.playSound(Sound.SFX.BUG_SQUISH)

func chooseTarget():
	target = Vector3(randf_range(-MAX_DIST, MAX_DIST), 0, randf_range(-MAX_DIST, MAX_DIST))
