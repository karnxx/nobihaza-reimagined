extends CharacterBody2D

@export var health := 200
var is_moving := false
var facing : String = "down"
var sprite_node_tween : Tween
var tile_size := 16
var speed := tile_size * 2
var is_plr := false
var plr : Node2D = null
var plr_pos : Vector2
var is_ongrnd = false
@export var dmg : int
@export var collision : TileMapLayer = null
@export var tilemap : TileMapLayer
@export var cd := 1.0
var pathfinding_grid := AStarGrid2D.new()
var path := []            
var dir : Vector2
var target_pos : Vector2
var is_falling = false
var plr_in_range = false
var is_attacking =false
var time_in_range := 0.0
var setfaceing :String
var isdming = false
var is_dead = false
var can_sound = true
func _ready() -> void:
	pathfinding_grid.region = tilemap.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update()
	for cell in collision.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)




func _physics_process(delta: float) -> void:
	if is_plr and not (
		($move/up.is_colliding() and $move/up.get_collider().is_in_group("plr")) or
		($move/down.is_colliding() and $move/down.get_collider().is_in_group("plr")) or
		($move/left.is_colliding() and $move/left.get_collider().is_in_group("plr")) or
		($move/right.is_colliding() and $move/right.get_collider().is_in_group("plr"))) and is_ongrnd == false and is_falling == false and is_attacking == false and isdming == false:
		chase()
	attack(delta)
	if is_ongrnd == false and is_moving == false and not is_falling and not is_attacking and not isdming:
		if facing == "left":
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == "right":
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == "up":
			$AnimatedSprite2D.play("idle_back")
			$AnimatedSprite2D.flip_h = false
		elif facing == "down":
			$AnimatedSprite2D.play("idle_front")
			$AnimatedSprite2D.flip_h = false
	

func chase():
	var from_cell = (global_position / tile_size).floor()
	var to_cell   = (plr.global_position / tile_size).floor()
	var from_id = Vector2i(int(from_cell.x), int(from_cell.y))
	var to_id   = Vector2i(int(to_cell.x), int(to_cell.y))

	var id_path = pathfinding_grid.get_id_path(from_id, to_id)
	if id_path.size() > 1 and not is_moving:
		id_path.remove_at(0)
		var next_id : Vector2i = id_path[0]
		var dir_id = next_id - from_id  
		dir = Vector2(dir_id.x, dir_id.y)
		if dir.x > 0:
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = true
			facing = "right"
		elif dir.x < 0:
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = false
			facing = "left"
		elif dir.y > 0:
			$AnimatedSprite2D.play("walk_front")
			$AnimatedSprite2D.flip_h = false
			facing = "down"
		elif dir.y < 0:
			$AnimatedSprite2D.play("walk_back")
			$AnimatedSprite2D.flip_h = false
			facing = "up"
		move(position + dir * tile_size)

