extends Node

func shoot(plr):
	var ray:RayCast2D = plr.get_rayray()
	var gun = plr.secondary_gun
	const graze_chance = 0.1     
	const normal_crit_chance = 0.1          
	var rare_crit_chance = gun["crit_chance"]  
	var roll = randf()
	var dmg = plr.secondary_gun['damage']
	var final_dmg = dmg
	var miss_chance  = gun["miss_chance"]
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
	print(ray.get_collider())
	if ray.is_colliding():
		if ray.get_collider().is_in_group('enemy') or ray.get_collider().has_method('get_dmged'):
			ray.get_collider().get_dmged(final_dmg)
