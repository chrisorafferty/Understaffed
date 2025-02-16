extends CharacterBody3D

const MAX_SPEED: float = 12.0
const ACCELERATION: float = 3.0
const DECELERATION: float = 1.0

const MAX_ROTATION: float = 20.0

@export var visuals: Node3D

func _physics_process(delta: float) -> void:

	velocity.x = move_toward(velocity.x, 0, DECELERATION)
	velocity.z = move_toward(velocity.z, 0, DECELERATION)
	
	var oldAngle = visuals.rotation_degrees.x

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = velocity.x + direction.x * ACCELERATION
		velocity.z = velocity.z + direction.z * ACCELERATION
		velocity.x = minf(velocity.x, MAX_SPEED) if velocity.x > 0 else maxf(velocity.x, -MAX_SPEED)
		velocity.z = minf(velocity.z, MAX_SPEED) if velocity.z > 0 else maxf(velocity.z, -MAX_SPEED)
	
	var targetForwardDir = velocity if velocity else -visuals.transform.basis.z
	targetForwardDir.y = 0
	targetForwardDir = targetForwardDir.normalized()
	
	var rightDir = targetForwardDir.cross(Vector3.UP)
	var targetDir = targetForwardDir.rotated(rightDir, deg_to_rad(clamp(velocity.length() / MAX_SPEED, 0.0, 1.0) * MAX_ROTATION))
	var targetBasis = Basis.looking_at(targetDir)
	visuals.basis = visuals.basis.slerp(targetBasis, 0.5)
	
	move_and_slide()
