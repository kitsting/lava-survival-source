"""
Handles the placing/deleting of blocks and lava
"""
extends Node2D

signal blockidchange
signal lavanumberchange
signal make_map_object

var Block = preload("res://objects/blocks/Block.tscn")
var lava = preload("res://objects/lava/lava.tscn")
var lavavacate = preload("res://objects/lava/LavaVacated.tscn")

var blockid = 1
var blocknumber = 0
var lavanumber = 0
var tilesize = 16
var gridsize = gloBlockStats.mapsize[gloBlockStats.map]

var grandparent
var blockgrid = []
var spawners = []
var blockwait = false

enum GRID {
	MISC = 1,
	BLOCK = 2,
	LAVA = 3,
	BLOCKHAZARD = 4,
	LAVAHAZARD = 5,
	COLLISION = 6,
	SPAWNER = 7,
	FULL = 8,
	MINE = 9,
	DUMMY2 = 10
}


func _ready(): #Grid, variable, and particle setup
	emit_signal("lavanumberchange",lavanumber)
	
	for x in range(gridsize.x+1):
		blockgrid.append([])
		for y in range(gridsize.y+1):
			blockgrid[x].append(null)
	
	grandparent = get_parent().get_parent()
	
	$Particle.emitting = false
	$Particle.one_shot = true
	
		
func get_ray_pos(x,y,get_areas=true): #Get object at ray position
	$Ray.collide_with_areas = get_areas
	var g = null
	$Ray.enabled = true
	$Ray.set_position(Vector2(x,y))
	$Ray.cast_to = Vector2(x,y)
	$Ray.force_raycast_update()
	if $Ray.is_colliding(): g = $Ray.get_collider()
	$Ray.enabled = false
	return g
	
func check_block(x,y): #Check if a block exists at a raypos (May be unused)
	var getblock = get_ray_pos(x,y)
	if getblock != null:
		if getblock.is_in_group("Block"): return getblock
		else: return null

func is_cell_empty(x,y,excl=null,excl2=null): #Check if a specified cell has nothing in it
	if (x == NAN) or (y == NAN): return false
	if blockgrid.size() != 0:
		if x > gridsize.x or x < 0: return false
		elif y > gridsize.y or y < 0: return false
		elif blockgrid[x][y] == null or blockgrid[x][y] == excl or blockgrid[x][y] == excl2: return true
	return false
	
func get_cell_type(x,y):
	if (x == NAN) or (y == NAN): return null
	if blockgrid.size() != 0:
		if x > gridsize.x or y < 0: return null
		elif y > gridsize.y or y < 0: return null
		return blockgrid[x][y]

func add_to_grid(x,y,type=GRID.MISC): #Mark a grid cell as occupied at the specified cell
	if !gloSettings.uselava or gloSettings.lavaprevention: 
		if type == GRID.LAVA: return 0
	if (x == NAN) or (y == NAN): return 0	
	if blockgrid.size() != 0:
		if x > gridsize.x or x < 0: return 0
		if y > gridsize.y or y < 0: return 0
		if blockgrid[x][y] == 1:
			return
		blockgrid[x][y] = type
		if type == 7:
			#print("Added "+str(type)+" to grid at "+str(x)+","+str(y))
			spawners.append(Vector2(x,y))
		if !spawners.empty():
			for spawner in spawners:
				if get_cell_type(spawner.x,spawner.y) == 5:
					if spawner.x == x and spawner.y == y:
						blockgrid[x][y] = GRID.SPAWNER
						return

func remove_from_grid(x,y): #Mark a grid cell as unoccupied at the specified cell
	if (x == NAN) or (y == NAN): return 0
	if blockgrid.size() != 0:
		if x > gridsize.x or x < 0: return 0
		if y > gridsize.y or y < 0: return 0
		blockgrid[x][y] = null
		if !spawners.empty():
			for spawner in spawners:
				if spawner.x == x and spawner.y == y:
					blockgrid[x][y] = GRID.SPAWNER
					return
		
func make_lava(x,y): #Make lava at the specified coordinates
	var tempx = round(x/16); var tempy = round(y/16)
	var block = is_cell_empty(tempx,tempy,GRID.SPAWNER,GRID.MINE)
	if block:
		var morelava = lava.instance()
		add_to_grid(tempx,tempy,GRID.LAVA)
		get_parent().add_child(morelava)
		morelava.position = Vector2(tempx*16,tempy*16)
		#morelava.position.x = (tempx*16)
		#morelava.position.y = (tempy*16)
		lava_change(1)
	elif !block: spread_damage(x,y)
	return block
				
func lava_change(amount): #Visually change how much lava is on screen
	lavanumber += amount
	emit_signal("lavanumberchange",lavanumber)
	
