extends Node2D
class_name DraggableCharacter

var chara = "builder"
func change_name(cha):
	chara = cha
	$Sprite.set_texture(load("res://Assets/" + chara + "Spritesheet.png"))
	match chara:
		"merchant":
			$Sprite.region_rect = Rect2(2,2,22,34)
		"mason":
			$Sprite.region_rect = Rect2(2,2,22,30)
		"shepherd":
			$Sprite.region_rect = Rect2(2,2,30,30)
		"warrior":
			$Sprite.region_rect = Rect2(2,2,32,30)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
var mouseWithin : bool = false
var offset : Vector2

func is_mouse_within() -> bool:
	offset = get_global_mouse_position() - global_position
	return mouseWithin

func move():
	global_position = get_global_mouse_position() - offset

func snap_to_floor():
	if(closestFloor != null and !closestFloor.is_full()):
		closestFloor.add_character(chara)
		queue_free()

func _on_area_2d_mouse_entered():
	mouseWithin = true

func _on_area_2d_mouse_exited():
	mouseWithin = false

var closestFloor = null

func _on_area_2d_area_entered(area):
	if(area.get_parent() is Floor):
		closestFloor = area.get_parent()

func _on_area_2d_area_exited(area):
	if(area.get_parent() == closestFloor):
		closestFloor = null
