extends Node

func shoot(gun, plr):
	var current_rayray = plr.get_rayray()
	var dmg = gun["damage"]
	const common_crit = 0.1
	const rare_crit = 0.01
	var random = randf()
	if random < common_crit:
		dmg += RandomNumberGenerator.new().randf_range(dmg + round(dmg/8), dmg + round(dmg/5))
	if random < rare_crit:
		dmg += dmg*0.5
	if current_rayray and current_rayray.is_colliding() and current_rayray.get_collider().has_method("take_dmg"):
		var col = current_rayray.get_collider()
		col.take_dmg(dmg)
