extends Node2D

signal lavanumberchange

var lavaspread = gloBlockStats.lavaspeed
var lava = load("res://objects/lava/lava.tscn")
var lavanumber = 0

var lavagrid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(((get_viewport().get_size().x)/16)+2):
		lavagrid.append([])
		for y in range(((get_viewport().get_size().x)/16)+2):
			lavagrid[x].append(0)
	
	randomize()
	gloBlockStats.set_dir(round(rand_range(0,3)))
	var dir = gloBlockStats.lavadirection
	
	if dir == 0:
		make_lava(0,0)
	if dir == 1:
		make_lava(384,0)
	if dir == 2:
		make_lava(384,216)
	if dir == 3:
		make_lava(0,216)
	
	emit_signal("lavanumberchange",get_children().size()-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func make_lava(x,y):
	var tempx = round(x/16)
	var tempy = round(y/16)
	var block = get_parent().is_cell_empty(tempx,tempy)
	if (block == true):
		print("spreading")
		var morelava = lava.instance()
		get_parent().add_to_grid(tempx,tempy)
		add_child(morelava)
		morelava.position.x = tempx*16
		morelava.position.y = tempy*16
		emit_signal("lavanumberchange",get_children().size()-1)
	#if block != null:
		#block.block_damage(gloBlockStats.lavaintensity)
	
func get_ray_pos(x,y):
	var g = null
	$Ray.enabled = true
	$Ray.set_position(Vector2(x,y))
	$Ray.cast_to = Vector2(x,y)
	$Ray.force_raycast_update()
	if $Ray.is_colliding():
		g = $Ray.get_collider()
	$Ray.enabled = false
	return g
	
func lava_change(amount):
	lavanumber += amount
	emit_signal("lavanumberchange",get_children().size()-1)
	
func spread_lava(x,y,dir):
	if dir == 0:
		make_lava(x+16,y)
		make_lava(x,y+16)
		return true
	if dir == 1:
		make_lava(x-16,y)
		make_lava(x,y+16)
		return true
	if dir == 2:
		make_lava(x-16,y)
		make_lava(x,y-16)
		return true
	if dir == 3:
		make_lava(x+16,y)
		make_lava(x,y-16)
		return true
	return false