func spread_lava(x,y,_dir): #Spread lava in a specified direction
	if gloSettings.uselava or !gloSettings.lavaprevention:
		return bool(int(make_lava(x+16,y))*int(make_lava(x,y+16))*int(make_lava(x,y-16))*int(make_lava(x-16,y)))
	return false
	
func make_particles(x,y,texture,amount): #Make particles at a specified position
	$Particle.position.x = x
	$Particle.position.y = y
	$Particle.amount = amount
	#$Particle.set_texture(texture)
	$Particle.modulate = texture
	$Particle.emitting = true
	
func spread_damage(x,y):
	var search = [Vector2(1,1),Vector2(-1,1),Vector2(1,-1),Vector2(-1,-1)]
	for item in search:
		var delblock = get_ray_pos(x+item.x,y+item.y)
		if delblock != null:
			if delblock.is_in_group("Block"):
				if gloBlockStats.roundnum%5:
					var isbroken = delblock.take_damage(ceil(gloBlockStats.lavaintensity/1.5),true)
					if isbroken: remove_from_grid(round((x+sign(item.x))/16),round((y+sign(item.y))/16))
				else:
					var isbroken = delblock.take_inverse_damage(ceil(gloBlockStats.lavaintensity/1.5),true)
					if isbroken: remove_from_grid(round((x+sign(item.x))/16),round((y+sign(item.y))/16))
			
			
func place_block(x,y,id,limit=[0,0,0,0,0,0,0,0,0,0,0],byplayer=false):
	if get_cell_type(x,y) == null or get_cell_type(x,y) == 5:
		if limit[id] == 0:
			hsound.ui_play_sound(load("res://sounds/misc/blockempty.wav"))
			return 0
		var blockcheck = get_ray_pos(x*16,y*16)
		var scorchcheck = get_ray_pos(x*16,y*16,true)
		if scorchcheck != null:
			if scorchcheck.is_in_group("Scorch"):
				return 0
		if blockcheck != null:
			if blockcheck.is_in_group("BlockHazard"):
				return 0
		if id == 6:
			if (get_cell_type(x-1,y) != 2 or get_cell_type(x+1,y) != 2) and (get_cell_type(x,y-1) != 2 or get_cell_type(x,y+1) != 2):
				return 0
		var placeblock = Block.instance()
		get_parent().add_child(placeblock)
		if byplayer:
			gloSettings.stat_change(gloSettings.STAT.BLOCKSPLACED,1)
		placeblock.position.x = (x*16)
		placeblock.position.y = (y*16)
		placeblock.update_block_id(id)
		if id == 5:
			print("Made mine at "+str(x)+","+str(y))
			add_to_grid(x,y,GRID.MINE)
			limit[id] -= 1
			return 0
		add_to_grid(x,y,GRID.BLOCK)
		blocknumber += 1
		limit[id] -= 1
		emit_signal("blockidchange",id,blocknumber,limit)

		
func delete_block(x,y,limit):
	if blockgrid[x][y] != null:
		var delblock = get_ray_pos(x*16,y*16,false) #Check if the cursor is on a solid block
		if delblock != null:
			if delblock.is_in_group("Block"):
				var tempid = delblock.blockid
				if delblock.durability > gloBlockStats.blocks[tempid].durability*0.9:
					if limit != null: limit.get_blocks(tempid,1)
				delblock.take_damage(10000)
				#remove_from_grid(x,y)
				blocknumber -= 1
				emit_signal("blockidchange",blockid,blocknumber,limit)
		else:
			delblock = get_ray_pos(x*16,y*16,true) #If the above check fails, check for non-solid blocks
			if delblock != null:
				if delblock.is_in_group("BlockDoor"):
					$BlockAudio.stream = load("res://sounds/block/doorplace.wav")
					$BlockAudio.pitch_scale = float(rand_range(0.4,0.8))
					$BlockAudio.play(0.0)
					delblock.queue_free()
					if limit != null: limit.get_blocks(6,1)
					remove_from_grid(x,y)
					blocknumber -= 1
					emit_signal("blockidchange",6,blocknumber,limit)


func _on_Player_breaking(x,y,limit):
	if blockwait:
		delete_block(x,y,limit)

func _on_Player_placing(x,y,id,limit,true):
	if blockwait:
		place_block(x,y,id,limit)
	
func spawn_vacate(x,y):
	var laster = lavavacate.instance()
	laster.position.x = x
	laster.position.y = y
	get_parent().get_parent().get_node("Particle").add_child(laster)


func _on_WaitTimer_timeout():
	blockwait = true
	$WaitTimer.queue_free()
