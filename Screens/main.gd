extends Node2D

@export_category("Debug Tools")
@export var usingDebug : bool = false
@export var usingHubris : bool = true

@export_category("Floors")
@export var BrickBasic : PackedScene
@export var WoodBasic : PackedScene
@export var BrickWide : PackedScene
@export var WoodTall : PackedScene
@export var BrickMason : PackedScene
@export var WoodCarp : PackedScene
@export var BrickCoffer : PackedScene
@export var WoodAltar : PackedScene

@export_category("Residents")
@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var carpenters : PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var thieves: PackedScene

@onready var sellBox = %AllResidents/SellDropbox
@onready var rng = RandomNumberGenerator.new()
const THIEFCHANCE : int = 2 # % chance a thief will spawn
const FLOORSTOWIN : int = 10 #the number of floors you need to win (excludeing the top floor)
const HUBRISINCREASE : int = 600 #the number of secs it takes to increase hubrisMult
var tween : Tween
var resourceCounts = [10,30,70,150,260,400,650,1000,1500]
var brickCount : int = 0
var woodCount : int = 0
var numBuilders = 0
var totalFloors : int = 0
var hubrisMult : float = 1.0
var seconds : int = 0
enum console_logs {GAIN_RESOURCE, LOSE_RESOURCE, THIEF_ENTER, THIEF_EXIT, HUBRIS_INCREASE}

var currChar : Character = null
var closestDrop = null

var neededResources : Dictionary = {
	"bricks" : resourceCounts[0],
	"wood" : resourceCounts[0],
	"builders" : 1,
}

var resources : Dictionary[String, int] = {
	"bricks" : 0,
	"wood" : 0,
	"gold" : 30,
	"hubris" : 0,
}

@export var consoleNotifs : Dictionary[String,Button]

func _ready():
	update()
	$TabContainer.get_tab_bar().mouse_filter = 1 #TabContainer makes a TabBar child upon running that cannot be seen from the Local node tree. This MUST be made to mouse filter Propogate Up in order to remove the bug where mouse_exit does not get run on residents when they finish dragging!!!
	var tabTooltips = ["Buy and sell Residents for the Tower!", "Build new floors with resources! 10 Floors to win!", "Customize the volume, console, and more!"]
	for i in $TabContainer.get_tab_count():
		$TabContainer.get_tab_bar().set_tab_tooltip(i, tabTooltips[i])

func _physics_process(_delta):
	if(totalFloors >= 5):
		$Background.position.y =  -704 + $Tower.get_v_scroll_bar().max_value - $Tower.scroll_vertical
	
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
			$TabContainer.current_tab = 0
			if($TabContainer/Residents.visible):
				sellBox.text = "SELL: " + str(currChar.get_sell_price()) + " G"
				sellBox.visible = true
			
	if(currChar != null):
		if(Input.is_action_pressed("click_press")):
			currChar.move()
			
		if(Input.is_action_just_released("click_press")):
			closestDrop = currChar.get_current_floor()
			for f in currChar.get_floors():
				if(f.mouseWithin):
					closestDrop = f
					break
			if(closestDrop is Floor):
				closestDrop.add_character(currChar)
			else: #makes the assumption that if closestDrop is not a floor, it (currently) MUST be a SellBox
				sell_character(currChar)
			currChar = null
			sellBox.text = "SELL"

#console_logs{GAIN_GOLD, GAIN_BRICK, LOSE_GOLD, LOSE_BRICK, THIEF_ENTER, THIEF_EXIT}
func log_in_console(event : int, c : Character = null, resourceVal : int = 0, resourceName : String = ""):
	match event:
		console_logs.GAIN_RESOURCE:
			if(consoleNotifs["resource"].button_pressed):
				$Console.text = str(c.type," gained ",resourceVal," ",resourceName) + "\n" + $Console.text
		console_logs.LOSE_RESOURCE:
			if(consoleNotifs["steal"].button_pressed):
				$Console.text = str(c.type, " stole ",abs(resourceVal), " ",resourceName) + "\n" + $Console.text
		console_logs.THIEF_ENTER:
			if(consoleNotifs["thief"].button_pressed):
				$Console.text = str(c.type, " entered ",c.get_current_floor()) + "\n" + $Console.text
		console_logs.THIEF_EXIT:
			if(consoleNotifs["thief"].button_pressed):
				$Console.text = str(c.type, " left ",c.get_current_floor()) + "\n" + $Console.text
		console_logs.HUBRIS_INCREASE:
			$Console.text = "All residents' hubris has increased\n" + $Console.text

