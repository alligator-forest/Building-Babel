extends Node2D

func _ready() -> void:
	SAVEOBJECT._load_data()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("../Screens/main.tscn")

func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/credits.tscn")

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/tutorial.tscn")
