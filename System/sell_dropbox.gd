extends Button
class_name SellDropbox

func get_global_center() -> Vector2:
	return global_position + pivot_offset

func is_full() -> bool:
	return false
