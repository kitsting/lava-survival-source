extends Node2D

var dir = 0

func _ready():
	if gloBlockStats.map == 3:
		$Sprite.texture = load("res://sprites/block/lavaspawnerlab.png")

func _process(_delta):
	if gloBlockStats.map == 3:
		if dir == gloBlockStats.lavadirection or dir == gloBlockStats.lavadircardinal:
			$Sprite.texture = load("res://sprites/block/lavaspawnerlabfull.png")
		else:
			$Sprite.texture = load("res://sprites/block/lavaspawnerlab.png")
	elif gloBlockStats.map == 2:
		if dir == gloBlockStats.lavadirection or dir == gloBlockStats.lavadircardinal:
			$Sprite.texture = load("res://sprites/block/lavaspawnerbeachfull.png")
		else:
			$Sprite.texture = load("res://sprites/block/lavaspawnerbeach.png")
	else:
		if dir == gloBlockStats.lavadirection or dir == gloBlockStats.lavadircardinal:
			$Sprite.texture = load("res://sprites/block/lavaspawnerfull.png")
		else:
			$Sprite.texture = load("res://sprites/block/lavaspawner.png")
