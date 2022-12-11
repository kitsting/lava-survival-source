extends Area2D

# Declare member variables here. Examples:
export var id = 0
export var value = 10

var cycle = 0

var pointvalue = 0
var onscreen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = (round(position.x/16)*16)
	position.y = (round(position.y/16)*16)
	set_id(id)
	$SparkleTimer.start(rand_range(1,3))


func set_id(newid):
	if newid == 2:
		$SpriteCranberry.texture = load("res://sprites/smallblock/MiniBlockWood.png")
		pointvalue = 1
	if newid == 3:
		$SpriteCranberry.texture = load("res://sprites/smallblock/MiniBlockStone.png")
		pointvalue = 3
	if newid == 4:
		$SpriteCranberry.texture = load("res://sprites/smallblock/MiniBlockSteel.png")
		pointvalue = 5
	if newid == 6:
		$SpriteCranberry.texture = load("res://sprites/smallblock/MiniBlockDoor.png")
	id = newid
	
func set_value(newvalue):
	value = newvalue

func _on_Node2D_body_entered(body):
	if body.is_in_group("Player"):
		hsound.ui_play_sound(load("res://sounds/misc/blockpickup.wav"))
		body.get_blocks(id,value)
		gloSettings.stat_change(gloSettings.STAT.PICKUPSCOLLECTED,1)
		gloBlockStats.scorenum += pointvalue
		gloSettings.stat_change(gloSettings.STAT.HIGHESTSCORE,gloBlockStats.scorenum)
		die()

func _on_Pickup_area_entered(area):
	if area.is_in_group("Lava"):
		if onscreen: hsound.misc_play_sound(load("res://sounds/misc/sizzle.wav"))
		die()
	if area.is_in_group("BlockArea"):
		die()
	if area.is_in_group("Pickup"):
		die()
	if area.is_in_group("BlockMine"):
		die()
		
func die():
	#print("f")
	queue_free()


func _on_FloatTimer_timeout():
	if cycle == 0:
		position.y += 1
		cycle += 1
	elif cycle == 1:
		position.y -= 1
		cycle += 1
	elif cycle == 2:
		position.y -= 1
		cycle += 1
	elif cycle == 3:
		position.y += 1
		cycle = 0
		


func _on_VisibilityNotifier2D_screen_entered():
	onscreen = true


func _on_VisibilityNotifier2D_screen_exited():
	onscreen = false


func _on_SparkleTimer_timeout():
	$Sparkle.show()
	$SparkleTimer.stop()
	$SparkleTimer.start(rand_range(1,3))
	$Sparkle.position = Vector2((randi()%8)-4,(randi()%8)-4)
	var type = randi()%2 + 1
	$Sparkle.play("sparkle"+str(type))
	

func _on_Sparkle_animation_finished():
	$Sparkle.hide()
	$Sparkle.stop()
