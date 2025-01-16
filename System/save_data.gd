extends Resource
class_name SaveData

const SAVE_PATH := "user://savegame.save"

#for all intents and purposes these are consts, was getting a read-only error w/ STARTSCORES
var STARTMUSICVOLUME = 0.5
var STARTSFXVOLUME = 0.5
var STARTSCORES = [-1,-1,-1,-1,-1]

@export var musicVolume : float = STARTMUSICVOLUME #linear volume, between 0 and 200
@export var sfxVolume : float = STARTSFXVOLUME #linear volume, between 0 and 200
@export var scores : Array = STARTSCORES #the top ten scores on your leaderboard, in seconds. index 0 is highscore

@export var consoleNotifs : Dictionary = {
	"timer" : true,
	"gold" : true,
	"bricks" : true,
	"steal" : true,
	"thief" : true,
}

func reset_all() -> void:
	reset_music_volume()
	reset_sfx_volume()
	reset_scores()
	reset_console_notifs()

func get_scores() -> Array:
	return scores

func get_highscore() -> int:
	return scores[0]

func new_score(seconds : int) -> void:
	for i in range(scores.size()):
		if(seconds < scores[i] or scores[i] < 0):
			scores.insert(i,seconds)
			scores = scores.slice(0,STARTSCORES.size())
			return

func reset_scores() -> void:
	scores = STARTSCORES
	scores.is_read_only()

func get_console_notif(key : String) -> bool:
	if key in consoleNotifs:
		return consoleNotifs[key]
	return false

func set_console_notif(key : String, value : bool) -> void:
	if(key in consoleNotifs):
		consoleNotifs[key] = value

func reset_console_notifs() -> void:
	for key in consoleNotifs:
		consoleNotifs[key] = true

func get_music_volume() -> float:
	return musicVolume

func set_music_volume(m : float) -> void:
	musicVolume = m

func reset_music_volume() -> void:
	musicVolume = STARTMUSICVOLUME

func get_sfx_volume() -> float:
	return sfxVolume

func set_sfx_volume(s : float) -> void:
	sfxVolume = s

func reset_sfx_volume() -> void:
	sfxVolume = STARTSFXVOLUME
