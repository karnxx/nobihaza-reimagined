extends CanvasLayer

@onready var v_box_container_2: VBoxContainer = $VBoxContainer/VBoxContainer2
@onready var name_lbl: Label = $VBoxContainer/Panel/Name
@onready var desc: Label = $VBoxContainer/Panel/Desc
@onready var effect: Label = $VBoxContainer/Panel/Effect
@onready var qty: Label = $VBoxContainer/Panel/Qty
@onready var texture_rect: TextureRect = $VBoxContainer/Panel/TextureRect
const UIBUTIN = preload("res://theme/uibutin.tres")


func _ready():
	_populate_items()

func _populate_items():
	if v_box_container_2 == null:
		return

	var inv = InventoryManager.inv
	for child in v_box_container_2.get_children():
		child.queue_free()

	var first_btn: Button = null

	for i in range(inv.size()):
		var item = inv[i]
		if item == null:
			continue

		var btn = Button.new()
		btn.text = item["name"] + ":" + str(item["qty"])
		btn.focus_mode = Control.FOCUS_ALL
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.theme = UIBUTIN

		btn.focus_entered.connect(item_focus.bind(i))
		btn.pressed.connect(item_press.bind(i))

		v_box_container_2.add_child(btn)
		if first_btn == null:
			first_btn = btn
	if first_btn:
		await get_tree().process_frame
		if is_instance_valid(first_btn):
			first_btn.grab_focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inv") and visible:
		get_parent().get_node("Inventory").visible = true
		visible = false
		InventoryManager.freeze = true


func item_focus(index):
	var inv = InventoryManager.inv 
	if index >= inv.size() or inv[index] == null:
		return
	var item = inv[index]
	name_lbl.text = item["name"]
	desc.text = item["desc"]
	qty.text = "x" + str(item["qty"])
	effect.text = "Effect: " + item["effect"]
	texture_rect.texture = item["texture"]
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
	$AudioStreamPlayer.play()


func item_press(index):
	var inv = InventoryManager.inv
	var item = inv[index]
	print("Pressed: %s" % item["name"])  
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/item-pickup-37089.mp3")
	$AudioStreamPlayer.play()


func _on_visibility_changed() -> void:
	if visible:  
		_populate_items()
