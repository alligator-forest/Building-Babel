extends Node2D

@export_category("Debug Tools")
@export var usingDebug : bool = false
@export var cheatHubris : bool = false

@export var thieves: PackedScene

@onready var sellBox = %AllResidents/SellDropbox
@onready var rng = RandomNumberGenerator.new()
const THIEFCHANCE : int = 2 # % chance a thief will spawn
const FLOORSTOWIN : int = 9 #the number of floors you need to win (excludeing the top floor)
const HUBRISINCREASE : int = 600 #the number of secs it takes to increase hubrisMult
var tween : Tween
var resourceCounts = [30,70,150,320,650,1000,1500,2000,2500,3777]
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
	$TabContainer.get_tab_bar().mouse_filter = 1 #TabContainer makes a TabBar child upon running that cannot be seen from the Local node tree. This MUST be made to mouse filter Propogate Up in order to remove the bug where mouse_exit does not get run on residents when they finish dragging!!!
	var tabTooltips = ["Buy and sell Residents for the Tower!", "Build new floors with resources! 10 Floors to win!", "Customize the volume, console, and more!"]
	for i in $TabContainer.get_tab_count():
		$TabContainer.get_tab_bar().set_tab_tooltip(i, tabTooltips[i])
	for button : ShopButton in %WoodFloors.get_children():
		button.set_price(resourceCounts[0])
	for button : ShopButton in %BrickFloors.get_children():
		button.set_price(resourceCounts[0])
	update()

func _physics_process(_delta):
	if(totalFloors >= 4):
		$Background.position.y =  -994 + $Tower.get_v_scroll_bar().max_value - $Tower.scroll_vertical
	
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

func update(resourcesChanged : Array[String] = ["hubris", "bricks", "wood", "gold", "builders"]):
	if("hubris" in resourcesChanged):
		$GodBarLabel.text = str("[wave][color=yellow]HUBRIS x",snapped(hubrisMult,0.1))
		tween = create_tween()
		tween.tween_property($GodBar,"value",resources["hubris"],0.5)
		tween.parallel().tween_method(overlay_method, $GodBar.value, resources["hubris"], 0.5)
	if("bricks" in resourcesChanged):
		$BrickLabel.text = str("[img=56]res://Assets/Resources/brickIcon.png[/img] ",resources["bricks"])
		for button : ShopButton in %BrickFloors.get_children():
			button.update_text(resources["bricks"])
	if("wood" in resourcesChanged):
		$WoodLabel.text = str("[img=56]res://Assets/Resources/woodIcon.png[/img] ",resources["wood"])
		for button : ShopButton in %WoodFloors.get_children():
			button.update_text(resources["wood"])
	if("gold" in resourcesChanged):
		$GoldLabel.text = str("[img=56]res://Assets/Resources/goldIcon.png[/img] ",resources["gold"])
		for button : ShopButton in %AllResidents.get_children().slice(0,%AllResidents.get_child_count()-1):
			button.update_text(resources["gold"])
	if("builders" in resourcesChanged):
		%BuilderLabel.text = "[color=GREEN]" if (numBuilders >= neededResources["builders"]) else "[color=RED]"
		%BuilderLabel.text += "[img=42]res://Assets/BuildingBabelLogo.png[/img] x" + str(neededResources["builders"])
	if($GodBar.value >= 99 and (!usingDebug or !cheatHubris)):
		SAVEOBJECT._save_data()
		$SceneManager.change_scene("res://Screens/game_over.tscn")

func overlay_method(x : int) -> void:
	$BackgroundOverlay.color.a = pow(1.055, x - 113)

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
			$SceneManager.change_scene("res://Screens/win.tscn")
		else:
			hubrisMult += 0.125
			if(type == "bricks"):
				brickCount += tier.value
				neededResources["bricks"] = resourceCounts[brickCount]
				for button : ShopButton in %BrickFloors.get_children():
					button.set_price(neededResources["bricks"])
			else:
				woodCount += tier.value
				neededResources["wood"] = resourceCounts[woodCount]
				for button : ShopButton in %WoodFloors.get_children():
					button.set_price(neededResources["wood"])
			neededResources["builders"] += 1
			play_effect("new floor")
			update([type, "builders", "hubris"])

