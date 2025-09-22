extends StaticBody2D
@export var dialgong :String

func interact():
	Dialogic.start(dialgong)
