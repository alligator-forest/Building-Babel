extends Node2D


func _on_button_pressed() -> void:
	$SceneManager.change_scene("res://Screens/home_menu.tscn")
