extends StaticBody2D

signal make_map_object

var blockid = 0
var durability = 5000
var breakprefix = ""

onready var handler : Node = get_parent().get_node("BlockHandler")
onready var sound : Node = handler.get_node("BlockAudio")

var init = false

var mine = preload("res://objects/blocks/Mine.tscn")
var door = preload("res://objects/blocks/Door.tscn")
var scorch = preload("res://objects/blocks/Scorched.tscn")


func _ready():
	$Anim.play("build")
	breakprefix = gloSettings.choose(["","B","C"])


func update_block_id(id):
	if id == 5:
		var minemine = mine.instance()
		minemine.position = position
		get_parent().add_child(minemine)
		self.queue_free()
	if id == 6:
		var minemine = door.instance()
		minemine.position = position
		get_parent().add_child(minemine)
		self.queue_free()
	blockid = id
	durability = gloBlockStats.blocks[blockid].durability
	var tempsprite = load(gloBlockStats.blocks[blockid].sprite)
	$Sprite.set_texture(tempsprite)
	sound.stream = load(gloBlockStats.blocks[blockid].sound)
	sound.pitch_scale = float(rand_range(0.8,1.2))
	sound.play(0.0)
	
	
func take_damage(amount,fromlava=false):
	durability -= amount
	
	if durability < gloBlockStats.blocks[blockid].durability*0.9:
		$BreakSprite.texture = load("res://sprites/block/breaking/Breaking%s1.png"%breakprefix)
	if durability < gloBlockStats.blocks[blockid].durability*0.6:
		$BreakSprite.texture = load("res://sprites/block/breaking/Breaking%s2.png"%breakprefix)
	if durability < gloBlockStats.blocks[blockid].durability*0.3:
		$BreakSprite.texture = load("res://sprites/block/breaking/Breaking%s3.png"%breakprefix)
	
	if durability <= 0:
		sound.stream = load(gloBlockStats.blocks[blockid].sound)
		sound.pitch_scale = float(rand_range(0.4,0.8))
		sound.play(0.0)
		handler.make_particles(position.x,position.y,gloBlockStats.blocks[blockid].color,30)#((durability+amount)-tempdur))
		handler.remove_from_grid(round(position.x/16),round(position.y/16))
		if fromlava:
			var newscorch = scorch.instance()
			newscorch.position = position
			get_parent().get_node("BlockHandler").emit_signal("make_map_object",newscorch)
		queue_free()
		return true
	return false
	
	
func take_inverse_damage(amount,fromlava=false):
	var factor = 1
	match blockid:
		2:
			factor = 0.25
		3:
			factor = 1
		4:
			factor = 1.75
	return take_damage(factor*amount,fromlava)
	

func _process(_delta):
	if init == false: init = true
	else:
		$Collide.queue_free()
		set_process(false)