func move(goto: Vector2, speed_multiplier: float = 1.0) -> bool:
	if is_moving:
		return false
	$Footstep.playd()
	if randi() % 3 == 0  and can_sound:
		if randi() % 2 == 0:
			play_sound(preload("res://assets/music/sfc/zombie-moan-44932.mp3"))
			can_sound = false
			$sound.wait_time = randi_range(1,7)
			$sound.start()
		else:
			play_sound(preload("res://assets/music/sfc/horrific-zombie-growl-107090.mp3"))
			can_sound = false
			$sound.wait_time = randi_range(1,7)
			$sound.start()
	var target_cell: Vector2i = (goto / tile_size).floor()
	var current_cell: Vector2i = (global_position / tile_size).floor()

	if not GameManager.is_tile_free(target_cell):
		return false
	if not is_dead:
		GameManager.release_tile(current_cell)
		GameManager.reserve_tile(target_cell, self)

	is_moving = true
	target_pos = goto   

	var distance := global_position.distance_to(goto)
	var duration = max(0.05, distance / (speed * speed_multiplier)) 
	
	if sprite_node_tween and sprite_node_tween.is_running():
		sprite_node_tween.kill()
	
	sprite_node_tween = create_tween()
	sprite_node_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_tween.tween_property(self, "global_position", goto, duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	sprite_node_tween.finished.connect(move_finish)

	return true

func move_finish() -> void:
	is_moving = false

func take_dmg(dmg):
	health -= dmg
	isdming = true
	if is_dead:
		return
	var blood = preload("res://scene/particle/blood.tscn").instantiate()
	get_tree().current_scene.add_child(blood)
	blood.global_position = global_position
	if facing == "left":
		$AnimatedSprite2D.play("attacked_side")
		$AnimatedSprite2D.flip_h = false
	elif facing == "right":
		$AnimatedSprite2D.play("attacked_side")
		$AnimatedSprite2D.flip_h = true
	elif facing == "up":
		$AnimatedSprite2D.play("attacked_back")
		$AnimatedSprite2D.flip_h = false
	elif facing == "down":
		$AnimatedSprite2D.play("attacked_front")
		$AnimatedSprite2D.flip_h = false
	if randi() % 2 == 0:
		play_sound(preload("res://assets/music/sfc/zombie-6851.mp3"))
	else:
		play_sound(preload("res://assets/music/sfc/zombie-choking-44937.mp3"))
	await get_tree().create_timer(0.8).timeout
	
	if health <= 0 and not is_dead:
		is_dead = true
		
		set_collision_layer(0)
		set_collision_mask(0)
		$CollisionShape2D.disabled = true
		$plrdetec/CollisionShape2D.disabled = true
		
		var cell := (global_position / tile_size).floor()
		GameManager.release_tile(cell)
		
		if facing == "left":
			self.thrown(Vector2.RIGHT, 1, "death")
		elif facing == "right":
			self.thrown(Vector2.LEFT, 1, "death")
		elif facing == "up":
			self.thrown(Vector2.DOWN, 1, "death")
		elif facing == "down":
			self.thrown(Vector2.UP, 1, "death")
		play_sound(preload("res://assets/music/sfc/zmb2_dead-92305.mp3"))
		var twen = create_tween()
		twen.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 4.0)
		twen.tween_callback(self.queue_free)
		
	isdming = false

func _on_plrdetec_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		is_plr = true
		plr = body

func grab(player):
	is_attacking = true
	player.grabbed = true
	if is_dead:
		return
	while player.grabbed:
		if facing == "left":
			$AnimatedSprite2D.play("attack_side")
			$AnimatedSprite2D.flip_h = false
		elif facing == "right":
			$AnimatedSprite2D.play("attack_side")
			$AnimatedSprite2D.flip_h = true
		elif facing == "up":
			$AnimatedSprite2D.play("attack_back")
			$AnimatedSprite2D.flip_h = false
		elif facing == "down":
			$AnimatedSprite2D.play("attack_front")
			$AnimatedSprite2D.flip_h = false

		await get_tree().create_timer(1).timeout
		if player.grabbed == true:
			player.get_dmged(randf_range(dmg * 0.9, dmg * 1.2))

	if facing == "left":
		self.thrown(Vector2.RIGHT)
	elif facing == "right":
		self.thrown(Vector2.LEFT)
	elif facing == "up":
		self.thrown(Vector2.DOWN)
	elif facing == "down":
		self.thrown(Vector2.UP)

	is_attacking = false


