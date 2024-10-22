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
	var closestFloor = null
	for f in floors:
		var distance = sqrt(pow(f.position.x,2) + pow(f.position.y,2))
		if(closestFloor == null or distance < sqrt(pow(closestFloor.position.x,2) + pow(closestFloor.position.y,2))):
			closestFloor = f
	if(closestFloor != null):
		closestFloor.add_character(chara)
		queue_free()

func _on_area_2d_mouse_entered():
	mouseWithin = true

func _on_area_2d_mouse_exited():
	mouseWithin = false

var floors : Array[Floor]

func _on_area_2d_area_entered(area):
	if(area.get_parent() is Floor and !area.get_parent().is_full()):
		floors.append(area.get_parent())
	print(floors)

func _on_area_2d_area_exited(area):
	if(area.get_parent() in floors):
		floors.remove_at(floors.find(area.get_parent()))
