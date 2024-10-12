extends TextureRect
class_name Floor

@export var builders: PackedScene

func add_character(key : String):
	match key:
		"builder":
			var builder := builders.instantiate()
			$Characters.add_child(builder)
		
func collect_resources() -> Array[int]:
	var gold : int = 0
	var bricks : int = 0
	var godFear : int = 0
	for c in $Characters.get_children():
		gold += c.getGold()
		bricks += c.getBricks()
		godFear += c.getGodFear()
	return [gold, bricks, godFear]
