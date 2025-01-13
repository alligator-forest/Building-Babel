extends Node2D

func _ready() -> void:
	var score = SCOREKEEPER.get_current_score()
	$YouWin.text += SCOREKEEPER.format_time(score) + "[/color][/wave]\n"
	if(SCOREKEEPER.is_highscore(score)):
		$YouWin.text += "[rainbow freq=0.2 val=0.85][tornado freq=5.0]That's a new highscore!"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/home_menu.tscn")
