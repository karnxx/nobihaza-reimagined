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
@export var collision : TileMapLayer = null
@export var tilemap : TileMapLayer
var pathfinding_grid := AStarGrid2D.new()
var path := []            
var dir : Vector2
var target_pos : Vector2

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
		($move/right.is_colliding() and $move/right.get_collider().is_in_group("plr"))):
		chase()

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
		target_pos = position + dir * tile_size
		move(target_pos)


func move(goto: Vector2) -> bool:
	if is_moving:
		return false
	is_moving = true

	var distance := position.distance_to(goto)
	var duration = max(0.05, distance / speed)

	if sprite_node_tween and sprite_node_tween.is_running():
		sprite_node_tween.kill()

	sprite_node_tween = create_tween()
	sprite_node_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_tween.tween_property(self, "position", goto, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	sprite_node_tween.finished.connect(move_finish)
	return true

func move_finish() -> void:
	position = target_pos.snapped(Vector2.ONE)
	is_moving = false

func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		queue_free()

func _on_plrdetec_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		is_plr = true
		plr = body
