extends Node2D

@onready var screens = [$Pages/Page1,$Pages/Page2]
var index = 0

func _ready() -> void:
	screens[0].visible = true
	screens[1].visible = false

func _on_left_button_pressed() -> void:
	index -= 1
	if(index < 0):
		get_tree().change_scene_to_file("res://Screens/home_menu.tscn")
	else:
		screens[index].visible = true
		screens[index + 1].visible = false

func _on_right_button_pressed() -> void:
	index += 1
	if(index >= screens.size()):
		get_tree().change_scene_to_file("res://Screens/home_menu.tscn")
	else:
		screens[index].visible = true
		screens[index - 1].visible = false
