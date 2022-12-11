extends Node2D

var madelava = false
#var playerdmg = null
onready var handler : Node = get_parent().get_node("BlockHandler")
var decay = (gloBlockStats.lavadecay+round(rand_range(-12,12)))/60 #200
var decaytime = 0.5

var beachsprite = preload("res://sprites/block/lavamap2anim.png")
var wastesprite = preload("res://sprites/block/lavamap3anim.png")
var slimesprite = preload("res://sprites/block/slimeanim.png")

var begonef = false

func _ready():
	if !gloSettings.uselava or gloSettings.lavaprevention: queue_free()
	
	$DecayTimer.set_wait_time(decay)
	$DecayTimer.start()
	
	$SpreadTimer.set_wait_time((gloBlockStats.lavaspeed+round(rand_range(-12,12)))/60)
	$SpreadTimer.start()
	
	if gloBlockStats.map == 2:
		$Sprite.texture = beachsprite
	elif gloBlockStats.map == 3:
		$Sprite.texture = wastesprite
		
	if !gloBlockStats.roundnum%5:
		$Sprite.texture = slimesprite
	
	$Anim.play("Build",-1,4)
	
	if gloBlockStats.lavadecay > 215:
		decaytime = 0.4
	if gloBlockStats.lavadecay > 230:
		decaytime = 0.45
	if gloBlockStats.lavadecay > 245:
		decaytime = 0.5

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("BlockMine"):
		body.mark_for_death(round(gloBlockStats.lavaintensity))


func _on_DecayTimer_timeout():
	begone()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player") or body.is_in_group("BlockMine"):
		if body.markfordeath:
			body.mark_for_death(0)


func _on_SpreadTimer_timeout():
	if !madelava and $DecayTimer.get_time_left() > decay*decaytime:
		madelava = handler.spread_lava(position.x,position.y,gloBlockStats.lavadirection)
		
func begone():
	handler.remove_from_grid(position.x/16,position.y/16)
	handler.spawn_vacate(position.x,position.y)
	self.queue_free()
