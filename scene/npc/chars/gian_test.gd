extends CharacterBody2D

var facing = "down"
var current_dialog = "gian_test_1"
var last_facing
var speed: float = 100.0
var sprite_node_tween: Tween
var is_moving = false
func _ready() -> void:
	Dialogic.signal_event.connect(asd_signal)

func _process(_delta: float) -> void:
	idlee()

func asd_signal(arg):
	if arg =="gian_exit1":
		facing = last_facing
		current_dialog = "giat_test_1_done"
	elif arg == "gian_exit2":
		facing = last_facing
		if $movement/down.is_colliding() and $movement/down.get_collider().is_in_group('plr'):
			await move_tiles(Vector2i.LEFT, 1)
			await move_tiles(Vector2i.DOWN, 3)
			await move_tiles(Vector2i.LEFT, 5)
		else:
			await move_tiles(Vector2i.DOWN, 3)
			await move_tiles(Vector2i.LEFT, 6)
		await move_tiles(Vector2i.UP, 3)
		await move_tiles(Vector2i.RIGHT, 1)
		await move_tiles(Vector2i.UP, 1)
		await get_tree().create_timer(1).timeout
		queue_free()
		InventoryManager.freeze = false
	elif arg =="start_diag":
		InventoryManager.freeze = true
func move_tiles(direction: Vector2i, tiles: int = 1, speed_multiplier: float = 1.0) -> void:
	is_moving = true
	if direction == Vector2i.UP:
		facing = "up"
		$AnimatedSprite2D.play("walk_back")
	elif direction == Vector2i.DOWN:
		facing = "down"
		$AnimatedSprite2D.play("walk_front")
	elif direction == Vector2i.LEFT:
		facing = "left"
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = false
	elif direction == Vector2i.RIGHT:
		facing = "right"
		$AnimatedSprite2D.play("walk_side")
		$AnimatedSprite2D.flip_h = true

	var goto := global_position + (Vector2(direction) * 16 * tiles)
	var distance := global_position.distance_to(goto)
	var duration = max(0.05, distance / (speed * speed_multiplier))

	if sprite_node_tween and sprite_node_tween.is_running():
		sprite_node_tween.kill()

	sprite_node_tween = create_tween()
	sprite_node_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_tween.tween_property(self, "global_position", goto, duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	sprite_node_tween.finished.connect(_on_move_finished)

	await sprite_node_tween.finished
	
func _on_move_finished() -> void:
	is_moving = false
	if facing == "up":
		$AnimatedSprite2D.play("idle_back")
		$AnimatedSprite2D.flip_h = false
	elif facing == "down":
		$AnimatedSprite2D.play("idle_front")
		$AnimatedSprite2D.flip_h = false
	elif facing == "left":
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = false
	elif facing == "right":
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = true

func interact():
	last_facing = facing
	if $movement/up.is_colliding() and $movement/up.get_collider().is_in_group("plr"):
		facing = "up"
	elif $movement/down.is_colliding() and $movement/down.get_collider().is_in_group("plr"):
		facing = "down"
	elif $movement/left.is_colliding() and $movement/left.get_collider().is_in_group("plr"):
		facing = "left"
	elif $movement/right.is_colliding() and $movement/right.get_collider().is_in_group("plr"):
		facing = "right"
	Dialogic.start(current_dialog)

func idlee():
	if is_moving:
		return
	if facing == "up":
		$AnimatedSprite2D.play("idle_back")
		$AnimatedSprite2D.flip_h = false
	elif facing == "down":
		$AnimatedSprite2D.play("idle_front")
		$AnimatedSprite2D.flip_h = false
	elif facing == "left":
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = false
	elif facing == "right":
		$AnimatedSprite2D.play("idle_side")
		$AnimatedSprite2D.flip_h = true
