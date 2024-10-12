extends Node2D

@export var tiers : PackedScene

var numGold = 0
var numBricks = 0
var godFear = 0
var newFloorBricks = 10

var offset := Vector2(0,0)
func _process(_delta):
	if(Input.is_action_just_pressed("click_press")):
		for s in $Shops.get_children():
			if(s.is_mouse_within()):
				offset = get_global_mouse_position() - $Shops/BuilderShop.global_position
				break
	if(offset != Vector2(0,0) and Input.is_action_pressed("click_press")):
		$Shops/BuilderShop.global_position = get_global_mouse_position() - offset

func _ready():
	update()
	$Tower/Floors/TopFloor/Button.pressed.connect(new_floor)

func new_floor():
	if(numBricks >= newFloorBricks):
		numBricks -= newFloorBricks
		var tier = tiers.instantiate()
		tier.get_child(0).text = str($Tower/Floors.get_child_count())
		$Tower/Floors.add_child(tier)
		$Tower/Floors.move_child(tier,1)
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

func _on_resource_timer_timeout():
	for f in range(1,$Tower/Floors.get_child_count()):
		var resources : Array[int] = $Tower/Floors.get_child(f).collect_resources()
		add_resources(resources[0],resources[1],resources[2])
	print("Collection Time!")


func _on_area_2d_mouse_entered():
	pass # Replace with function body.
