extends Node2D

@export_category("Spawners")
@export var BrickBasic : PackedScene
@export var WoodBasic : PackedScene
@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var carpenters : PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@onready var sellBox = $TabContainer/Residents/ScrollContainer/VBoxContainer/SellDropbox
@onready var rng = RandomNumberGenerator.new()
const THIEFCHANCE : int = 2 # % chance a thief will spawn
const FLOORSTOWIN : int = 10 #the number of floors you need to win (excludeing the top floor)
const HUBRISINCREASE : int = 600 #the number of secs it takes to increase hubrisMult
var tween : Tween
var numBuilders = 0
var hubrisMult : float = 1
var seconds : int = 0
enum console_logs {GAIN_RESOURCE, LOSE_RESOURCE, THIEF_ENTER, THIEF_EXIT, HUBRIS_INCREASE}

var currChar : Character = null

var neededResources : Dictionary = {
	"bricks" : 10,
	"wood" : 10,
	"builders" : 1,
}

var resources : Dictionary = {
	"bricks" : 0,
	"wood" : 0,
	"gold" : 30,
	"hubris" : 0,
}

@onready var consoleNotifs : Dictionary = {
	"gold" : $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/GoldConsole,
	"bricks" : $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/BrickConsole,
	"wood" : $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/WoodConsole,
	"steal" : $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/ThiefSteal,
	"thief" : $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/ThiefAppear,
}
func _ready():
	update()

func _physics_process(_delta):
	if(%Floors.get_child_count() > 5):
		$Background.position.y =  - 760 + $Tower.get_v_scroll_bar().max_value - $Tower.scroll_vertical - 640
	
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
			if($TabContainer/Residents.visible):
				sellBox.visible = true
				sellBox.text = "SELL: " + str(currChar.get_sell_price()) + " G"
			
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
			else: #makes the assumption that if closestDrop is not a floor, it (currently) MUST be a SellBox
				sell_character(currChar)
			currChar = null
			sellBox.visible = false

#console_logs{GAIN_GOLD, GAIN_BRICK, LOSE_GOLD, LOSE_BRICK, THIEF_ENTER, THIEF_EXIT}
func log_in_console(event : int, c : Character = null, resourceVal : int = 0, resourceName : String = ""):
	match event:
		console_logs.GAIN_RESOURCE:
			if(consoleNotifs[resourceName].button_pressed):
				$Console.text = str(str(c).to_pascal_case()," gained ",resourceVal," ",resourceName) + "\n" + $Console.text
		console_logs.LOSE_RESOURCE:
			if(consoleNotifs["steal"].button_pressed):
				$Console.text = str(str(c).to_pascal_case(), " stole ",abs(resourceVal), " ",resourceName) + "\n" + $Console.text
		console_logs.THIEF_ENTER:
			if(consoleNotifs["thief"].button_pressed):
				$Console.text = str(str(c).to_pascal_case(), " entered ",c.get_current_floor()) + "\n" + $Console.text
		console_logs.THIEF_EXIT:
			if(consoleNotifs["thief"].button_pressed):
				$Console.text = str(str(c).to_pascal_case(), " left ",c.get_current_floor()) + "\n" + $Console.text
		console_logs.HUBRIS_INCREASE:
			$Console.text = "All residents' hubris has increased\n" + $Console.text

func update():
	$BrickLabel.text = str("[img=96]res://Assets/UI/brickIcon.png[/img] ",resources["bricks"])
	$WoodLabel.text = str("[img=96]res://Assets/UI/woodIcon.png[/img] ",resources["wood"])
	$GoldLabel.text = str("[img=96]res://Assets/UI/goldIcon.png[/img] ",resources["gold"])
	#$GodBar.value = resources["hubris"]
	tween = create_tween()
	tween.tween_property($GodBar,"value",resources["hubris"],0.5)
	
	#%Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	var newFloorBricksLabel = %Floors/TopFloor/NewFloorLabel
	var newFloorBuildersLabel = %Floors/TopFloor/NewFloorLabel2
	newFloorBricksLabel.text = "[color=GREEN]" if (resources["bricks"] >= neededResources["bricks"]) else "[color=RED]"
	newFloorBuildersLabel.text = "[color=GREEN]" if (numBuilders >= neededResources["builders"]) else "[color=RED]"
	newFloorBricksLabel.text += "[b][img=64]res://Assets/UI/brickIcon.png[/img] x" + str(neededResources["bricks"])
	newFloorBuildersLabel.text += "[b][img=64]res://Assets/UI/ShopIcons/BuilderShop.png[/img] x" + str(neededResources["builders"])
	
	if($GodBar.value >= 100):
		get_tree().change_scene_to_file("../Screens/game_over.tscn")

