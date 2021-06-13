extends Node2D

var WallSegment = preload("WallSegment.tscn")

export(NodePath) var player_node_path
var player

export var arena_width = 500
export var arena_chunk_height = 500
export var platforms_per_chunk = 3
export var platform_spawn_disable_margin = 40

var last_chunk_index = -1
var wall_segments = []

var start_prefab = preload("Prefabs/Start.tscn")
var arena_prefabs = [
	preload("Prefabs/001.tscn"),
	preload("Prefabs/002.tscn"),
	preload("Prefabs/003.tscn"),
	preload("Prefabs/004.tscn"),
	preload("Prefabs/005.tscn")
]

var last_chunk
var last_arena_prefab_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player = get_node(player_node_path).camera
	
func _init():
	var start = start_prefab.instance()
	last_chunk = start
	add_child(start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check where player is located, create new chunks
	var player_chunk_index = int(-player.position.y) / arena_chunk_height
	
	# Create new chunks if player is close enough to current last chunk
	while player_chunk_index > last_chunk_index - 3:
		last_chunk_index += 1
		createNewChunk(last_chunk_index)
		

func createNewChunk(chunk_index):	
	# Get random world prefab
	var rnd_id = last_arena_prefab_id
	if arena_prefabs.size() > 1:
		while rnd_id == last_arena_prefab_id:
			rnd_id = randi() % arena_prefabs.size()
		
	last_arena_prefab_id = rnd_id
	var new_chunk = arena_prefabs[rnd_id].instance()
	add_child(new_chunk)
	
	# Move chunk to correct position
	new_chunk.move_entry_to(last_chunk.exit)
	last_chunk = new_chunk
	
	
	return
	var position = Vector2(-arena_width, -chunk_index * arena_chunk_height)
	var extent = Vector2(20, arena_chunk_height / 2)
	
	
	spawnWallSegment(position, extent)
	position.x *= -1
	spawnWallSegment(position, extent)
	
	for i in platforms_per_chunk:
		spawnRandomWallGeometry(chunk_index)
	

func spawnWallSegment(position, extent, rotation_degrees=0, discard_if_collision=false, spawn_area_extra_extent=20):
	var new_wall_segment = WallSegment.instance()
	add_child(new_wall_segment)
		
	new_wall_segment.position = position
	new_wall_segment.set_extents(extent, spawn_area_extra_extent)
	new_wall_segment.rotation_degrees = rotation_degrees	
	
	if discard_if_collision:
		if wallSegmentCollides(new_wall_segment):
			remove_child(new_wall_segment)
			return false
			
	wall_segments.append(new_wall_segment)
	return true

func spawnRandomWallGeometry(chunk_index):
	var did_spawn = false
	while not did_spawn:
		var posx = rand_range(-arena_width, arena_width)
		var posy = rand_range(-(chunk_index-0.5) * arena_chunk_height, -(chunk_index+0.5) * arena_chunk_height)
		var extx = rand_range(arena_width * 0.3, arena_width * 0.7)
		var exty = 5
		var rotation_degrees = rand_range(-30, 30)
		did_spawn = spawnWallSegment(Vector2(posx, posy), Vector2(extx, exty), rotation_degrees, true, platform_spawn_disable_margin)
	
func wallSegmentCollides(wall_segment):
	for seg in wall_segments:
		var collides = wall_segment.spawn_area_collision_shape.collide(
			wall_segment.transform,
			seg.spawn_area_collision_shape,
			seg.transform
		)
		if collides:
			return true
		
	return false
