extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@export var floorName : String

const LEFT = 26
const RIGHT = 325
var numChars = 0
var maxChars = 5
var numBuilders = 0

@onready var rng = RandomNumberGenerator.new()

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func get_global_center() -> Vector2:
	return global_position + pivot_offset

func change_name(n : String):
	floorName = n
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func has_warrior() -> bool:
	for c in $Characters.get_children():
		if(c is Warrior):
			return true
	return false

func add_character(c : Character):
	c.reparent($Characters)
	var yPos = 92
	var xPos = c.position.x
	xPos = clamp(c.position.x,LEFT,RIGHT)
	match str(c).to_lower():
		"builder":
			yPos = 86
			numBuilders += 1
		"merchant":
			yPos = 86
	c.position = Vector2(xPos,yPos)
	c.land_on_floor(self)
	update()

func update():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func is_full():
	return (numChars >= maxChars)

func _on_characters_child_order_changed():
	if(find_child("Characters") != null):
		numChars = $Characters.get_child_count()
		update()

func _to_string() -> String:
	return floorName
