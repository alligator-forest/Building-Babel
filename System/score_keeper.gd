extends Node

var score : int = -1 #the most recent score achieved, in seconds
var scorename : String = "---" #the most recent name, added when you win a run

func set_score(s : int) -> void:
	score = s

func set_score_name(n : String) -> void:
	scorename = n

func update_save_data() -> void:
	SAVEOBJECT.data.new_score(score,scorename)
	SAVEOBJECT._save_data()

func get_current_score() -> int:
	return score

func get_score_name() -> String:
	return scorename

func is_highscore(seconds : int) -> bool:
	return seconds == SAVEOBJECT.data.get_highscore()

func format_time(seconds : int) -> String:
	var minutes = (seconds/60)%60
	var hours = (seconds/60)/60
	seconds = seconds % 60
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
