extends Resource
class_name SaveData

const SAVE_PATH := "user://savegame.tres"

const STARTMUSICVOLUME = 100
const STARTSFXVOLUME = 100
const STARTHIGHSCORE = 0

@export var musicVolume : float = STARTMUSICVOLUME #linear volume, between 0 and 200
@export var sfxVolume : float = STARTSFXVOLUME #linear volume, between 0 and 200
@export var highscore : int = STARTHIGHSCORE #the time it takes to beat the game, in seconds

@export var consoleNotifs : Dictionary = {
	"gold" : true,
	"bricks" : true,
	"steal" : true,
	"thief" : true,
}

func resetAll() -> void:
	resetHighscore()
	resetMusicVolume()
	resetSfxVolume()

func getConsoleNotif(key : String) -> bool:
	if key in consoleNotifs:
		return consoleNotifs[key]
	return false

func setConsoleNotif(key : String, value : bool) -> void:
	if(key in consoleNotifs):
		consoleNotifs[key] = value

func resetConsoleNotifs() -> void:
	for key in consoleNotifs:
		consoleNotifs[key] = true

func getMusicVolume() -> float:
	return musicVolume

func setMusicVolume(m : float) -> void:
	musicVolume = m

func resetMusicVolume() -> void:
	musicVolume = STARTMUSICVOLUME

func getSfxVolume() -> float:
	return sfxVolume

func setSfxVolume(s : float) -> void:
	sfxVolume = s

func resetSfxVolume() -> void:
	sfxVolume = STARTSFXVOLUME

func getHighscore() -> int:
	return highscore

func setHighscore(h : int) -> void:
	if(h > highscore):
		highscore = h

func resetHighscore() -> void:
	highscore = STARTHIGHSCORE
