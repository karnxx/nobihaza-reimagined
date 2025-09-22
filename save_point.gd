extends StaticBody2D
@export var slot: int = 1   
@export var sound: AudioStream


func interact():
	if InventoryManager.plr:
		SaveManager.save_game(InventoryManager.plr, slot)
		print("📖 Game saved at save point (slot %d)" % slot)
