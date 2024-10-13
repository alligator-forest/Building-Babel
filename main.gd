extends Node2D

@export var tiers : PackedScene
@export var draggableCharacters : PackedScene

var numGold = 0
var numBricks = 0
var godFear = 0
var newFloorBricks = 10
var newFloorBuilders = 1

func _ready():
	update()
	$Tower/Floors/TopFloor/Button.pressed.connect(new_floor)

func check_builders() -> int:
	var numBuilders = 0
	for f in range(1,$Tower/Floors.get_child_count()):
		for c in $Tower/Floors.get_child(f).get_child(1).get_children():
			if c is Builder:
				numBuilders+=1
	return numBuilders

func new_floor():
	if(numBricks >= newFloorBricks and check_builders() >= newFloorBuilders):
		numBricks -= newFloorBricks
		var tier = tiers.instantiate()
		tier.get_child(0).text = str($Tower/Floors.get_child_count())
		$Tower/Floors.add_child(tier)
		$Tower/Floors.move_child(tier,1)
		newFloorBricks *= 4
		update()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		new_floor()
	if(event.is_action_pressed("ui_up")):
		add_resources(0,5,-1)

func add_resources(gold : int, bricks : int, fear : int):
	numGold += gold
	numBricks += bricks
	godFear += fear
	update()

func update():
	$BrickLabel.text = str(numBricks)
	$GoldLabel.text = str(numGold)
	$GodBar.value = godFear
	$Tower/Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED:\n" + str(newFloorBricks)

func _on_resource_timer_timeout():
	for f in range(1,$Tower/Floors.get_child_count()):
		var resources : Array[int] = $Tower/Floors.get_child(f).collect_resources()
		add_resources(resources[0],resources[1],resources[2])
	print("Collection Time!")


func _on_builder_button_pressed():
	if(numGold >= 10):
		numGold -= 10
		var dChar = draggableCharacters.instantiate()
		dChar.position = Vector2(898,448)
		add_child(dChar)


func _on_merchant_button_pressed():
	if(numGold >= 15):
		numGold -= 15
		var dChar = draggableCharacters.instantiate()
		dChar.change_name("merchant")
		dChar.position = Vector2(898,448)
		add_child(dChar)
