extends CanvasLayer
@onready var button: Button = $"inv screen all/left area/left selection area/Button"
@onready var lvl: Label = $"inv screen all/riight/Button/Panel/lvl"
@onready var hp: Label = $"inv screen all/riight/Button/Panel/hp"
@onready var tp: Label = $"inv screen all/riight/Button/Panel/tp"
@onready var xp: Label = $"inv screen all/riight/Button/Panel/exp"
@onready var status: Label = $"inv screen all/riight/Button/Panel/status"
@onready var primary: TextureRect = $"inv screen all/riight/Button/Panel/primary"
@onready var secondary: TextureRect = $"inv screen all/riight/Button/Panel/secondary"

var current_healt 
var max_healt 
var t 
var max_t 
var leve 
var exp_targe
var current_ex 


func _ready() -> void:
	button.grab_focus()
 
func _process(_delta: float) -> void:
	lvl.text = str(leve)
	hp.text = str(current_healt) + "/" + str(max_healt)
	tp.text = str(t) + "/" + str(max_t)
	xp.text = str(current_ex) + "/" + str(exp_targe)
	if get_parent().get_parent().primary_gun !=null:
		primary.texture = get_parent().get_parent().primary_gun['texture']
	if get_parent().get_parent().secondary_gun !=null:
		secondary.texture = get_parent().get_parent().secondary_gun['texture']
	
func _on_visibility_changed() -> void:
	if visible:
		await get_tree().process_frame
		if button and button.is_inside_tree():
			button.grab_focus()
	if is_inside_tree():
		if visible:
			$AudioStreamPlayer.stream = preload("res://assets/music/sfc/inventory-grab-36275.mp3")
		else:
			$AudioStreamPlayer.stream = preload("res://assets/music/sfc/open-bag-sound-39216.mp3")
		$AudioStreamPlayer.play()


func _on_button_2_pressed() -> void:
	change_screen("equipment")
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()

func _on_button_pressed() -> void:
	change_screen("invsyb")
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()

func change_screen(target):
	get_parent().get_node(target).visible = true
	self.visible = false


func _on_button_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_2_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_3_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_4_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_6_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_5_focus_entered() -> void:
	if visible:
		$AudioStreamPlayer.stream = preload("res://assets/music/sfc/select-button-ui-395763.mp3")
		$AudioStreamPlayer.play()


func _on_button_3_pressed() -> void:
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()


func _on_button_4_pressed() -> void:
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()


func _on_button_6_pressed() -> void:
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()


func _on_button_5_pressed() -> void:
	$AudioStreamPlayer.stream = preload("res://assets/music/sfc/prod-zipper-02-103038.mp3")
	$AudioStreamPlayer.play()
