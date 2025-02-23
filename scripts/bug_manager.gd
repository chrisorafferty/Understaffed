extends Node
class_name BugManager

var spawnPoints: Array[Node3D]
var spawnTimer: float = 0
var timeBetweenSpawns: float = 15.0
var bugPrefab: PackedScene = preload("res://prefabs/bug.tscn")

static var aliveBugs: Array[BugController] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		spawnPoints.append(child)
	
	spawnTimer = timeBetweenSpawns
	Events.bugSquashed.connect(onBugKilled)
	aliveBugs = []

func onBugKilled(bug: BugController):
	aliveBugs.erase(bug)
	if aliveBugs.size() == 0:
		Sound.stopSound(Sound.SFX.BUG_RUN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.isGameOver: return
	
	spawnTimer -= delta
	
	if spawnTimer <= 0:
		var bug: BugController = bugPrefab.instantiate()
		add_child(bug)
		aliveBugs.append(bug)
		bug.position = spawnPoints[randi_range(0, spawnPoints.size() - 1)].position
		spawnTimer = timeBetweenSpawns
		Sound.playSoundLoop(Sound.SFX.BUG_RUN)
