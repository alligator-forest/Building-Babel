extends Node2D

func _on_play_button_pressed():
	$SceneManager.change_scene("res://Screens/main.tscn")

func _on_leaderboard_button_pressed() -> void:
	$SceneManager.change_scene("res://Screens/leaderboard.tscn")

func _on_credits_button_pressed() -> void:
	$SceneManager.change_scene("res://Screens/credits.tscn")
