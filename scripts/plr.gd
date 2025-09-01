extends CharacterBody2D
#dialogue-https://www.youtube.com/watch?v=Tmy1tzhDLl4
const SCREEN_FLASH = preload("res://scene/ui/screen_flash.tscn")
var current_health = 100
var max_health = 100
var tp = 30
var max_tp = 30
var level = 1
var exp_target = 100 * level^2
var current_exp = 0
var is_moving = false
var facing : String = "left"
var sprite_node_tween : Tween
var target_pos :Vector2
var tile_size = 16
var speed = tile_size * 6
var anim = ""
var is_equipped = false
var is_equipping = false  
var is_shooting= false
var can_shoot :=true

#the gun stuff v imp
var primary_gun
var secondary_gun
var armor
var utils
var ammo_type
var current_ammo :int
var max_ammo:int
var fire_rate:float
var reload_time:float
var defense:int = 0
var current_pr_damage:int = 0
var current_sc_damage:int = 0




func _ready() -> void:
	InventoryManager.set_player(self)


func _process(_delta: float) -> void:
	if !InventoryManager.freeze:
		check_interactable()
	if Input.is_action_just_pressed("inv") and is_equipped == false:
		show_inv()
	if Input.is_action_just_pressed("equip"):
		equip()
	if Input.is_action_just_pressed("ui_accept") and is_equipped == true:
		shoot()
	if primary_gun:
		current_pr_damage = primary_gun['damage']
	if secondary_gun != null:
		current_sc_damage = secondary_gun['damage']

func _physics_process(_delta: float) -> void:
	if !InventoryManager.freeze:
		movement()
		
func animatee(animation: String, flip: bool) -> void:
	$AnimatedSprite2D.play(animation)
	$AnimatedSprite2D.flip_h = flip

func movement() -> void:
	if (sprite_node_tween and sprite_node_tween.is_running()) or is_equipping or is_shooting:
		return

	var dir := Vector2.ZERO
	var anim_name := ""
	var flip := false

	if Input.is_action_pressed("ui_up") and not $movement/up.is_colliding():
		dir = Vector2(0, -1)
		anim_name = "walk_back"

	elif Input.is_action_pressed("ui_down") and not $movement/down.is_colliding():
		dir = Vector2(0, 1)
		anim_name = "walk_front"

	elif Input.is_action_pressed("ui_left") and not $movement/left.is_colliding():
		dir = Vector2(-1, 0)
		anim_name = "walk_side"

	elif Input.is_action_pressed("ui_right") and not $movement/right.is_colliding():
		dir = Vector2(1, 0)
		anim_name = "walk_side"
		flip = true

	else:
		match facing:
			"left":  animatee(anim + "idle_side", false)
			"right": animatee(anim + "idle_side", true)
			"up":    animatee(anim + "idle_back", false)
			"down":  animatee(anim + "idle_front", false)

	if dir != Vector2.ZERO and move(dir):
		if dir.x < 0: facing = "left"
		elif dir.x > 0: facing = "right"
		elif dir.y < 0: facing = "up"
		elif dir.y > 0: facing = "down"
		animatee(anim + anim_name, flip)

	
func move(dir: Vector2) -> bool:
	if is_moving:
		return false  
	is_moving = true
	target_pos = position + dir * tile_size
	var distance := position.distance_to(target_pos)
	var duration = max(0.05, distance / speed)
	if sprite_node_tween and sprite_node_tween.is_running():
		sprite_node_tween.kill()
	
	sprite_node_tween = create_tween()
	sprite_node_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_tween.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sprite_node_tween.finished.connect(move_finish)
	return true
	
func move_finish() -> void:
	position = target_pos.snapped(Vector2.ONE)
	is_moving = false
	
func check_interactable():
	if not Input.is_action_just_pressed("ui_accept") or is_equipped:
		return
	
	var dirs = {
		"up": $movement/up,
		"down": $movement/down,
		"left": $movement/left,
		"right": $movement/right
	}
	
	var ray = dirs.get(facing)
	if ray and ray.is_colliding():
		var col = ray.get_collider()
		if col.has_method("interact"):
			col.interact()

