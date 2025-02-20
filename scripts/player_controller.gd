extends CharacterBody3D
class_name PlayerController

const MAX_SPEED: float = 12.0
const LOW_ENERGY_MAX_SPEED = 7.0
const ACCELERATION: float = 3.0
const DECELERATION: float = 1.0

const MAX_ROTATION: float = 20.0
const LOW_ENERGY_ROTATION: float = -15.0

const MAX_ENERGY: float = 40.0
var energy: float = MAX_ENERGY
var scaledEnergy: float = 1
static var hasPickedUpFeature: bool = false

@onready var headset: Node3D = $Visuals/headset
@onready var visuals: Node3D = $Visuals

var isGameOver: bool = false

func _ready():
	Events.drankCoffee.connect(onDrinkCoffee)
	Events.gameOver.connect(onGameOver)
	Events.featureDeveloped.connect(onFeatureDeveloped)
	Engine.time_scale = 1
	hasPickedUpFeature = false

func _process(delta: float) -> void:
	handleInteractions()

func _physics_process(delta: float) -> void:

	velocity.x = move_toward(velocity.x, 0, DECELERATION)
	velocity.z = move_toward(velocity.z, 0, DECELERATION)
	
	var oldAngle = visuals.rotation_degrees.x

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = getInputDir()
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = velocity.x + direction.x * ACCELERATION
		velocity.z = velocity.z + direction.z * ACCELERATION
		
	var maxSpeed = lerpf(LOW_ENERGY_MAX_SPEED, MAX_SPEED, scaledEnergy)
		
	if velocity.length() > maxSpeed:
		velocity = velocity.normalized() * maxSpeed
	
	var targetForwardDir = velocity if velocity else -visuals.transform.basis.z
	targetForwardDir.y = 0
	targetForwardDir = targetForwardDir.normalized()
	
	var rightDir = targetForwardDir.cross(Vector3.UP)
	var targetDir = targetForwardDir.rotated(rightDir, deg_to_rad(getTargetAngle(maxSpeed)))
	
	var targetBasis = Basis.looking_at(targetDir)
	visuals.basis = visuals.basis.slerp(targetBasis, clamp(delta, 0, 1) * 20)
	
	energy -= delta * velocity.length() / maxSpeed
	scaledEnergy = Easing.easeOutQuad(clamp(energy / MAX_ENERGY, 0, 1))
	
	move_and_slide()

func onDrinkCoffee():
	energy = MAX_ENERGY

func onFeatureDeveloped():
	hasPickedUpFeature = false
	
func onGameOver():
	isGameOver = true
	Engine.time_scale = 0.1

func getInputDir() -> Vector2:
	if isGameOver:
		return Vector2.ZERO
	
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

func getTargetAngle(curMaxSped: float) -> float:
	if isGameOver:
		return 89
	
	var maxRotation = lerpf(LOW_ENERGY_ROTATION, MAX_ROTATION, scaledEnergy)
	
	if maxRotation < 0:
		return maxRotation

	return clamp(velocity.length() / curMaxSped, 0.0, 1.0) * maxRotation

func handleInteractions():
	var closestInteractable: Interactable = null
	var smallestDist: float = 10000000.0
	for key in Interactable.interactablesInRange:
		if Interactable.interactablesInRange[key] < smallestDist:
			smallestDist = Interactable.interactablesInRange[key]
			closestInteractable = key
	
	if Input.is_action_pressed("interact"):
		Interactable.currentInteraction = closestInteractable
	else:
		Interactable.currentInteraction = null
	
	if closestInteractable != null:
		headset.visible = closestInteractable.shouldWearHeadset
	else:
		headset.visible = false
