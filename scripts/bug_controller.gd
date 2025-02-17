extends Node3D
class_name BugController

@export var shapeCast: ShapeCast3D

const MAX_DIST: float = 8.0
const MOVE_SPEED: float = 5.0
var target: Vector3 = Vector3.ZERO

var squashed: bool = false

func _ready():
	chooseTarget()

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
			if shapeCast.get_collider(i) is PlayerController:
				squashed = true

func chooseTarget():
	target = Vector3(randf_range(-MAX_DIST, MAX_DIST), 0, randf_range(-MAX_DIST, MAX_DIST))
