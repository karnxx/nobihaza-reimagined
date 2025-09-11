extends Node

func shoot(dmg, plr):
	var gun = plr.primary_gun
	if gun == null:
		return
	
	if gun["current_ammo"] <= 0:
		plr.reload()
		return
	
	# Only subtract ONCE
	gun["current_ammo"] -= 1
	
	var current_rayray = plr.get_rayray()
	const common_crit = 0.1
	const rare_crit = 0.01
	var random = randf()
	if random <= common_crit:
		dmg += RandomNumberGenerator.new().randf_range(dmg + round(dmg/8), dmg + round(dmg/5))
	if random <= rare_crit:
		dmg += dmg * 2
	
	if current_rayray and current_rayray.is_colliding() and current_rayray.get_collider().has_method("take_dmg"):
		var col = current_rayray.get_collider()
		col.take_dmg(dmg)
