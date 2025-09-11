extends CanvasLayer
@onready var label: Label = $Label
var reserve := 0
var plr

func _ready() -> void:
	plr = get_parent().get_parent()

func _process(_delta: float) -> void:
	if plr.primary_gun == null:
		label.text = "-"
		return
	
	var ammo_type = plr.primary_gun.get("ammo_type", "")
	
	for item in InventoryManager.inv:
		if item and item.has("type") and item["type"] == ammo_type + " ammo" and item["name"] == ammo_type:
			reserve = item["qty"]
			break
		else:
			reserve = 0
	label.text = str(plr.primary_gun['current_ammo']) + " / " + str(reserve)
