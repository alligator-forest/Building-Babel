extends Control
class_name Character

signal add_resource(node : Character)

@onready var rng := RandomNumberGenerator.new()
@onready var tween : Tween = null
var draggable = true
var dragging = false
var mouseWithin : bool = false
var offset := Vector2(0,0)

var floors : Array[Node]
var currentFloor : Node

func set_current_floor(f : Node) -> void:
	currentFloor = f

func get_current_floor() -> Floor:
	return currentFloor

func set_dragging(d : bool) -> void:
	dragging = d

func _on_wait_timer_timeout():
	if(self is Thief or !dragging):
		tween = create_tween()
		$AnimatedSprite2D.play()
		var newPos = rng.randf_range(26,325)
		if(newPos > position.x):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		var time = abs(newPos-position.x)/rng.randf_range(20,40)
		tween.tween_property(self, "position:x", newPos, time)
		$MoveTimer.wait_time = time 
	$MoveTimer.start()

func _on_move_timer_timeout():
	if(self is Thief or !dragging):
		$AnimatedSprite2D.stop()
		$WaitTimer.wait_time = rng.randf_range(2,7)
	$WaitTimer.start()
	add_resource.emit(self)
	
func is_mouse_within() -> bool:
	return mouseWithin

func prepare_drag() -> void:
	$AnimatedSprite2D.play()
	if(tween != null):
		tween.pause()
	dragging = true
	scale = Vector2(3,3)

func move():
	global_position = get_global_mouse_position() - offset

func land_on_floor(f : Floor):
	scale = Vector2(2,2)
	$AnimatedSprite2D.stop()
	currentFloor = f
	dragging = false

func _on_area_2d_mouse_entered():
	mouseWithin = true

func _on_area_2d_mouse_exited():
	mouseWithin = false

func add_floor(node : Node) -> void:
	if(!(node in floors and node is Floor and !node.is_full())):
		floors.append(node)

func remove_floor(node : Node) -> void:
	if(node in floors):
		floors.remove_at(floors.find(node))

func get_floors() -> Array[Node]:
	return floors

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
