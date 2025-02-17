extends Control

@export var line: Line2D

var SHARE_UPDATE_TIME: float = 3.0
var DIST_BETWEEN_GRAPH_POINTS: float = 20.0
var timer: float = 0
var totalTime: float = 0
var graphWidth: float = 0
var graphHeight: float = 0
var graphPoints: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.position.x = 0.0
	line.position.y = size.y
	graphWidth = size.x
	graphHeight = size.y
	line.clear_points()
	
	line.add_point(Vector2(graphWidth, 0.3 * -graphHeight))
	line.add_point(Vector2(graphWidth, 0.5 * -graphHeight))
	graphPoints.append(totalTime - SHARE_UPDATE_TIME)
	graphPoints.append(totalTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	totalTime += delta

	if timer >= SHARE_UPDATE_TIME:
		timer -= SHARE_UPDATE_TIME
		var yPos = clamp(randfn(0.5, 0.3), 0, 1)
		line.add_point(Vector2(graphWidth, yPos * -graphHeight))
		graphPoints.append(totalTime)

	for i in range(graphPoints.size()):
		line.set_point_position(i, Vector2((graphWidth - ((totalTime - graphPoints[i]) * DIST_BETWEEN_GRAPH_POINTS)), line.points[i].y))
