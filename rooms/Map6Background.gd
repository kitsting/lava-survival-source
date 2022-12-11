extends Node2D


func _ready():
	$Road.set_tile_origin(TileMap.TILE_ORIGIN_TOP_LEFT)
	$Curb.set_tile_origin(TileMap.TILE_ORIGIN_TOP_LEFT)
	
	hsound.play_music(load("res://sounds/music/Future.ogg"))

func _exit_tree():
	hsound.stop_sound(2)
