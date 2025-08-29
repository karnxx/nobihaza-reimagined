extends CanvasLayer
@onready var primary: TabBar = $Panel/TabContainer/PRIMARY

func _ready() -> void:
	primary.grab_focus()
