extends Node2D

@export var tiers : PackedScene
@export var draggableCharacters : PackedScene

var newFloorBricks = 10
var newFloorBuilders = 1

var resources : Dictionary = {
	"bricks" : 0,
	"gold" : 45,
	"hubris" : 0,
}

func _ready():
	buy_character(Builder.new())
	buy_character(Merchant.new())
	buy_character(Mason.new())
	update()

var currChar : DraggableCharacter = null
func _process(_delta):
	if(Input.is_action_just_pressed("click_press")):
		for f in range(1,$Tower/Floors.get_child_count()):
			print($Tower/Floors.get_child(f).find_child("Characters",false))
			for c in $Tower/Floors.get_child(f).find_child("Characters",false).get_children():
				print(c)
				if(c.is_mouse_within()):
					if(currChar == null or c.get_index() < currChar.get_index()):
						currChar = c
						$Characters.move_child(currChar,$Characters.get_child_count() -1)
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

func update():
	$BrickLabel.text = str(resources["bricks"])
	$GoldLabel.text = str(resources["gold"])
	$GodBar.value = resources["hubris"]
	$Tower/Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	$Tower/Floors/TopFloor/NewFloorLabel2.text = "BUILDERS NEEDED: " + str(newFloorBuilders)
	if(resources["hubris"] >= 100):
		get_tree().change_scene_to_file("res://game_over.tscn")

func check_builders() -> int:
	var numBuilders = 0
	for f in range(1,$Tower/Floors.get_child_count()):
		for c in $Tower/Floors.get_child(f).get_child(2).get_children():
			if c is Builder:
				numBuilders+=1
	return numBuilders

func new_floor():
	if(resources["bricks"] >= newFloorBricks and check_builders() >= newFloorBuilders):
		resources["bricks"] -= newFloorBricks
		var tier = tiers.instantiate()
		tier.change_name("Floor " + str($Tower/Floors.get_child_count()))
		$Tower/Floors.add_child(tier)
		$Tower/Floors.move_child(tier,1)
		newFloorBricks *= 4
		newFloorBuilders += 1
		$NewFloorPlayer.play(20)
		update()

func add_resources(r : Dictionary):
	for key in resources:
		resources[key] += r[key]
		if(resources[key] < 0):
			resources[key] = 0
		if(r[key] < 0):
			play_effect("steal")
		elif(r[key] > 0):
			play_effect(key)
	update()

func play_effect(n : String):
	match n:
		"gold":
			$MoneyPickup.play()
		"bricks":
			$BrickPickup.play(55)
		"newFloor":
			$NewFloorPlayer.play()
		"steal":
			$Steal.play()

func _on_resource_timer_timeout():
	var r : Dictionary
	for f in range(1,$Tower/Floors.get_child_count()):
		r = $Tower/Floors.get_child(f).collect_resources()
		if($Tower/Floors.get_child_count() > 3):
			$Tower/Floors.get_child(f).thief_appears()
	add_resources(r)

@onready var rng = RandomNumberGenerator.new()
func _on_builder_button_pressed():
	buy_character(Builder.new())

func _on_merchant_button_pressed():
	buy_character(Merchant.new())

func _on_mason_button_pressed():
	buy_character(Mason.new())

func _on_shepherd_button_pressed():
	buy_character(Shepherd.new())

func _on_warrior_button_pressed():
	buy_character(Warrior.new())

func buy_character(c : Character):
	if(c.get_price() <= resources["gold"]):
		resources["gold"] -= c.get_price()
		var dChar = draggableCharacters.instantiate()
		dChar.change_name(str(c))
		dChar.position = Vector2(rng.randf_range(832,1088),448)
		$DraggableCharacters.add_child(dChar)
		update()

