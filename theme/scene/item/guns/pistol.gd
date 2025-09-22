extends Node

var roll: float

func shoot(dmg: int, plr):
	var gun = plr.primary_gun
	if gun == null:
		return
	
	if gun["current_ammo"] <= 0:
		plr.reload()
		return
	
	gun["current_ammo"] -= 1
	
	var ray = plr.get_rayray()
	if not ray or not ray.is_colliding():
		return
	
	var miss_chance  = gun["miss_chance"]    
	const graze_chance = 0.1     
	const normal_crit_chance = 0.1            
	var rare_crit_chance = gun["crit_chance"]  
	roll = randf()
	var final_dmg = dmg

	if roll <= miss_chance:
		return
	elif roll <= miss_chance + graze_chance:
		final_dmg = int(dmg * randf_range(0.3, 0.6))
	elif roll <= miss_chance + graze_chance + rare_crit_chance:
		final_dmg = int(dmg * (1.0 + randf_range(0.2, 0.3)))
	elif roll <= miss_chance + graze_chance + rare_crit_chance + normal_crit_chance:
		final_dmg = int(dmg * (1.0 + randf_range(-0.05, 0.05)))
	else:
		final_dmg = int(dmg * (1.0 + randf_range(-0.1, 0.1)))
	var col = ray.get_collider()
	if col and col.has_method("take_dmg"):
		col.take_dmg(final_dmg)
