extends Node2D

@export var tiers : PackedScene
@export var draggableCharacters : PackedScene

var numGold = 45 #45 b/c you buy three chars at the start
var numBricks = 0
var godFear = 0
var newFloorBricks = 10
var newFloorBuilders = 1

func _ready():
	update()
	$Tower/Floors/TopFloor/Button.pressed.connect(new_floor)
	_on_builder_button_pressed()
	_on_merchant_button_pressed()
	_on_mason_button_pressed()

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
		newFloorBuilders += 1
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
	$Tower/Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	$Tower/Floors/TopFloor/NewFloorLabel2.text = "BUILDERS NEEDED: " + str(newFloorBuilders)

func _on_resource_timer_timeout():
	var resources : Array[int] = [0,0,0]
	for f in range(1,$Tower/Floors.get_child_count()):
		var r : Array[int] = $Tower/Floors.get_child(f).collect_resources()
		for i in range(r.size()):
			resources[i] += r[i]
		
	for i in range(resources.size()):
		if resources[i] < 0:
			resources[i] = 0
	add_resources(resources[0],resources[1],resources[2])
	
	print("Collection Time!")

@onready var rng = RandomNumberGenerator.new()
func _on_builder_button_pressed():
	if(numGold >= 10):
		numGold -= 10
		var dChar = draggableCharacters.instantiate()
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

func _on_merchant_button_pressed():
	if(numGold >= 15):
		numGold -= 15
		var dChar = draggableCharacters.instantiate()
		dChar.change_name("merchant")
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

func _on_mason_button_pressed():
	if(numGold >= 20):
		numGold -= 20
		var dChar = draggableCharacters.instantiate()
		dChar.change_name("mason")
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

func _on_shepherd_button_pressed():
	if(numGold >= 30):
		numGold -= 30
		var dChar = draggableCharacters.instantiate()
		dChar.change_name("shepherd")
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

func _on_warrior_button_pressed():
	if(numGold >= 45):
		numGold -= 45
		var dChar = draggableCharacters.instantiate()
		dChar.change_name("warrior")
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

var currChar : DraggableCharacter = null

func _process(_delta):
	if(Input.is_action_just_pressed("click_press")):
		for d in $DraggableCharacters.get_children():
			if(d.is_mouse_within()):
				if(currChar == null or d.get_index() < currChar.get_index()):
					currChar = d
					$DraggableCharacters.move_child(currChar,$DraggableCharacters.get_child_count() -1)
	if(currChar != null):
		if(Input.is_action_pressed("click_press")):
			currChar.move()
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		if(Input.is_action_just_released("click_press")):
			currChar.snap_to_floor()
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			currChar = null
