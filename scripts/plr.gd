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
var primary_gun
var secondary
var is_moving = false
var facing : String = "left"
var sprite_node_tween : Tween
var target_pos :Vector2
var tile_size = 16
var speed = 0.15
var anim = ""
var is_equipped = false
var is_equipping = false  
var is_shooting= false

func _ready() -> void:
	InventoryManager.set_player(self)


func _process(_delta: float) -> void:
	if !InventoryManager.freeze:
		check_interactable()
	if Input.is_action_just_pressed("inv"):
		show_inv()
	if Input.is_action_just_pressed("equip"):
		primary_gun = InventoryManager.gun_inv[0]
		equip()
	if Input.is_action_just_pressed("ui_accept") and is_equipped == true:
		shoot()

func _physics_process(_delta: float) -> void:
	if !InventoryManager.freeze:
		movement()

func animatee(animation: String, flip: bool) -> void:
	$AnimatedSprite2D.play(animation)
	$AnimatedSprite2D.flip_h = flip

func movement() -> void:
	if sprite_node_tween and sprite_node_tween.is_running():
		return

	var dir := Vector2.ZERO
	
	if is_equipping:
		return
	if is_shooting:
		return
	
	if Input.is_action_pressed("ui_up") and not $movement/up.is_colliding():
		dir = Vector2(0, -1)
		animatee(anim + "walk_back", false)
		facing = "up"
	elif Input.is_action_pressed("ui_down") and not $movement/down.is_colliding():
		dir = Vector2(0, 1)
		animatee(anim + "walk_front", false)
		facing = "down"
	elif Input.is_action_pressed("ui_left") and not $movement/left.is_colliding():
		dir = Vector2(-1, 0)
		animatee(anim + "walk_side", false)
		facing = "left"
	elif Input.is_action_pressed("ui_right") and not $movement/right.is_colliding():
		dir = Vector2(1, 0)
		animatee(anim + "walk_side", true)
		facing = "right"
	else: 
		dir = Vector2(0,0)
		if facing == "left":
			animatee(anim + "idle_side", false)
		elif facing == "right":
			animatee(anim + "idle_side", true)
		elif facing == "up":
			animatee(anim + "idle_back", false)
		elif facing == "down":
			animatee(anim + "idle_front", false)
	
	if dir != Vector2.ZERO:
		move(dir)
	
func move(dir: Vector2) -> void:
	if is_moving:
		return
	
	is_moving = true
	target_pos = position + dir * tile_size
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_pos, speed) .set_trans(Tween.TRANS_SINE) .set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "move_finish"))
	
func move_finish() -> void:
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
	if is_equipped == true:
		is_shooting = true
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
		
		
func flash_screen():
	var flash_instance = SCREEN_FLASH.instantiate()
	get_node("camera").add_child(flash_instance)
	var tasdasd = Timer.new()

	tasdasd.wait_time = 0.05
	tasdasd.one_shot = true
	tasdasd.connect("timeout", Callable(flash_instance, "queue_free"))
	flash_instance.add_child(tasdasd)
	tasdasd.start()
