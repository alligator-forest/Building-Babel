extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var theives: PackedScene

@export var floorName : String

var numChars = 0
var maxChars = 5
var hasWarrior = false
var hasThief = false

@onready var rng = RandomNumberGenerator.new()

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func change_name(n : String):
	floorName = n
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func thief_appears():
	if(!has_warrior() and rng.randi_range(1,100) <= 5):
		add_character("thief")
		return

func has_warrior() -> bool:
	return hasWarrior

func add_character(key : String):
	key = key.to_lower()
	match key:
		"builder":
			var builder := builders.instantiate()
			$Characters.add_child(builder)
			builder.position = Vector2(rng.randf_range(26,325),86)
		"merchant":
			var merchant := merchants.instantiate()
			$Characters.add_child(merchant)
			merchant.position = Vector2(rng.randf_range(26,325),86)
		"mason":
			var mason := masons.instantiate()
			$Characters.add_child(mason)
			mason.position = Vector2(rng.randf_range(26,325),92)
		"shepherd":
			var shepherd := shepherds.instantiate()
			$Characters.add_child(shepherd)
			shepherd.position = Vector2(rng.randf_range(26,325),92)
		"warrior":
			hasWarrior = true
			var warrior := warriors.instantiate()
			$Characters.add_child(warrior)
			warrior.position = Vector2(rng.randf_range(26,325),92)
		"thief":
			hasThief = true
			var thief := theives.instantiate()
			$Characters.add_child(thief)
			thief.position = Vector2(rng.randf_range(26,325),92)
			numChars -= 1
	numChars += 1
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func is_full():
	return (numChars >= maxChars)

func collect_resources() -> Dictionary:
	var resources := {
		"bricks" : 0,
		"gold" : 0,
		"hubris" : 0,
	}
	for c in $Characters.get_children():
		resources["gold"] += c.get_gold()
		resources["bricks"] += c.get_bricks()
		resources["hubris"] += c.get_hubris()
		if(c is Thief and c.stolen_enough()):
			c.queue_free()
	return resources
