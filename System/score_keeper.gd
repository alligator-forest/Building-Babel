extends Node

var score : int = -1 #the most recent score achieved, in seconds

func set_score(s : int) -> void:
	score = s
	SAVEOBJECT.saveData.new_score(score)

func is_highscore(seconds : int) -> bool:
	return seconds == score

func format_time(seconds : int) -> String:
	var minutes = (seconds/60)%60
	var hours = (seconds/60)/60
	seconds = seconds % 60
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