func _on_character_timer_timeout(c : Character):
	if(!c.resources.is_empty()):
		var r : Dictionary[String,int]
		var floorBonus = c.get_current_floor().get_bonuses()
		for key : String in c.resources:
			r[key] = int(floor(c.get_resource(key) * floorBonus[key]))
			if(c is Thief):
				r[key] = ceil(r[key] * hubrisMult * hubrisMult)
				print("thief expanded!")
			if(r[key] != 0 and key != "hubris"):
				c.start_effect(key, r[key])
		if(r.has("hubris") and r["hubris"] > 0):
			r["hubris"] = int(floor(r["hubris"] * hubrisMult))
		
		for key : String in r:
			if(key != "hubris" and r[key] != 0):
				if(r[key] > 0):
					log_in_console(console_logs.GAIN_RESOURCE,c,r[key],key)
				elif(r[key] < 0):
					var amtStole = clamp(abs(r[key]),0,resources[key])
					if(amtStole > 0):
						log_in_console(console_logs.LOSE_RESOURCE,c,amtStole,key)
		add_resources(r)

func add_resources(r : Dictionary[String,int]):
	for key : String in r:
		resources[key] += r[key]
		if(key != "hubris"): #hubris has no current sound effect
			if(r[key] < 0):
				play_effect("steal")
			elif(r[key] > 0):
				play_effect(key)
		resources[key] = clamp(resources[key],0,9999)
	update(r.keys())

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
		var dChar : Character = cLoader.instantiate()
		resources["gold"] -= dChar.get_price()
			
		dChar.get_node("Area2D").area_entered.connect(on_character_area_2d_enter)
		dChar.get_node("Area2D").area_exited.connect(on_character_area_2d_exit)
		dChar.add_resource.connect(_on_character_timer_timeout)
		dChar.position = Vector2(148,0)
		spawnfloor.add_character(dChar)
		$Tower.scroll_vertical = 64 * (spawnscroll-1)
		if(dChar.type == "Builder"):
			numBuilders += 1
			update(["gold", "builders"])
		else:
			update(["gold"])

func spawn_thief(f : Floor) -> Thief:
	var thief = thieves.instantiate()
	thief.add_resource.connect(_on_character_timer_timeout)
	thief.thief_exited.connect(despawn_thief)
	thief.position = Vector2(rng.randf_range(384,768),0)
	f.add_character(thief)
	#update()
	return thief

func despawn_thief(t : Thief, waitTime : float) -> void:
	await get_tree().create_timer(0.01).timeout #delay added so stealing would log before thief leaving
	log_in_console(console_logs.THIEF_EXIT,t)
	await get_tree().create_timer(waitTime).timeout
	t.queue_free()

func sell_character(c : Character):
	if(c.type == "Builder"):
		numBuilders -= 1
		update(["builders"])
	var d : Dictionary[String,int] = {"gold" : currChar.get_sell_price()}
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
		var dict : Dictionary[String,int]= {"gold" : 9999, "wood" : 9999, "bricks" : 9999}
		add_resources(dict)
		for i in range(5):
			$TabContainer/ResidentsTab/AllResidents/BuilderButton.pressed.emit()

func _on_speedrun_timer_timeout() -> void:
	seconds += 1
	$SpeedrunLabel.text = SCOREKEEPER.format_time(seconds)

func _on_hide_timer_pressed() -> void:
	$SpeedrunLabel.visible = %SettingsTab/HBoxContainer2/ConsoleNotifications/HideTimer.button_pressed
	SAVEOBJECT.data.set_console_notif("timer",$SpeedrunLabel.visible)

func _on_quit_button_pressed() -> void:
	SAVEOBJECT._save_data()
	$SceneManager.change_scene("res://Screens/home_menu.tscn")
