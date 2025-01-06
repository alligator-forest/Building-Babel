extends Node2D

func _ready() -> void:
	SAVEOBJECT._load_data()

func _on_button_pressed():
	get_tree().change_scene_to_file("../Screens/main.tscn")
