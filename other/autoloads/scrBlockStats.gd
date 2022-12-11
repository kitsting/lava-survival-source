extends Node

const blockair = {
	name = "Air",
	durability = 1,
	color = Color(0,0,0),
	sprite = "res://sprites/block/null.png",
	sound = "res://sounds/SentryAlert1.wav",
	startlimit = 0,
	toplimit = 0
}

const blockinvincible = {
	name = "Invinciblock",
	durability = 8000,
	color = Color(1,1,1),
	sprite = "res://sprites/block/null.png",
	sound = "res://sounds/block/invinciblockplace.wav",
	startlimit = 2500,
	toplimit = 2500
}

var blockwood = {
	name = "Wood",
	durability = 120,
	color = Color(0.632, 0.281, 0),
	sprite = "res://sprites/block/wood/wood.png",
	sound = "res://sounds/block/woodplace.wav",
	startlimit = 50,
	toplimit = 500
}

var blockstone = {
	name = "Bricks",
	durability = 300,
	color = Color(0.316, 0.316, 0.316),
	sprite = "res://sprites/block/stone/stone.png",
	sound = "res://sounds/block/stoneplace.wav",
	startlimit = 20,
	toplimit = 450
}

const blocksteel = {
	name = "Steel",
	durability = 950,
	color = Color(0.78125, 0.2635, 0.036621),
	sprite = "res://sprites/block/steel/steel.png",
	sound = "res://sounds/block/steelplace.wav",
	startlimit = 10,
	toplimit = 400
}

const blockmine = {
	name = "Landmine",
	durability = 1,
	color = Color(0,0,0),
	sprite = "res://sprites/block/landmine.png",
	sound = "res://sounds/block/mineplace.wav",
	startlimit = 15,
	toplimit = 15
}

const blockdoor = {
	name = "Forcefield",
	durability = 1,
	color = Color(0,0,0),
	sprite = "res://sprites/testing/TestSquare3.png",
	sound = "res://sounds/block/doorplace.wav",
	startlimit = 3,
	toplimit = 3
}

var blocks = [blockair,blockinvincible,blockwood,blockstone,blocksteel,blockmine,blockdoor]


var blocklimit : Array
var blocksallowed = [2,3]

var players = 1
var roundnum = 0; var scorenum = 0
var preptime = false
var map = 1
const mapsize = \
[
	gloConst.mapfactory.size,
	gloConst.mapdesert.size,
	gloConst.mapbeach.size,
	gloConst.maplab.size,
	gloConst.mapmines.size,
	gloConst.mapsky.size,
	gloConst.mapfuture.size
	]

var lavaspeed; var lavaintensity; var lavadecay
var lavadirection; var lavadircardinal

var player1pos = Vector2(0,0)

var lavatlpos = Vector2(0,0)
var lavatrpos = Vector2(384,0)
var lavablpos = Vector2(0,216)
var lavabrpos = Vector2(384,216)

var lavaleftpos = Vector2(0,0)
var lavarightpos = Vector2(384,0)
var lavatoppos = Vector2(0,216)
var lavabottompos = Vector2(384,216)

var roundleft = 0
var dying = false

var p1respawntime = 0

var controls = 0

var cosmetics = []
var badges = []

#0 = Towards bottom right
#1 = Towards bottom left
#2 = Towards top left
#3 = Towards top right


func _ready():
	cosmetics = directory_prep("res://sprites/player/cosmetic/")
	badges = directory_prep("res://sprites/icons/badge/")
	reset_stats()
	randomize()

func set_dir(dir,cardinal=false):
	if !cardinal:
		lavadirection = dir
	if cardinal:
		lavadircardinal = dir
	
func reset_stats():
	if gloSettings.usedebug:
		blocksallowed = [1,2,3,4,5,6]
	else:
		blocksallowed = [2,3,6]
	lavaspeed = 30
	lavaintensity = 1
	lavadecay = 180
	lavadirection = 0
	reset_blocks()
	
	lavatlpos = Vector2(0,0)
	lavatrpos = Vector2(384,0)
	lavablpos = Vector2(0,216)
	lavabrpos = Vector2(384,216)
	
	dying = false
	
	get_stone()
	get_wood()
	
	
func reset_blocks():
#	for block in blocks:
#		blocklimit.append(block.startlimit)
	blocklimit = [blockair.startlimit,blockinvincible.startlimit,blockwood.startlimit,blockstone.startlimit,blocksteel.startlimit,blockmine.startlimit,blockdoor.startlimit]

	
func new_allowed(newarray,add=false):
	if !add:
		gloBlockStats.blocksallowed = newarray
		
	if get_tree().get_root().has_node("GameHandler/HUD"):
		get_tree().get_root().get_node("GameHandler/HUD").update_hotbar()


func get_stone():
	var variants = []
	var dir = Directory.new()
	dir.open("res://sprites/block/stone/")
	dir.list_dir_begin(true,true)
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".import"):
			var file_name = file.replace(".import","")
			variants.append("res://sprites/block/stone/"+file_name)
			
	dir.list_dir_end()
	
	blockstone.sprite = str(gloSettings.choose(variants))
	#print(blockstone.sprite)
	
	
func get_wood():
	var variants = []
	var dir = Directory.new()
	dir.open("res://sprites/block/wood/")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".import"):
			var file_name = file.replace(".import","")
			variants.append("res://sprites/block/wood/"+file_name)
			
	dir.list_dir_end()
	
	blockwood.sprite = str(gloSettings.choose(variants))
	#print(blockstone.sprite)	
	
	
func directory_prep(directory):
	var variants = []
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		if file.ends_with(".import"):
			var file_name = file.replace(".import","")
			variants.append(directory+file_name)
	
	return variants
	
	
	
