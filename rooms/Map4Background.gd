extends Node2D

var mines = 2
signal make_mines

# Called when the node enters the scene tree for the first time.
func _ready():
	$TileMap.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Detail.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Back/Ground/DeepGround.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Back/Ground/DeepDetail.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Shadow.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Back/Wall/Wall.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Back/Wall2/Wall2.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Back/Wall3/Wall3.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Ores.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	
	$Ores.visible = true
	
	for tile in $Ores.get_used_cells():
		var ore = get_ore_shape()
		var color = get_gem_color()
		$Ores.set_cell(tile.x,tile.y,24,false,false,false,Vector2(randi()%120,get_gem_color()))
		
	hsound.play_music(load("res://sounds/music/AllHandsOnDeck.ogg"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_gem_color():
	return randi()%6

func get_ore_shape():
	var determine = randi() % 25
	if determine < 20:
		return 3
	if determine <= 21:
		return 0
	if determine == 22:
		return 1
	if determine == 23:
		return 2
		
		
func _exit_tree():
	hsound.stop_sound(2)


func _on_Mine_timeout():
	$Mine.queue_free()
	emit_signal("make_mines",mines)
