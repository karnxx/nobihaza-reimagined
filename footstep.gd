class_name Footstep
extends AudioStreamPlayer2D

var stream_rnd : AudioStreamRandomizer
@export var footsteps : Array[AudioStream]

func _ready() -> void:
	stream_rnd = AudioStreamRandomizer.new()
	stream_rnd.random_pitch = 2
	stream_rnd.random_volume_offset_db = 4
	stream = stream_rnd

func playd() -> void:
	get_fs()
	if not playing:
		play()

func get_fs():
	for t in get_tree().get_nodes_in_group("tilemap"):
		if t is TileMapLayer:
			if t.tile_set.get_custom_data_layer_by_name("footstep_type") == -1:
				continue
			var cell: Vector2i = t.local_to_map(t.to_local(global_position))
			var data: TileData = t.get_cell_tile_data(cell)
			if data:
				var type = data.get_custom_data("footstep_type")
				if type == null:
					continue
				if stream_rnd.get_length() == 0:
					stream_rnd.add_stream(0, footsteps[type])
				else:
					stream_rnd.set_stream(0, footsteps[type])
