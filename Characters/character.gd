extends Control
class_name Character

@onready var rng := RandomNumberGenerator.new()
@onready var tween : Tween = null
var dragging = false
var onFloor = false
var mouseWithin : bool = false
var offset : Vector2

func _on_wait_timer_timeout():
	if(!dragging and onFloor):
		tween = create_tween()
		$AnimatedSprite2D.play()
		var newPos = rng.randf_range(26,325)
		if(newPos > position.x):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		var time = abs(newPos-position.x)/rng.randf_range(20,40)
		tween.tween_property(self, "position", Vector2(newPos, position.y), time)
		$MoveTimer.wait_time = time 
	$MoveTimer.start()

func _on_move_timer_timeout():
	if(!dragging and onFloor):
		$AnimatedSprite2D.stop()
		$WaitTimer.wait_time = rng.randf_range(2,7)
	$WaitTimer.start()
	
func is_mouse_within() -> bool:
	return mouseWithin

#Called when a Character is about to be dragged
func prepare_drag() -> void:
	offset = get_global_mouse_position() - global_position
	$AnimatedSprite2D.play()
	if(tween != null):
		tween.pause()
	dragging = true
	onFloor = false
	scale = Vector2(3,3)

func move():
	global_position = get_global_mouse_position() - offset

func snap_to_floor():
	var closestFloor = null
	for f in floors:
		var distance = sqrt(pow(f.position.x,2) + pow(f.position.y,2))
		if(closestFloor == null or distance < sqrt(pow(closestFloor.position.x,2) + pow(closestFloor.position.y,2))):
			closestFloor = f
	if(closestFloor != null):
		closestFloor.add_character(self)
		onFloor = true
		scale = Vector2(2,2)
	$AnimatedSprite2D.stop()
	dragging = false

func _on_area_2d_mouse_entered():
	mouseWithin = true

func _on_area_2d_mouse_exited():
	mouseWithin = false

var floors : Array[Floor]

func _on_area_2d_area_entered(area):
	if(area.get_parent() is Floor and !area.get_parent().is_full()):
		floors.append(area.get_parent())

func _on_area_2d_area_exited(area):
	if(area.get_parent() is Floor and area.get_parent() in floors):
		floors.remove_at(floors.find(area.get_parent()))

func get_price() -> int:
	return 0

func get_bricks() -> int:
	return 0

func get_gold() -> int:
	return 0

func get_hubris() -> int:
	return 0

func _to_string():
	return ""
