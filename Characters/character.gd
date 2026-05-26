extends Control
class_name Character

signal add_resource(node : Character)

@export var type : String = ""
@onready var rng := RandomNumberGenerator.new()
@onready var tween : Tween = null
const VELOCITY = 20
var draggable = true
var dragging = false
var mouseWithin : bool = false
var offset := Vector2(0,0)

@export var resources : Array[String]
@export var minResource : int = 0
@export var maxResource : int = 0
@export var numHubris : int = 0
@export var resourceEffect : ResourceEffect
@export var price : int = 10
@export var charWidth = 0

var floors : Array[Node]
var currentFloor : Node

func set_current_floor(f : Node) -> void:
	currentFloor = f

func get_current_floor() -> Floor:
	return currentFloor

func set_dragging(d : bool) -> void:
	dragging = d

func get_dragging_position() -> Vector2:
	return global_position + offset

func _on_wait_timer_timeout():
	if(self is Thief or !dragging):
		tween = create_tween()
		$AnimatedSprite2D.play()
		var newPos = rng.randf_range(currentFloor.get_left_bound() + charWidth,currentFloor.get_right_bound() - charWidth)
		if(newPos > position.x):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		var time = abs(newPos-position.x)/VELOCITY
		tween.tween_property(self, "position:x", newPos, time)
		$MoveTimer.wait_time = time 
	$MoveTimer.start()

func _on_move_timer_timeout():
	if(self is Thief or !dragging):
		$AnimatedSprite2D.stop()
		$WaitTimer.wait_time = rng.randf_range(2,7)
	$WaitTimer.start()
	if(!dragging):
		add_resource.emit(self)
	
func is_mouse_within() -> bool:
	return mouseWithin

func prepare_drag() -> void:
	$AnimatedSprite2D.play()
	z_index = 9;
	offset = get_global_mouse_position() - global_position
	if(tween != null):
		tween.pause()
	dragging = true
	$AnimatedSprite2D.scale = Vector2(4,4)

func move():
	global_position = get_global_mouse_position() - offset

func land_on_floor(f : Floor):
	z_index = 1
	$AnimatedSprite2D.scale = Vector2(2,2)
	$AnimatedSprite2D.stop()
	currentFloor = f
	dragging = false

func _on_area_2d_mouse_entered():
	mouseWithin = true

func _on_area_2d_mouse_exited():
	mouseWithin = false

func add_floor(node : Node) -> void:
	if(!(node in floors) and !node.is_full()):
		floors.append(node)

func remove_floor(node : Node) -> void:
	if(node in floors):
		floors.remove_at(floors.find(node))

func get_floors() -> Array[Node]:
	return floors

func get_price() -> int:
	return price

func get_sell_price() -> int:
	return round(price/2.0)

func get_resource(r : String) -> int:
	if(r == "hubris" and numHubris > 0):
		return numHubris
	elif(r in resources):
		return rng.randi_range(minResource,maxResource)
	return 0

func start_effect(resource : String, value : int) -> void:
	if(resource != "hubris" and resource in resources ):
		resourceEffect.start_effect(value, global_position)

func get_char_witdh() -> int:
	return charWidth

func _to_string():
	return ""
