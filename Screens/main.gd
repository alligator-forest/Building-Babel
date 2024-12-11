extends Node2D

@export_category("Spawners")
@export var tiers : PackedScene
@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene
@export var resourceEffects : PackedScene


@onready var rng = RandomNumberGenerator.new()
var tween : Tween
var newFloorBricks = 10
var newFloorBuilders = 1
var numBuilders = 0
enum console_logs {GAIN_RESOURCE, LOSE_RESOURCE, THIEF_ENTER, THIEF_EXIT}

var currChar : Character = null

var resources : Dictionary = {
	"bricks" : 30,
	"gold" : 30,
	"hubris" : 0,
}

func _ready():
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
			$SellDropbox.visible = true
			$SellDropbox.text = "SELL: " + str(currChar.get_sell_price()) + " G"
	if(currChar != null):
		if(Input.is_action_pressed("click_press")):
			currChar.move()
			
		if(Input.is_action_just_released("click_press")):
			var closestDrop = currChar.get_current_floor()
			var floors = currChar.get_floors()
			for f in floors:
				var distance = currChar.get_dragging_position().distance_to(f.get_global_center())
				if(distance < currChar.get_dragging_position().distance_to(closestDrop.get_global_center())):
					closestDrop = f
			if(closestDrop is Floor):
				closestDrop.add_character(currChar)
			else: #if closestDrop is not a floor, it (currently) MUST be a SellDropbox
				sell_character(currChar)
			currChar = null
			$SellDropbox.visible = false

#console_logs{GAIN_GOLD, GAIN_BRICK, LOSE_GOLD, LOSE_BRICK, THIEF_ENTER, THIEF_EXIT}
func log_in_console(event : int, c : Character, resourceVal : int = 0, resourceName : String = ""):
	match event:
		console_logs.GAIN_RESOURCE:
			$Console.text += str(str(c).to_pascal_case()," gained ",resourceVal," ",resourceName)
		console_logs.LOSE_RESOURCE:
			$Console.text += str(str(c).to_pascal_case(), " stole ",abs(resourceVal), " ",resourceName)
		console_logs.THIEF_ENTER:
			$Console.text += str(str(c).to_pascal_case(), " appeared (",c.get_current_floor(),")")
		console_logs.THIEF_EXIT:
			$Console.text += str(str(c).to_pascal_case(), " left (",c.get_current_floor(),")")
	$Console.text += "\n"

func update():
	$BrickLabel.text = str(resources["bricks"])
	$GoldLabel.text = str(resources["gold"])
	#$GodBar.value = resources["hubris"]
	tween = create_tween()
	tween.tween_property($GodBar,"value",resources["hubris"],0.5)
	
	%Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	%Floors/TopFloor/NewFloorLabel2.text = "BUILDERS NEEDED: " + str(newFloorBuilders)
	
	if($GodBar.value >= 100):
		get_tree().change_scene_to_file("res://game_over.tscn")

func new_floor():
	if(resources["bricks"] >= newFloorBricks and numBuilders >= newFloorBuilders):
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
	r["gold"] += c.get_gold()
	r["bricks"] += c.get_bricks()
	r["hubris"] += c.get_hubris()
	
	var numREs : int = 0
	for key in r:
		if(key != "hubris" and r[key] != 0):
			var rE : ResourceEffect = resourceEffects.instantiate()
			if(r[key] > 0):
				rE.set_values(key,r[key])
				log_in_console(console_logs.GAIN_RESOURCE,c,r[key],key)
			elif(r[key] < 0):
				var amtStole = clamp(abs(r[key]),0,resources[key])
				if(amtStole > 0):
					rE.set_values(key,-1 * clamp(abs(r[key]),0,resources[key]))
					log_in_console(console_logs.LOSE_RESOURCE,c,amtStole,key)
				else:
					rE = null
			if(rE != null):
				$ResourceEffects.add_child(rE)
				rE.global_position.x = c.global_position.x - (60 * numREs)
				rE.global_position.y = c.global_position.y - 50
				numREs += 1
				rE.spawn()
	add_resources(r)

func add_resources(r : Dictionary):
	for key in r:
		resources[key] += r[key]
		if(r[key] < 0):
			play_effect("steal")
		elif(r[key] > 0):
			play_effect(key)
		resources[key] = clamp(resources[key],0,9999)
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
	if(c is Builder):
		numBuilders += 1
	if(c.get_price() <= resources["gold"] and !%Floors/Lobby.is_full()):
		resources["gold"] -= c.get_price()
		var dChar = cLoader.instantiate()
		
		dChar.get_node("Area2D").area_entered.connect(on_character_area_2d_enter)
		dChar.get_node("Area2D").area_exited.connect(on_character_area_2d_exit)
		dChar.add_resource.connect(_on_character_timer_timeout)
		
		dChar.position = Vector2(296,0)
		$%Floors/Lobby.add_character(dChar)
		update()

func spawn_thief(f : Floor) -> Thief:
	var thief = thieves.instantiate()
	thief.add_resource.connect(_on_character_timer_timeout)
	thief.thief_exited.connect(despawn_thief)
	thief.position = Vector2(rng.randf_range(384,768),0)
	f.add_character(thief)
	update()
	return thief

func despawn_thief(t : Thief) -> void:
	log_in_console(console_logs.THIEF_EXIT,t)
	t.queue_free()

func sell_character(c : Character):
	if(c is Builder):
		numBuilders -= 1
	var d : Dictionary = {"gold" : currChar.get_sell_price()}
	add_resources(d)
	c.queue_free()

func on_character_area_2d_enter(area : Area2D) -> void:
	if(area.get_parent().has_node("DropComponent")):
		if(currChar != null):
			currChar.add_floor(area.get_parent())
			print(currChar.floors)

func on_character_area_2d_exit(area : Area2D) -> void:
	if(area.get_parent().has_node("DropComponent")):
		if(currChar != null):
			currChar.remove_floor(area.get_parent())

func _on_thief_timer_timeout() -> void:
	if(%Floors.get_child_count() >= 4):
		for f in range(1,%Floors.get_child_count()):
			if(rng.randi_range(1,100) <= 2 and !%Floors.get_child(f).has_warrior()):
				log_in_console(console_logs.THIEF_ENTER,spawn_thief(%Floors.get_child(f)))


func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
