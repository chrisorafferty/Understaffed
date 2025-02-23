extends Control
class_name ShareController

@export var line: Line2D
@export var alertLine: Line2D
@export var alertLineColour: Color
@export var alertLightColour: Color
@export var lights: Array[OmniLight3D]
@export var priceText: Label

@onready var normalLineColour: Color
@onready var normalLightColour: Color

const SHARE_UPDATE_TIME: float = 3.0
const DIST_BETWEEN_GRAPH_POINTS: float = 0.02
const MIN_MAX_SHARE_PRICE: float = 300
const SHARE_LOSS_PER_BUG: float = 2
const SHARE_LOSS_PER_COMPLAINT: float = 5
const SHARE_LOSS_PER_UNDELIVERED_FEATURE: float = 2
const SHARE_GAIN_PER_FEATURE: float = 15.0
const SHARE_GAIN_PER_ADVERTISEMENT: float = 25.0
var timer: float = 0
var totalTime: float = 0
var timeSinceLastFeature: float = 0
var graphPoints: Array[GraphPoint] = []
var sharePrice: float = MIN_MAX_SHARE_PRICE / 2

var shareAlertAmount: float = 80

func _ready() -> void:
	line.clear_points()
	alertLine.clear_points()
	normalLineColour = line.default_color
	normalLightColour = lights[0].light_color
	
	line.add_point(Vector2(size.x, 0.3 * -size.y))
	line.add_point(Vector2(size.x, 0.5 * -size.y))
	
	alertLine.add_point(Vector2.ZERO)
	alertLine.add_point(Vector2.ZERO)
	
	graphPoints.append(GraphPoint.new(totalTime - SHARE_UPDATE_TIME, 0.3))
	graphPoints.append(GraphPoint.new(totalTime, 0.5))
	
	Events.featureDeveloped.connect(onFeatureDeveloped)
	Events.socialMediaPosted.connect(onSocialMediaPosted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	totalTime += delta
	
	line.position.x = 0.0
	line.position.y = size.y
	alertLine.position.x = 0.0
	alertLine.position.y = size.y
	
	var curMaxPrice: float = maxf(MIN_MAX_SHARE_PRICE, sharePrice)
	
	if timer >= SHARE_UPDATE_TIME:
		calculateSharePrice()
		timer -= SHARE_UPDATE_TIME
		var yPos: float = clamp(sharePrice / curMaxPrice, 0, 1)
		line.add_point(Vector2(size.x, yPos * -size.y))
		graphPoints.append(GraphPoint.new(totalTime, yPos))
	
	for i in range(graphPoints.size()):
		line.set_point_position(i, Vector2((size.x - ((totalTime - graphPoints[i].time) * DIST_BETWEEN_GRAPH_POINTS * size.x)),  graphPoints[i].y * -size.y))
		
		line.default_color = alertLineColour if sharePrice < shareAlertAmount else normalLineColour
		for light in lights:
			light.light_color = alertLightColour if sharePrice < shareAlertAmount else normalLightColour
	
	var alertLineYPos: float = shareAlertAmount / curMaxPrice * -size.y
	alertLine.set_point_position(0, Vector2(0, alertLineYPos))
	alertLine.set_point_position(1, Vector2(size.x, alertLineYPos))
	
	priceText.text = "$%d" % int(sharePrice)

func calculateSharePrice():
	var bugLoss: float = BugManager.aliveBugs.size() * SHARE_LOSS_PER_BUG
	var complaintLoss: float = CustomerSupport.numComplaints * SHARE_LOSS_PER_COMPLAINT
	var undeliveredFeaturesLoss: int = PM.undeliveredFeatures * SHARE_LOSS_PER_UNDELIVERED_FEATURE
	sharePrice -= bugLoss + complaintLoss + undeliveredFeaturesLoss
	
	if sharePrice <= 0:
		Events.gameOver.emit()

func onSocialMediaPosted():
	sharePrice += SHARE_GAIN_PER_ADVERTISEMENT

func onFeatureDeveloped():
	sharePrice += SHARE_GAIN_PER_FEATURE

class GraphPoint:
	var time: float
	var y: float
	
	func _init(_time: float, _y: float):
		time = _time
		y = _y