func new_floor(type : String, fLoader):
	if(resources["bricks"] >= neededResources[type] and numBuilders >= neededResources["builders"]):
		resources["bricks"] -= neededResources["bricks"]
		var tier = fLoader.instantiate()
		tier.change_name("Floor " + str(%Floors.get_child_count()))
		%Floors.add_child(tier)
		%Floors.move_child(tier,1)
		neededResources["bricks"] *= 2
		neededResources["builders"] += 1
		play_effect("new floor")
		update()
		hubrisMult += 0.1
		
		#win condition
		if(%Floors.get_child_count() - 1 >= FLOORSTOWIN):
			SCOREKEEPER.set_score(seconds)
			get_tree().change_scene_to_file("res://Screens/win.tscn")

func _on_character_timer_timeout(c : Character):
	var r : Dictionary 
	r["gold"] = c.get_gold()
	r["bricks"] = c.get_bricks()
	r["wood"] = c.get_wood()
	var hubris = c.get_hubris()
	r["hubris"] = floor(hubris * hubrisMult) if hubris > 0 else hubris
	
	for key in r:
		if(key != "hubris" and r[key] != 0):
			if(r[key] > 0):
				log_in_console(console_logs.GAIN_RESOURCE,c,r[key],key)
			elif(r[key] < 0):
				var amtStole = clamp(abs(r[key]),0,resources[key])
				if(amtStole > 0):
					log_in_console(console_logs.LOSE_RESOURCE,c,amtStole,key)
	add_resources(r)

func add_resources(r : Dictionary):
	for key in r:
		resources[key] += r[key]
		if(key != "hubris"): #hubris has no current sound effect
			if(r[key] < 0):
				play_effect("steal")
			elif(r[key] > 0):
				play_effect(key)
		resources[key] = clamp(resources[key],0,9999)
	update()

func play_effect(n : String):
	$SoundManager.play_effect(n)

func _on_builder_button_pressed():
	buy_character(Builder.new(), builders)

func _on_merchant_button_pressed():
	buy_character(Merchant.new(), merchants)

func _on_mason_button_pressed():
	buy_character(Mason.new(), masons)

func _on_carpenter_button_pressed() -> void:
	buy_character(Carpenter.new(),carpenters)

func _on_shepherd_button_pressed():
	buy_character(Shepherd.new(), shepherds)

func _on_warrior_button_pressed():
	buy_character(Warrior.new(), warriors)

func buy_character(c : Character, cLoader):
	if($SpeedrunTimer.is_stopped()):
		$SpeedrunTimer.start()
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
		$Tower.scroll_vertical = 9999999 #huge integer so it always goes to the bottom
		update()

func spawn_thief(f : Floor) -> Thief:
	var thief = thieves.instantiate()
	thief.add_resource.connect(_on_character_timer_timeout)
	thief.thief_exited.connect(despawn_thief)
	thief.position = Vector2(rng.randf_range(384,768),0)
	f.add_character(thief)
	update()
	return thief

func despawn_thief(t : Thief, waitTime : float) -> void:
	await get_tree().create_timer(0.01).timeout #delay added so stealing would log before thief leaving
	log_in_console(console_logs.THIEF_EXIT,t)
	await get_tree().create_timer(waitTime).timeout
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

func on_character_area_2d_exit(area : Area2D) -> void:
	if(area.get_parent().has_node("DropComponent")):
		if(currChar != null):
			currChar.remove_floor(area.get_parent())

func _on_thief_timer_timeout() -> void:
	if(%Floors.get_child_count() >= 4):
		for f in range(1,%Floors.get_child_count()):
			if(rng.randi_range(1,100) <= THIEFCHANCE and !%Floors.get_child(f).has_warrior()):
				log_in_console(console_logs.THIEF_ENTER,spawn_thief(%Floors.get_child(f)))

func _input(event: InputEvent) -> void:
	for i in range(1,10):
		if(event.is_action_pressed(str(i))):
			$Tower.scroll_vertical = 128 * (7 - i)

func _on_speedrun_timer_timeout() -> void:
	seconds += 1
	$SpeedrunLabel.text = SCOREKEEPER.format_time(seconds)
	if(hubrisMult < 1 + floor(seconds/HUBRISINCREASE)):
		hubrisMult = 1 + floor(seconds/HUBRISINCREASE)
		log_in_console(console_logs.HUBRIS_INCREASE)
		$GodBarLabel.text = "[center][wave][color=yellow]HUBRIS (x" + str(hubrisMult,")")

func _on_hide_timer_pressed() -> void:
	$SpeedrunLabel.visible = $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/HideTimer.button_pressed
	SAVEOBJECT.data.set_console_notif("timer",$SpeedrunLabel.visible)
	SAVEOBJECT._save_data()


func _on_brick_basic_pressed() -> void:
	new_floor("bricks",BrickBasic)


func _on_wood_basic_pressed() -> void:
	new_floor("wood",BrickBasic)
