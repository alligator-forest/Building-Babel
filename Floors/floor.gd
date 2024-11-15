extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@export var floorName : String

var numChars = 0
var maxChars = 5
var hasWarrior = false
var numBuilders = 0

@onready var rng = RandomNumberGenerator.new()

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func change_name(n : String):
	floorName = n
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func thief_appears():
	if(!has_warrior() and rng.randi_range(1,100) <= 5):
		add_character(Thief.new())

func has_warrior() -> bool:
	return hasWarrior

func add_character(c : Character):
	if(c is Thief):
		c = thieves.instantiate()
		$Characters.add_child(c,false,Node.INTERNAL_MODE_BACK)
	else:
		c.reparent($Characters)
	var yPos = 92
	var xPos = c.position.x
	if(c.position.x > 325):
		xPos = 325
	elif(c.position.x < 26):
		xPos = 26
	
	match str(c).to_lower():
		"builder":
			yPos = 86
			numBuilders += 1
		"merchant":
			yPos = 86
		"warrior":
			hasWarrior = true
	c.position = Vector2(xPos,yPos)
	c.land_on_floor(self)
	c.set_dragging(false)
	update()

func update():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func is_full():
	return (numChars >= maxChars)


func _on_characters_child_order_changed():
	if(find_child("Characters") != null):
		numChars = $Characters.get_child_count()
		update()
