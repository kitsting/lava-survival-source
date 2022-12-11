extends Node2D

# Declare member variables here. Examples:
var stormtiles = preload("res://sprites/tilesets/Outside16x.png")
var nighttiles = preload("res://sprites/tilesets/Outside16xNight.png")
var suntiles = preload("res://sprites/tilesets/Outside16xSunrise.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	hsound.play_music(load("res://sounds/music/DrySpell.ogg"))
	
	var sprite = randi()%3
	#0 = stormy
	#1 = night
	#2 = sunset
	if sprite == 0:
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkyCloudy.png")
		$TileMap.tile_set.tile_set_modulate(1,gloConst.weathernormal)
		$TileMap.tile_set.tile_set_modulate(5,Color(1,1,1))
		$Background/Forground/Sprite.texture = load("res://sprites/misc/backgrounds/desert/MountainsCloudy.png")
	elif sprite == 1:
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkyNight.png")
		$TileMap.tile_set.tile_set_modulate(1,gloConst.weathernight)
		$TileMap.tile_set.tile_set_modulate(5,gloConst.weathernight)
		$Background/Forground/Sprite.texture = load("res://sprites/misc/backgrounds/desert/MountainsNight.png")
	elif sprite == 2:
		$Background/Sky/Sprite.texture = load("res://sprites/misc/backgrounds/desert/SkySunrise.png")
		$TileMap.tile_set.tile_set_modulate(1,gloConst.weathersunset)
		$TileMap.tile_set.tile_set_modulate(5,gloConst.weathersunset)
		$Background/Forground/Sprite.texture = load("res://sprites/misc/backgrounds/desert/MountainsSunrise.png")
		
	$TileMap.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap2.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	$TileMap3.set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
	
func _exit_tree():
	hsound.stop_sound(2)
