extends CanvasLayer

@onready var info_label: = $Panel/VBoxContainer/dialoig
@onready var key_list: VBoxContainer = $Panel/VBoxContainer/GridContainer
@onready var inv_manager = InventoryManager

var current_target: Node = null
var buttons: Array[Button] = []

func _ready():
	hide()

func open_for(target: Node):
	current_target = target
	populate()
	info_label.text = "Select a key..."
	show()
	grab_focus_first()

func close():
	current_target = null
	hide()

func populate():
	for child in key_list.get_children():
		child.queue_free()
	buttons.clear()

	for item in inv_manager.inv:
		if item == null or item["type"] != "key":
			continue

		var btn = Button.new()
		btn.text = "%s (x%d)" % [item["name"], item["qty"]]
		btn.focus_mode = Control.FOCUS_ALL
		btn.pressed.connect(_on_item_selected.bind(item))
		key_list.add_child(btn)
		buttons.append(btn)

func grab_focus_first():
	if buttons.size() > 0:
		await get_tree().process_frame
		if is_instance_valid(buttons[0]):
			buttons[0].grab_focus()

func _on_item_selected(item: Dictionary):
	if current_target:
		if current_target.try_item(item):
			close()
		else:
			# wrong key
			for b in buttons:
				b.hide()
			info_label.text = "This key is useless..."
			await get_tree().create_timer(2.0).timeout
			close()
