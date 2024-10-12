extends Node2D

@export var characters : PackedScene

var mouseWithin := false
var offset
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(mouseWithin):
		if(Input.is_action_just_pressed("click_press")):
			offset = get_global_mouse_position() - global_position
		if(Input.is_action_pressed("click_press")):
			global_position = get_global_mouse_position() - offset

func _on_area_2d_mouse_entered():
	var mouseWithin = true
	print("MOUSE")


func _on_area_2d_mouse_exited():
	var mouseWithin = false
	print("mouse")