func thrown(direca: Vector2, tiles:=2, use:="falling") -> void:
	is_ongrnd = true
	if is_moving: 
		return
	set_collision_layer_value(1, false) 
	set_collision_mask_value(1, false)
	set_collision_layer_value(2, true)  
	set_collision_mask_value(2, true)
	is_falling = true  

	if abs(direca.x) > abs(direca.y):
		direca = Vector2(sign(direca.x), 0)
	else:
		direca = Vector2(0, sign(direca.y))
	
	var target2 := global_position + direca * tile_size * tiles
	var target1 := global_position + direca * tile_size
	if use == "falling":
		if direca == Vector2.LEFT:
			$AnimatedSprite2D.play("fall_side")
			$AnimatedSprite2D.flip_h = true
		elif direca == Vector2.RIGHT:
			$AnimatedSprite2D.play("fall_side")
			$AnimatedSprite2D.flip_h = false
		elif direca == Vector2.UP:
			$AnimatedSprite2D.play("fall_back")
			$AnimatedSprite2D.flip_h = false
		elif direca == Vector2.DOWN:
			$AnimatedSprite2D.play("fall_front")
			$AnimatedSprite2D.flip_h = false
	elif use == "death":
		if direca == Vector2.LEFT:
			$AnimatedSprite2D.play("died_side")
			$AnimatedSprite2D.flip_h = true
		elif direca == Vector2.RIGHT:
			$AnimatedSprite2D.play("died_side")
			$AnimatedSprite2D.flip_h = false
		elif direca == Vector2.UP:
			$AnimatedSprite2D.play("died_back")
			$AnimatedSprite2D.flip_h = false
		elif direca == Vector2.DOWN:
			$AnimatedSprite2D.play("died_front")
			$AnimatedSprite2D.flip_h = false
	var cell2 := (target2 / tile_size).floor()
	if not pathfinding_grid.is_in_boundsv(cell2) or pathfinding_grid.is_point_solid(cell2):
		var cell1 := (target1 / tile_size).floor()
		if not pathfinding_grid.is_in_boundsv(cell1) or pathfinding_grid.is_point_solid(cell1):
			return
		move(target1, 3.0)
	else:
		move(target2, 3.0)

	await $AnimatedSprite2D.animation_finished
	
	if use != "death":
		await get_tree().create_timer(5).timeout
		is_ongrnd = false
		is_falling = false
		set_collision_layer_value(1, true) 
		set_collision_mask_value(1, true)
		set_collision_layer_value(2, true)  
		set_collision_mask_value(2, true)


	await get_tree().create_timer(1).timeout
	
func attack(delta):
	var player = null
	if is_ongrnd or is_dead:
		return
		
	if $move/up.is_colliding() and $move/up.get_collider().is_in_group("plr"):
		player = $move/up.get_collider()
		facing = "up"
		setfaceing = "down"
	elif $move/down.is_colliding() and $move/down.get_collider().is_in_group("plr"):
		player = $move/down.get_collider()
		facing = "down"
		setfaceing = "up"
	elif $move/left.is_colliding() and $move/left.get_collider().is_in_group("plr"):
		player = $move/left.get_collider()
		facing = "left"
		setfaceing = "right"
	elif $move/right.is_colliding() and $move/right.get_collider().is_in_group("plr"):
		player = $move/right.get_collider()
		facing = "right"
		setfaceing = "left"

	if player:
		plr_in_range = true
		time_in_range += delta

		if time_in_range >= cd and not is_attacking:
			time_in_range = 0.0
			is_attacking = true
			var choices = randi_range(1, 5)

			if choices >= 4:
				player.facing = setfaceing
				player.start_grab(randi_range(30, 50), 5)
				await grab(player) 
			else:
				player.facing = setfaceing
				if facing == "left":
					$AnimatedSprite2D.play("attack_side")
					$AnimatedSprite2D.flip_h = false
				elif facing == "right":
					$AnimatedSprite2D.play("attack_side")
					$AnimatedSprite2D.flip_h = true
				elif facing == "up":
					$AnimatedSprite2D.play("attack_back")
					$AnimatedSprite2D.flip_h = false
				elif facing == "down":
					$AnimatedSprite2D.play("attack_front")
					$AnimatedSprite2D.flip_h = false

				await $AnimatedSprite2D.animation_finished
				player.get_dmged(randf_range(dmg * 0.7, dmg * 1.3))
				is_attacking = false
	else:
		time_in_range = 0.0
		plr_in_range = false

func play_sound(sound):
	if $AudioStreamPlayer.playing:
		return
	if sound != $AudioStreamPlayer.stream:
		$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished

func _on_tree_exiting() -> void:
	var cell := (global_position / tile_size).floor()
	GameManager.release_tile(cell)


func _on_sound_timeout() -> void:
	can_sound = true
