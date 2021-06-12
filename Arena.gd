extends Node2D

var WallSegment = preload("WallSegment.tscn")

export(NodePath) var player_node_path
var player

var arena_width = 500
var arena_chunk_height = 50
var last_chunk_index = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_node_path).camera
	
func _init():
	# Draw initial arena tiles
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check where player is located, create new chunks
	var player_chunk_index = int(-player.position.y) / arena_chunk_height
	
	# Create new chunks if player is close enough to current last chunk
	while player_chunk_index > last_chunk_index - 3:
		last_chunk_index += 1
		createNewChunk(last_chunk_index)
		

func createNewChunk(index):
	var position = Vector2(-arena_width, -index * arena_chunk_height)
	var extent = Vector2(20, arena_chunk_height)
	
	spawnWallSegment(position, extent)
	position.x *= -1
	spawnWallSegment(position, extent)

func spawnWallSegment(position, extent):
	var new_wall_segment = WallSegment.instance()
	add_child(new_wall_segment)
	
	new_wall_segment.position = position
	new_wall_segment.extents = extent
