extends Button
class_name SellDropbox

var mouseWithin : bool = false

func get_global_center() -> Vector2:
	return global_position + pivot_offset

func is_full() -> bool:
	return !visible #if the button is not visible (meaning the Residents Tab is not current tab) you should not be able to sell residents

func _on_area_2d_mouse_entered() -> void:
	mouseWithin = true

func _on_area_2d_mouse_exited() -> void:
	mouseWithin = false
