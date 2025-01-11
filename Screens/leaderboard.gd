extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scores.text = ""
	var scores = SAVEOBJECT.saveData.get_scores()
	for i in range(scores.size()):
		if(scores[i] > 0):
			$Scores.text +="\t" + SCOREKEEPER.format_time(scores[i]) + "\n"
		else:
			$Scores.text += "\tScore Not Set!\n"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")
