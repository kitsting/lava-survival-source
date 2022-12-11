extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in $TileMap.get_used_cells_by_id(16):
		$TileMap3.set_cell(tile.x,tile.y,15)
		$TileMap3.update_bitmask_area(Vector2(tile.x,tile.y))
		$TileMap.set_cell(tile.x,tile.y,16,false,false,false,Vector2(variate(),0))
#		var variation = $TileMap.tile_set.generate_variation(tile)
#		$TileMap.set_cell(tile.x, tile.y, tile, false, false, false, variation)
	
	$TileMap.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap2.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap3.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$Waste.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	hsound.play_music(load("res://sounds/music/LeakyPipes.ogg"))
	
	var weather = randi()%3
	
	if weather == 0:
		$TileMap.tile_set.tile_set_modulate(16,gloConst.labblue)
	if weather == 1:
		$TileMap.tile_set.tile_set_modulate(16,gloConst.labgreen)
	if weather == 2:
		$TileMap.tile_set.tile_set_modulate(16,gloConst.labred)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _exit_tree():
	hsound.stop_sound(2)
	
func variate():
	var tempvariate = randi()%48
	if tempvariate <= 40:
		return 0
	if tempvariate == 41:
		return 1
	if tempvariate == 42:
		return 2
	if tempvariate == 43:
		return 3
	if tempvariate == 44:
		return 4
	if tempvariate == 45:
		return 5
	if tempvariate == 46:
		return 6
	if tempvariate == 47:
		return 7