func show_inv():
	var inv = get_node("camera/Inventory")
	inv.current_healt = current_health
	inv.max_healt = max_health
	inv.t = tp
	inv.max_t = max_tp
	inv.leve = level
	inv.exp_targe = exp_target
	inv.current_ex = current_exp
	if inv.visible == false:
		inv.visible = true
		InventoryManager.freeze = true
	elif inv.visible == true:
		inv.visible = false
		InventoryManager.freeze = false

func equip() -> void:
	is_equipping = true
	is_equipped = !is_equipped
	
	$aim/down.target_position = Vector2(0, primary_gun["range"])
	$aim/up.target_position = Vector2(0, -primary_gun["range"])
	$aim/left.target_position = Vector2(-primary_gun["range"], 0)
	$aim/right.target_position = Vector2(primary_gun["range"], 0)
	
	if is_equipped:
		anim = primary_gun["name"] + "_"
		speed = primary_gun["walk_speed"] * tile_size
		ammo_type = primary_gun["ammo_type"]
		current_ammo = primary_gun["current_ammo"]
		max_ammo = primary_gun["max_ammo"]
		fire_rate = primary_gun["fire_rate"]
		reload_time = primary_gun["reload_time"]
		current_pr_damage = primary_gun["damage"]
		if facing == "right":
			$AnimatedSprite2D.play(primary_gun["name"] + "_equip_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == "left":
			$AnimatedSprite2D.play(primary_gun["name"] + "_equip_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == "up":
			$AnimatedSprite2D.play(primary_gun["name"] + "_equip_back")
			$AnimatedSprite2D.flip_h = false
		elif facing == "down":
			$AnimatedSprite2D.play(primary_gun["name"] + "_equip_front")
			$AnimatedSprite2D.flip_h = false

		await $AnimatedSprite2D.animation_finished
		is_equipping = false
	else:
		anim = ""
		speed = tile_size * 6
		if facing == "right":
			$AnimatedSprite2D.play_backwards(primary_gun["name"] + "_equip_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == "left":
			$AnimatedSprite2D.play_backwards(primary_gun["name"] + "_equip_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == "up":
			$AnimatedSprite2D.play_backwards(primary_gun["name"] + "_equip_back")
			$AnimatedSprite2D.flip_h = false
		elif facing == "down":
			$AnimatedSprite2D.play_backwards(primary_gun["name"] + "_equip_front")
			$AnimatedSprite2D.flip_h = false

		await $AnimatedSprite2D.animation_finished
		is_equipping = false

func shoot():
	if is_equipped == true and can_shoot:
		is_shooting = true
		can_shoot = false
		var guncrip = primary_gun["script"].new()
		guncrip.shoot(current_pr_damage, self)
		if facing == "right":
			$AnimatedSprite2D.play(primary_gun["name"] + "_shoot_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == "left":
			$AnimatedSprite2D.play(primary_gun["name"] + "_shoot_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == "up":
			$AnimatedSprite2D.play(primary_gun["name"] + "_shoot_back")
			$AnimatedSprite2D.flip_h = false
		elif facing == "down":
			$AnimatedSprite2D.play(primary_gun["name"] + "_shoot_front")
			$AnimatedSprite2D.flip_h = false
		flash_screen()
		await $AnimatedSprite2D.animation_finished
		is_shooting = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true


func flash_screen():
	var flash_instance = SCREEN_FLASH.instantiate()
	get_node("camera").add_child(flash_instance)
	var tasdasd = Timer.new()
	tasdasd.wait_time = 0.05
	tasdasd.one_shot = true
	tasdasd.connect("timeout", Callable(flash_instance, "queue_free"))
	flash_instance.add_child(tasdasd)
	tasdasd.start()

func get_rayray():
	if facing == "up":
		return $aim/up
	elif facing == "down":
		return $aim/down
	elif facing == "right":
		return $aim/right
	elif facing == "left":
		return $aim/left
