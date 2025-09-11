extends CanvasLayer

@onready var primary: TextureRect = $Panel/primary
@onready var secondary: TextureRect = $Panel/secondary
@onready var armor: TextureRect = $Panel/armor
@onready var util: TextureRect = $Panel/util
@onready var tab_container: TabContainer = $Panel2/TabContainer
@onready var current_atk: Label = $Panel/current_atk
@onready var current_sc_atk: Label = $Panel/current_sc_atk
@onready var current_def: Label = $Panel/current_def
@onready var current_spd: Label = $Panel/current_spd
@onready var desc_label: Label = $Panel2/desc
const UIBUTIN = preload("res://theme/uibutin.tres")

var plr
var in_tab_mode: = true

func _ready():
	plr = get_parent().get_parent()
	tab_container.current_tab = 0
	gen_butin(tab_container.get_current_tab_control())
	tab_container.get_current_tab_control().grab_focus()
	upd_stat()

func _input(event: InputEvent):
	if not visible:
		return
	if in_tab_mode:
		if event.is_action_pressed("ui_left"):
			tab_container.current_tab = max(tab_container.current_tab - 1, 0)
			gen_butin(tab_container.get_current_tab_control())
			upd_stat()
		elif event.is_action_pressed("ui_right"):
			tab_container.current_tab = min(tab_container.current_tab + 1, tab_container.get_tab_count() - 1)
			gen_butin(tab_container.get_current_tab_control())
			upd_stat()
		elif event.is_action_pressed("ui_accept"):
			var vbox := tab_container.get_current_tab_control().get_node("VBoxContainer")
			var buttons := _collect_buttons(vbox)
			if buttons.size() > 0:
				buttons[0].grab_focus()
				in_tab_mode = false
				get_viewport().set_input_as_handled()

	else:
		var vbox := tab_container.get_current_tab_control().get_node("VBoxContainer")
		var buttons := _collect_buttons(vbox)
		if event.is_action_pressed("ui_cancel"):
			tab_container.get_current_tab_control().grab_focus()
			in_tab_mode = true
			upd_stat()
			get_viewport().set_input_as_handled()
			return
		if buttons.size() == 0:
			return
		var focused := get_viewport().gui_get_focus_owner()
		var idx := buttons.find(focused)
		if idx == -1:
			idx = 0
		if event.is_action_pressed("ui_down"):
			idx = (idx + 1) % buttons.size()
			buttons[idx].grab_focus()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_up"):
			idx = (idx - 1 + buttons.size()) % buttons.size()
			buttons[idx].grab_focus()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			get_viewport().set_input_as_handled()

func gen_butin(tab: TabBar):
	var vbox := tab.get_node("VBoxContainer")
	for c in vbox.get_children():
		c.queue_free()

	var items = item_for_tab(tab.name)
	if items == null:
		upd_stat()
		return

	for item in items:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if item == plr.primary_gun or item == plr.secondary_gun or item == plr.armor or item == plr.utils:
			continue

		var btn := Button.new()
		btn.theme = UIBUTIN
		btn.text = str(item.get("name", "Unknown"))
		btn.focus_mode = Control.FOCUS_ALL
		btn.connect("focus_entered", Callable(self, "on_focus").bind(item, tab.name))
		btn.connect("pressed", Callable(self, "on_select").bind(item, tab.name))
		vbox.add_child(btn)

	setup_button(vbox)
	upd_stat()

func on_focus(item, tab_name):
	if item.has("desc"):
		desc_label.text = item["desc"]
	if tab_name == "PRIMARY":
		var old_val = plr.current_pr_damage
		current_atk.text = str(old_val) + " -> " + str(item.get("damage", old_val))
	elif tab_name == "SECONDARY":
		var old_val = plr.current_sc_damage
		current_sc_atk.text = str(old_val) + " -> " + str(item.get("damage", old_val))
	elif tab_name == "ARMOR":
		var old_val = plr.defense
		current_def.text = str(old_val) + " -> " + str(item.get("def", old_val))
	elif tab_name == "UTILS":
		print("Asd")
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
	$AudioStreamPlayer.play()

func on_select(item: Dictionary, tab_name: String) -> void:
	if tab_name == "PRIMARY":
		plr.primary_gun = item
	elif tab_name == "SECONDARY":
		plr.secondary_gun = item
	elif tab_name == "ARMOR":
		plr.armor = item
	elif tab_name == "UTILS":
		plr.utils = item
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/item-pickup-37089.mp3")
	$AudioStreamPlayer.play()

	upd_stat()
	gen_butin(tab_container.get_current_tab_control())
	in_tab_mode = true
	tab_container.get_current_tab_control().grab_focus()

func item_for_tab(tab_name: String):
	if tab_name == "PRIMARY":
		return InventoryManager.gun_inv
	elif tab_name == "SECONDARY":
		return InventoryManager.secondary_inv
	elif tab_name == "ARMOR":
		return InventoryManager.armor_inv
	elif tab_name == "UTILS":
		return InventoryManager.utils_inv

func eqp_for_tab(tab_name):
	if tab_name == "PRIMARY":
		return plr.primary_gun
	elif tab_name == "SECONDARY":
		return plr.secondary_gun
	elif tab_name == "ARMOR":
		return plr.armor
	elif tab_name == "UTILS":
		return plr.utils

func _collect_buttons(vbox: VBoxContainer) -> Array:
	var out := []
	for c in vbox.get_children():
		if c is Button:
			out.append(c)
	return out

func setup_button(vbox: VBoxContainer):
	var buttons := _collect_buttons(vbox)
	var n := buttons.size()
	if n == 0: return
	for i in range(n):
		buttons[i].focus_neighbor_top = buttons[(i - 1 + n) % n].get_path()
		buttons[i].focus_neighbor_bottom = buttons[(i + 1) % n].get_path()

func textuare_change(texrect, item):
	if item == null:
		texrect.texture = null
		return
	if item.has("texture"):
		texrect.texture = item["texture"]

func upd_stat():
	if plr:
		current_atk.text = str(plr.current_pr_damage)
		current_sc_atk.text = str(plr.current_sc_damage)
		current_def.text = str(plr.defense)
		current_spd.text = str(plr.speed)

		textuare_change(primary, plr.primary_gun)
		textuare_change(secondary, plr.secondary_gun)
		textuare_change(armor, plr.armor)
		textuare_change(util, plr.utils)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inv"):
		if visible:
			if not in_tab_mode:
				tab_container.get_current_tab_control().grab_focus()
				in_tab_mode = true
				get_parent().get_node("Inventory").visible = false
				InventoryManager.freeze = true
			else:
				visible = false
				get_parent().get_node("Inventory").visible = true 
				InventoryManager.freeze = true




func _on_visibility_changed():
	if visible:
		tab_container.current_tab = 0
		gen_butin(tab_container.get_current_tab_control())
		tab_container.get_current_tab_control().grab_focus()
		in_tab_mode = true
	upd_stat()


func _on_tab_container_tab_selected(_tab: int) -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()
