extends Node2D

var score : int = -1
func _ready() -> void:
	score = SCOREKEEPER.get_current_score()
	$YouWin.text += SCOREKEEPER.format_time(score) + "[/color][/wave]\n"
	if(score < SAVEOBJECT.data.get_highscore() or SAVEOBJECT.data.get_highscore() == -1):
		$YouWin.text += "[rainbow freq=0.2 val=0.85][tornado freq=5.0]That's a new highscore!"

func _on_line_edit_text_submitted(new_text: String) -> void:
	if(new_text.length() == 3):
		SCOREKEEPER.set_score_name(new_text.to_upper())
		SCOREKEEPER.update_save_data()
		$SceneManager.change_scene("res://Screens/home_menu.tscn")

func _on_line_edit_text_changed(new_text: String) -> void:
	$LineEdit.text = new_text.to_upper()
	$LineEdit.caret_column = new_text.length()
