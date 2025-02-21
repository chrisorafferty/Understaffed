extends Node

var isGameRunning: bool = true
var isGameOver: bool = false

func onMainSceneLoad() -> void:
	isGameRunning = true
	isGameOver = false
	
	Events.gameOver.connect(onGameOver)
	Events.gamePaused.connect(onGamePause)
	
	Engine.time_scale = 1

func onGamePause(paused: bool):
	isGameRunning = !paused
	
	if paused:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1

func onGameOver():
	isGameRunning = false
	isGameOver = true
	Engine.time_scale = 0.1
