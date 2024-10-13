extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene

@export var floorName : String

var numChars = 0
var maxChars = 5

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func add_character(key : String):
	if(!is_full()):
		key = key.to_lower()
		var rng = RandomNumberGenerator.new()
		match key:
			"builder":
				var builder := builders.instantiate()
				$Characters.add_child(builder)
				builder.position = Vector2(rng.randf_range(12,300),95)
			"merchant":
				var merchant := merchants.instantiate()
				$Characters.add_child(merchant)
				merchant.position = Vector2(rng.randf_range(12,300),95)
				merchant.scale = Vector2(1.5,1.5)
			"mason":
				var mason := masons.instantiate()
				$Characters.add_child(mason)
				mason.position = Vector2(rng.randf_range(12,300),98)
			"shepherd":
				var shepherd := shepherds.instantiate()
				$Characters.add_child(shepherd)
				shepherd.position = Vector2(rng.randf_range(12,300),98)
			"warrior":
				var warrior := warriors.instantiate()
				$Characters.add_child(warrior)
				warrior.position = Vector2(rng.randf_range(12,300),98)
		numChars += 1
		_ready()
		print(numChars)

func is_full():
	return (numChars >= maxChars)

func collect_resources() -> Array[int]:
	var gold : int = 0
	var bricks : int = 0
	var godFear : int = 0
	for c in $Characters.get_children():
		gold += c.getGold()
		bricks += c.getBricks()
		godFear += c.getGodFear()
	return [gold, bricks, godFear]
