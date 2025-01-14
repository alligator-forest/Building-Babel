extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scores.text = ""
	var scores = SAVEOBJECT.saveData.get_scores()
	for i in range(scores.size()):
		if(scores[i] > 0):
			if(i == 0):
				$Scores.text += "[rainbow freq=0.2 val=0.85][tornado radius=3 freq=5.0]"
				$Scores.text +="\t" + SCOREKEEPER.format_time(scores[i]) + "[/tornado][/rainbow]\n"
			else:
				$Scores.text +="\t" + SCOREKEEPER.format_time(scores[i]) + "\n"
		else:
			$Scores.text += "\t--:--:--\n"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")


func _on_reset_scores_pressed() -> void:
	$ResetScores.hide()
	$Timer.start()

func _on_are_you_sure_pressed() -> void:
	SAVEOBJECT.saveData.reset_scores()
	_ready()
	SAVEOBJECT._save_data()
	_on_timer_timeout()


func _on_timer_timeout() -> void:
	$ResetScores.show()
