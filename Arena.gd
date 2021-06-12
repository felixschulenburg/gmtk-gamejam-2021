extends Node2D

var WallSegment = preload("WallSegment.tscn")

export(NodePath) var player_node_path
var player

var width = 500
var arenaChunkHeight = 500
var lastChunkIndex = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_node_path)
	
func _init():
	# Draw initial arena tiles
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check where player is located, create new chunks
	var playerChunkIndex = int(player.position.y) / arenaChunkHeight
	
	# Create new chunks if player is close enough to current last chunk
	while playerChunkIndex > lastChunkIndex - 3:
		lastChunkIndex += 1
		createNewChunk(lastChunkIndex)
		
	pass

func createNewChunk(index):
	var new_wall_segment = WallSegment.instance()
	add_child(new_wall_segment)
	
	new_wall_segment.position = Vector2(0, -index * arenaChunkHeight)
	new_wall_segment.extents.y = arenaChunkHeight
