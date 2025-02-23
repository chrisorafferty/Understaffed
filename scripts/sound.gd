extends Node
class_name Sound

static var instance: Sound

@onready var audioPlayers: Dictionary = {
	SFX.KEYBOARD: $KeyboardAudio,
	SFX.COFFEE: $CoffeeAudio,
	SFX.MOVEMENT: $MovementAudio,
	SFX.PM_YAP: $PmYapAudio,
	SFX.CS_YAP: $CsYapAudio,
	SFX.BUG_SQUISH: $BugSquishAudio,
	SFX.BUG_RUN: $BugRunAudio
}

var audioFiles: Dictionary = {
	SFX.KEYBOARD: [
		preload("res://sfx/keyboard1.wav"),
		preload("res://sfx/keyboard2.wav"),
		preload("res://sfx/keyboard3.wav"),
		preload("res://sfx/keyboard4.wav"),
		preload("res://sfx/keyboard5.wav"),
		preload("res://sfx/keyboard6.wav"),
		preload("res://sfx/keyboard.wav")
	],
	SFX.PM_YAP: [
		preload("res://sfx/pm_talking1.wav"),
		preload("res://sfx/pm_talking2.wav"),
		preload("res://sfx/pm_talking3.wav"),
		preload("res://sfx/pm_talking4.wav")
	],
	SFX.CS_YAP: [
		preload("res://sfx/angry_yapping1.wav"),
		preload("res://sfx/angry_yapping2.wav"),
		preload("res://sfx/angry_yapping3.wav"),
		preload("res://sfx/angry_yapping4.wav"),
		preload("res://sfx/angry_yapping5.wav")
	],
	SFX.BUG_RUN: [
		preload("res://sfx/bug_running1.wav"),
		preload("res://sfx/bug_running2.wav")
	],
	SFX.BUG_SQUISH: [
		preload("res://sfx/squish3.wav")
	],
	SFX.COFFEE: [
		preload("res://sfx/coffee.wav")
	]
}

var curLoopingSounds: Array[SFX] = []

enum SFX {
	KEYBOARD,
	COFFEE,
	MOVEMENT,
	PM_YAP,
	CS_YAP,
	BUG_SQUISH,
	BUG_RUN
}

func _ready() -> void:
	instance = self

func _process(delta: float) -> void:
	for audioPlayer in audioPlayers:
		if !GameManager.isGameRunning:
			audioPlayer.stream_paused = true
		else:
			audioPlayer.stream_paused = false
	
	for sfx in curLoopingSounds:
		var player: AudioStreamPlayer = audioPlayers[sfx]
		
		if !player.playing:
			playSound(sfx)

static func playSoundLoop(sfx: SFX):
	if !instance.curLoopingSounds.has(sfx):
		instance.curLoopingSounds.append(sfx)
		playSound(sfx)

static func playSound(sfx: SFX):
	instance.audioPlayers[sfx].pitch_scale = randf_range(0.90, 1.1)
	instance.audioPlayers[sfx].stream = instance.audioFiles[sfx].pick_random()
	instance.audioPlayers[sfx].play()

static func stopSound(sfx: SFX):
	instance.curLoopingSounds.erase(sfx)
	instance.audioPlayers[sfx].stop()
