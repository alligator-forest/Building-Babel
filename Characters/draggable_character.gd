extends Node2D
class_name DraggableCharacter

var chara = "builder"
func change_name(cha):
	chara = cha
	$Sprite.set_texture(load("res://Assets/" + chara + "Spritesheet.png"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
var mouseWithin : bool = false
var offset : Vector2
var draggable : bool = false
func _process(_delta):
	if(mouseWithin):
		if(Input.is_action_just_pressed("click_press")):
			offset = get_global_mouse_position() - global_position
			draggable = true
	if(draggable and Input.is_action_pressed("click_press")):
		global_position = get_global_mouse_position() - offset
	if(Input.is_action_just_released("click_press")):
		draggable = false
		if(closestFloor != null):
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
