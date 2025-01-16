extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scores.text = "[center]"
	var scores = SAVEOBJECT.data.get_scores()
	for i in range(scores.size()):
		if(scores[i] > 0):
			if(i == 0):
				$Scores.text += "[rainbow freq=0.1 val=0.85][tornado radius=3 freq=5.0]"
				$Scores.text += SCOREKEEPER.format_time(scores[i]) + "[/tornado][/rainbow]\n"
			else:
				$Scores.text += SCOREKEEPER.format_time(scores[i]) + "\n"
		else:
			$Scores.text += "--:--:--\n"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")


func _on_reset_scores_pressed() -> void:
	$ResetScores.hide()
	$Timer.start()

func _on_are_you_sure_pressed() -> void:
	SAVEOBJECT.data.reset_scores()
	_ready()
	SAVEOBJECT._save_data()
	_on_timer_timeout()


func _on_timer_timeout() -> void:
	$ResetScores.show()
