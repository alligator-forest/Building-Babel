extends Node2D

@export var tiers : PackedScene
@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@onready var rng = RandomNumberGenerator.new()

var newFloorBricks = 10
var newFloorBuilders = 1

var currChar : Character = null

var resources : Dictionary = {
	"bricks" : 0,
	"gold" : 45,
	"hubris" : 0,
}

func _ready():
	_on_builder_button_pressed()
	_on_mason_button_pressed()
	_on_merchant_button_pressed()
	update()

func _process(_delta):
	if(Input.is_action_just_pressed("click_press")):
		for f in range(1,%Floors.get_child_count()):
			var charas = %Floors.get_child(f).find_child("Characters",false)
			for c in charas.get_children():
				if(c.is_mouse_within()):
					if(currChar == null or c.get_index() > currChar.get_index()):
						currChar = c
		for d in $OutOfFloorCharacters.get_children():
			if(d.is_mouse_within()):
				if(currChar == null or d.get_index() > currChar.get_index()):
					currChar = d
		if(currChar != null):
			currChar.prepare_drag()
			currChar.reparent($OutOfFloorCharacters, true)
			$OutOfFloorCharacters.move_child(currChar,-1)
			$SellDropbox.visible = true
	if(currChar != null):
		if(Input.is_action_pressed("click_press")):
			currChar.move()
			
		if(Input.is_action_just_released("click_press")):
			var closestDrop = null
			var floors = currChar.get_floors()
			for f in floors:
				var distance = currChar.position.distance_to(f.position)
				if(closestDrop == null or distance < currChar.position.distance_to(closestDrop.position)):
					closestDrop = f
			if(closestDrop == null):
				closestDrop = currChar.get_current_floor()
			if(closestDrop is Floor):
				closestDrop.add_character(currChar)
			else:
				sell_character(currChar)
			
			currChar = null
			$SellDropbox.visible = false

func update():
	$BrickLabel.text = str(resources["bricks"])
	$GoldLabel.text = str(resources["gold"])
	$GodBar.value = resources["hubris"]
	%Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	%Floors/TopFloor/NewFloorLabel2.text = "BUILDERS NEEDED: " + str(newFloorBuilders)
	if(resources["hubris"] >= 100):
		get_tree().change_scene_to_file("res://game_over.tscn")

func check_builders() -> int:
	var numBuilders = 0
	for f in range(1,%Floors.get_child_count()):
		for c in %Floors.get_child(f).get_child(2).get_children():
			if c is Builder:
				numBuilders+=1
	return numBuilders

func new_floor():
	if(resources["bricks"] >= newFloorBricks and check_builders() >= newFloorBuilders):
		resources["bricks"] -= newFloorBricks
		var tier = tiers.instantiate()
		tier.change_name("Floor " + str(%Floors.get_child_count() - 1))
		%Floors.add_child(tier)
		%Floors.move_child(tier,1)
		newFloorBricks *= 4
		newFloorBuilders += 1
		$NewFloorPlayer.play(20)
		update()

func _on_character_timer_timeout(c : Character):
	var r : Dictionary = {
		"bricks" : 0,
		"gold" : 0,
		"hubris" : 0,
	}
	if(c is Thief):
		r["gold"] -= r["gold"]/c.get_gold()
		r["bricks"] += c.get_bricks() * (%Floors.get_child_count() - 1)
		if(c.stolen_enough()):
			c.queue_free()
	r["gold"] += c.get_gold()
	r["bricks"] += c.get_bricks()
	r["hubris"] += c.get_hubris()
	add_resources(r)

func add_resources(r : Dictionary):
	for key in r:
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

func _on_builder_button_pressed():
	buy_character(Builder.new(), builders)

func _on_merchant_button_pressed():
	buy_character(Merchant.new(), merchants)

func _on_mason_button_pressed():
	buy_character(Mason.new(), masons)

func _on_shepherd_button_pressed():
	buy_character(Shepherd.new(), shepherds)

func _on_warrior_button_pressed():
	buy_character(Warrior.new(), warriors)

func buy_character(c : Character, cLoader):
	if(c.get_price() <= resources["gold"] and !%Floors/Lobby.is_full()):
		resources["gold"] -= c.get_price()
		var dChar = cLoader.instantiate()
		
		dChar.get_node("Area2D").area_entered.connect(on_character_area_2d_enter)
		dChar.get_node("Area2D").area_exited.connect(on_character_area_2d_exit)
		dChar.add_resource.connect(_on_character_timer_timeout)
		
		dChar.position = Vector2(rng.randf_range(384,768),0)
		$OutOfFloorCharacters.add_child(dChar)
		$%Floors/Lobby.add_character(dChar)
		update()

func sell_character(c : Character):
	var d : Dictionary = {"gold" : round(c.get_price()/2.0)}
	add_resources(d)
	c.queue_free()
	
func on_character_area_2d_enter(area : Area2D) -> void:
	if(area.get_parent().has_node("DropComponent")):
		if(currChar != null):
			currChar.add_floor(area.get_parent())

func on_character_area_2d_exit(area : Area2D) -> void:
	if(area.get_parent().has_node("DropComponent")):
		if(currChar != null):
			currChar.remove_floor(area.get_parent())
