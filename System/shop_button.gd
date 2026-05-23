extends Button
class_name ShopButton
signal buy(scene : PackedScene)

@export var resource : String
@export var scene : PackedScene
@export var BBCode : String
const ENABLED_COLOR := Color("dfdfdf")
const DISABLED_COLOR := Color("8e8e8e")
@export var price : int

func _ready() -> void:
	set_price(price)

func _on_pressed() -> void:
	buy.emit(scene)

func set_price(p : int) -> void:
	price = p

func update_text(rCount : int) -> void:
	disabled = (price > rCount)
	var c = ENABLED_COLOR if price <= rCount else DISABLED_COLOR
	$ResourceLabel.add_theme_color_override("default_color", c)
	$ResourceLabel.text = str(BBCode, "x", price)
