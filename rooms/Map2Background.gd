extends Node2D

var rain = preload("res://objects/environment/Rain.tscn")
var weather = randi()%3

func _ready():
	hsound.play_music(load("res://sounds/music/Sunburn.ogg"))
	
	$TileMap.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap2.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap3.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	
	
	if weather == 0: #Rain
		var newrain = rain.instance()
		#newrain.position.y = -200
		add_child(newrain)
			
		hsound.play_loop(load("res://sounds/loop/rain.ogg"))
	
		modulate_env(gloConst.weathernight)		
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkyCloudy.png")
		
	if weather == 1: #Sunset (Normal)
		modulate_env(gloConst.weathersunrise)
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkySunrise.png")
		
	if weather == 2: #Night
		modulate_env(gloConst.weatherrain)
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkyNight.png")
		
func modulate_env(color):
	$TileMap.tile_set.tile_set_modulate(8,color)
	$TileMap.tile_set.tile_set_modulate(7,color)
	$TileMap.tile_set.tile_set_modulate(9,color)
	$TileMap.tile_set.tile_set_modulate(10,color)
	
	$Background/Water4.modulate = color
	$Background/Water2.modulate = color
	$Background/Water3.modulate = color
	$Background/Water1.modulate = color
	$Background/Island.modulate = color
	
func _exit_tree():
	hsound.stop_sound(2)
	hsound.stop_sound(3)
		