func update():
	$BrickLabel.text = str("[img=56]res://Assets/UI/brickIcon.png[/img] ",resources["bricks"])
	$WoodLabel.text = str("[img=56]res://Assets/UI/woodIcon.png[/img] ",resources["wood"])
	$GoldLabel.text = str("[img=56]res://Assets/UI/goldIcon.png[/img] ",resources["gold"])
	$GodBarLabel.text = str("[wave][color=yellow]HUBRIS x",snapped(hubrisMult,0.1))
	tween = create_tween()
	tween.tween_property($GodBar,"value",resources["hubris"],0.5)
	
	#%Floors/TopFloor/NewFloorLabel.text = "BRICKS NEEDED: " + str(newFloorBricks)
	var newFloorBuildersLabel = %BuilderLabel
	newFloorBuildersLabel.text = "[color=GREEN]" if (numBuilders >= neededResources["builders"]) else "[color=RED]"
	newFloorBuildersLabel.text += "[img=32]res://Assets/UI/ShopIcons/BuilderShop.png[/img] x" + str(neededResources["builders"])
	
	for button : ShopButton in %AllResidents.get_children().slice(0,%AllResidents.get_child_count()-1):
		button.update_text(resources["gold"])
	for button : ShopButton in %BrickFloors.get_children():
		button.update_text(resources["bricks"])
	for button : ShopButton in %WoodFloors.get_children():
		button.update_text(resources["wood"])
	
	if($GodBar.value >= 99 and (!usingDebug or usingHubris)):
		SAVEOBJECT._save_data()
		get_tree().change_scene_to_file("res://Screens/game_over.tscn")

func new_floor(fLoader : PackedScene):
	if(numBuilders >= neededResources["builders"]):
		var tier : Floor = fLoader.instantiate()
		var type = "bricks" if tier.floorIndex % 2 == 1 else "wood"
		resources[type] -= int(floor(neededResources[type] * tier.resourceMultiplier))
		tier.change_name("Floor " + str(%Floors.get_child_count()))
		totalFloors += tier.value
		%Floors.add_child(tier)
		%Floors.move_child(tier,1)
		log_in_console(console_logs.HUBRIS_INCREASE)
		#win condition
		if(totalFloors >= FLOORSTOWIN):
			SCOREKEEPER.set_score(seconds)
			SAVEOBJECT._save_data()
			get_tree().change_scene_to_file("res://Screens/win.tscn")
		else:
			hubrisMult += 0.125
			if(type == "bricks"):
				brickCount += 1
				neededResources["bricks"] = resourceCounts[brickCount]
			else:
				woodCount += 1
				neededResources["wood"] = resourceCounts[woodCount]
			neededResources["builders"] += 1
			play_effect("new floor")
			update()

func _on_character_timer_timeout(c : Character):
	var r : Dictionary
	var floorBonus = c.get_current_floor().get_bonuses()
	for key in resources.keys():
		r[key] = int(floor(c.get_resource(key) * floorBonus[key]))
		if(r[key] != 0 and key != "hubris"):
			c.start_effect(key, r[key])
	if(r["hubris"] > 0):
		r["hubris"] = int(floor(r["hubris"] * hubrisMult))
	
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

func buy_character(cLoader : PackedScene):
	if($SpeedrunTimer.is_stopped()):
		$SpeedrunTimer.start()
		
	var spawnfloor : Floor = null;
	var spawnscroll : int = 9999999;
	for i in range(%Floors.get_child_count()-1,0,-1):
		if(!%Floors.get_child(i).is_full()):
			spawnfloor = %Floors.get_child(i)
			spawnscroll = i
			break
	if(spawnfloor != null):
		var dChar = cLoader.instantiate()
		resources["gold"] -= dChar.get_price()
		if(dChar.name == "Builder"):
			numBuilders += 1
			
		dChar.get_node("Area2D").area_entered.connect(on_character_area_2d_enter)
		dChar.get_node("Area2D").area_exited.connect(on_character_area_2d_exit)
		dChar.add_resource.connect(_on_character_timer_timeout)
		dChar.position = Vector2(148,0)
		spawnfloor.add_character(dChar)
		$Tower.scroll_vertical = 64 * (spawnscroll-1)
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
	if(c.name == "Builder"):
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
			$Tower.scroll_vertical = 64 * (7 - i)
	if(usingDebug and event.is_action_pressed("debug")):
		var dict = {"gold" : 999, "wood" : 999, "bricks" : 999}
		add_resources(dict)
		for i in range(5):
			buy_character(builders)

func _on_speedrun_timer_timeout() -> void:
	seconds += 1
	$SpeedrunLabel.text = SCOREKEEPER.format_time(seconds)
	#if(hubrisMult < 1 + floor(seconds/HUBRISINCREASE)):
		#hubrisMult += 1.0
		#
		#update()

func _on_hide_timer_pressed() -> void:
	$SpeedrunLabel.visible = $TabContainer/Settings/HBoxContainer2/ConsoleNotifications/HideTimer.button_pressed
	SAVEOBJECT.data.set_console_notif("timer",$SpeedrunLabel.visible)
	SAVEOBJECT._save_data()
