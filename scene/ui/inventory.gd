extends CanvasLayer
@onready var button: Button = $"inv screen all/left area/left selection area/Button"
@onready var lvl: Label = $"inv screen all/riight/Button/Panel/lvl"
@onready var hp: Label = $"inv screen all/riight/Button/Panel/hp"
@onready var tp: Label = $"inv screen all/riight/Button/Panel/tp"
@onready var exp: Label = $"inv screen all/riight/Button/Panel/exp"
@onready var status: Label = $"inv screen all/riight/Button/Panel/status"

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
	exp.text = str(current_ex) + "/" + str(exp_targe)

func _on_visibility_changed() -> void:
	if button and button.is_inside_tree():
		button.grab_focus()



func _on_button_pressed() -> void:
	change_screen("invsyb")

func change_screen(target):
	get_parent().get_node(target).visible = true
	self.visible = false
