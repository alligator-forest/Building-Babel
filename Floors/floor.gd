extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@export var floorName : String

const LEFT = 68
const RIGHT = 356
var numChars = 0
var maxChars = 5
var numBuilders = 0

@onready var rng = RandomNumberGenerator.new()

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func get_global_center() -> Vector2:
	return global_position + pivot_offset

func get_left_bound() -> int:
	return LEFT

func get_right_bound() -> int:
	return RIGHT

func change_name(n : String):
	floorName = n
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func has_warrior() -> bool:
	for c in $Characters.get_children():
		if(c is Warrior):
			return true
	return false

func add_character(c : Character):
	if(c.get_parent() == null):
		if(c is Thief):
			$Characters.add_child(c,false,Node.INTERNAL_MODE_BACK)
		else:
			$Characters.add_child(c)
	else:
		c.reparent($Characters)
	var yPos = 128
	var xPos = c.position.x
	xPos = clamp(c.position.x,LEFT + c.get_char_witdh(),RIGHT - c.get_char_witdh())
	match str(c).to_lower():
		"builder":
			numBuilders += 1
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
