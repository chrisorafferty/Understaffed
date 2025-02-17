extends Node
class_name ProgressBarManager

@export var progressPanel: Panel

var maxWidth: int = 0

func _ready():
	maxWidth = progressPanel.size.x

func updateProgress(progress: float):
	progressPanel.size.x = progress * maxWidth
