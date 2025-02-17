extends Control

@export var line: Line2D

var SHARE_UPDATE_TIME: float = 3.0
var DIST_BETWEEN_GRAPH_POINTS: float = 0.05
var timer: float = 0
var totalTime: float = 0
var graphPoints: Array[GraphPoint] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.clear_points()
	
	line.add_point(Vector2(size.x, 0.3 * -size.y))
	line.add_point(Vector2(size.x, 0.5 * -size.y))
	graphPoints.append(GraphPoint.new(totalTime - SHARE_UPDATE_TIME, 0.3))
	graphPoints.append(GraphPoint.new(totalTime, 0.5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	totalTime += delta
	
	line.position.x = 0.0
	line.position.y = size.y

	if timer >= SHARE_UPDATE_TIME:
		timer -= SHARE_UPDATE_TIME
		var yPos = clamp(randfn(0.5, 0.3), 0, 1)
		line.add_point(Vector2(size.x, yPos * -size.y))
		graphPoints.append(GraphPoint.new(totalTime, yPos))

	for i in range(graphPoints.size()):
		line.set_point_position(i, Vector2((size.x - ((totalTime - graphPoints[i].time) * DIST_BETWEEN_GRAPH_POINTS * size.x)),  graphPoints[i].y * -size.y))

class GraphPoint:
	var time: float
	var y: float
	
	func _init(_time: float, _y: float):
		time = _time
		y = _y
