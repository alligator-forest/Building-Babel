extends Node2D

var score : int = -1
func _ready() -> void:
	score = SCOREKEEPER.get_current_score()
	$YouWin.text += SCOREKEEPER.format_time(score) + "[/color][/wave]\n"
	print("current score: " + str(score))
	print("highscre: ",SAVEOBJECT.data.get_highscore())
	if(score < SAVEOBJECT.data.get_highscore() or SAVEOBJECT.data.get_highscore() == -1):
		$YouWin.text += "[rainbow freq=0.2 val=0.85][tornado freq=5.0]That's a new highscore!"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")


func _on_line_edit_text_submitted(new_text: String) -> void:
	if(new_text.length() == 3):
		SCOREKEEPER.set_score_name(new_text)
		SCOREKEEPER.update_save_data()
		get_tree().change_scene_to_file("res://Screens/home_menu.tscn")
	
