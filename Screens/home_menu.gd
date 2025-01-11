extends Node2D

func _ready() -> void:
	SAVEOBJECT._load_data()
	SAVEOBJECT.saveData.reset_scores()
	SAVEOBJECT._save_data()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("../Screens/main.tscn")

func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
