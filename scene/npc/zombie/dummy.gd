extends CharacterBody2D

@export var health := 200
var is_moving := false
var facing : String = "down"
var sprite_node_tween : Tween
var tile_size := 16
var speed := tile_size * 4

var is_plr := false
var plr : Node2D = null
var plr_pos : Vector2

@export var collision : TileMapLayer = null
@export var tilemap : TileMapLayer
@export var visual_line : Line2D = null

var pathfinding_grid := AStarGrid2D.new()
var path := []

func _physics_process(delta: float) -> void:
	if is_plr:
		chase()

func _ready() -> void:
	visual_line.global_position = Vector2(tile_size/2, tile_size/2)
	pathfinding_grid.region =tilemap.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update()
	print(tilemap.get_used_rect())
	
	for cell in collision.get_used_cells():
			pathfinding_grid.set_point_solid(cell, true)

func chase():
	path = pathfinding_grid.get_point_path(global_position / tile_size, plr.global_position / tile_size)
	if path.size() > 1:
		path.remove_at(0)
		var go_to :Vector2= path[0] + Vector2(tile_size/2, tile_size/2)
		
		if go_to.x != global_position.x:
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = true if go_to.x > global_position.x else false
		print(go_to)
		global_position = go_to
		
		visual_line.points = path
			
func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		queue_free()


func _on_plrdetec_body_entered(body: Node2D) -> void:
	if body.is_in_group("plr"):
		is_plr = true
		plr = body


func _on_plrdetec_body_exited(body: Node2D) -> void:
	if body.is_in_group("plr"):
		is_plr = false
		plr = null
