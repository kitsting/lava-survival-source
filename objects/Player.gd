extends KinematicBody2D

var blushsprite = load("res://sprites/player/blush.png")
var nervoussprite = load("res://sprites/player/nervous.png")

var whatis = 0

enum EMOTION {
	NONE,
	BLUSH,
	NERVOUS
}
var currentemo = EMOTION.NONE

var squishvert = true
var squishvertdown = true
var squishhoriz = true
var squishhorizright = true

signal health
signal placing
signal breaking
signal blockchange
signal whatischange

const playerblocklimit = 24; const playerblocklimitmax = 96

var speed = 112; var acceleration = speed; var motion = Vector2.ZERO
var screen_size
var health = 250 setget set_health
var lives = 3
var maxlives = lives
var timesdied = 0
var markfordeath = 0
var invincibilitytimer = 0
var init = true
var frozen = false

var blushtimer = 120
var blushtimermax = blushtimer

var blockline = 0; var blocklinex = 0; var blockliney = 0
var blocklinedel = Color(0,0,0)

var mousedist; var blockdist

var mouseplacex; var mouseplacey
var blockid2 = 0
var blockid = gloBlockStats.blocksallowed[blockid2]
var blocklimits = gloBlockStats.blocklimit

var canplaceplayerpos; var toofarplayerpos; var canplace

var selfcolor = gloSettings.pinfo.color

var respawning = false

var drawlimit = true

onready var root = get_tree().get_root()

var rain = preload("res://objects/environment/Rain.tscn")


func _ready(): #Variable setup
	
	if Input.is_action_pressed("shift") and gloSettings.usecheats:
		lives = 5
		health = 2000000

	screen_size = get_viewport_rect().size
	position = gloBlockStats.player1pos

	$Main/Pupil.modulate = gloSettings.pinfo.color
	$Main/Cosmetic.texture = load("res://sprites/player/cosmetic/"+str(gloSettings.pinfo.cosmetic)+".png")
	
	if gloSettings.pinfo.cosmetic == "1colorful":
		$Main/Cosmetic.self_modulate = gloSettings.pinfo.color


func get_input_axis(): #Get up/down and left/right and normalize the result
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
	
	
func apply_friction(_amount): #Reset friction to 0, argument is unused as for now
	motion = Vector2.ZERO
	
	
func apply_movement(amount): #Apply movement if inputs are pressed
	motion += amount
	if motion.length() > speed: motion = motion.normalized() * speed
	var axis = get_input_axis()
	if axis.y == 0: motion.y = 0
	if axis.x == 0: motion.x = 0
		
		
func _physics_process(delta):		
	var axis = get_input_axis()
	if axis == Vector2.ZERO: apply_friction(acceleration * delta)
	else: apply_movement(axis * acceleration)
	motion = move_and_slide(motion)
	
	if gloBlockStats.map == 0:
		position.x = clamp(position.x, 0+$Collision.shape.extents.x, screen_size.x-$Collision.shape.extents.x)
		position.y = clamp(position.y, 0+$Collision.shape.extents.y, screen_size.y-$Collision.shape.extents.y)
	else:
		position.x = clamp(position.x, 0+$Collision.shape.extents.x, (gloBlockStats.mapsize[gloBlockStats.map].x*16)-16-$Collision.shape.extents.x)
		position.y = clamp(position.y, 0+$Collision.shape.extents.y, (gloBlockStats.mapsize[gloBlockStats.map].y*16)-16-$Collision.shape.extents.y)

	var dir = get_input_axis()
	
	#Change sprite based on movement direction, and play the squishing animation
	if dir.y == 1 and dir.x == 0:
		$Main/Dir.animation = "newdown"
		squishvert = true
		if squishvertdown and is_on_wall():
			$Anim.play("SquishDown",-1,10)
			squishvertdown = false
	elif dir.y == -1 and dir.x == 0:
		squishvertdown = true
		if squishvert and is_on_wall():
			$Anim.play("SquishUp",-1,10)
			squishvert = false

	elif dir.x == 1 and dir.y == 0: 
		$Main/Dir.animation = "newright"
		$Main/Dir.flip_h = false
		squishhoriz = true
		if squishhorizright and is_on_wall():
			$Anim.play("SquishRight",-1,10)
			squishhorizright = false
	elif dir.x == -1 and dir.y == 0:
		$Main/Dir.animation = "newright"
		$Main/Dir.flip_h = true
		squishhorizright = true
		if squishhoriz and is_on_wall():
			$Anim.play("SquishLeft",-1,10)
			squishhoriz = false
	
	elif dir.y > 0 and dir.x > 0:
		$Main/Dir.animation = "newdownright"
		$Main/Dir.flip_h = false
		squishvert = true
		squishhoriz = true
		if squishvertdown and squishhorizright and is_on_wall():
			$Anim.play("SquishCorner2",-1,10) #2
			squishvertdown = false
			squishhorizright = false		
	elif dir.y > 0 and dir.x < 0:
		$Main/Dir.animation = "newdownright"
		$Main/Dir.flip_h = true
		squishvert = true
		squishhorizright = true
		if squishvertdown and squishhoriz and is_on_wall():
			$Anim.play("SquishCorner4",-1,10) #4
			squishvertdown = false
			squishhoriz = false
	
	elif dir.y < 0 and dir.x > 0:
		$Main/Dir.animation = "newupright"
		$Main/Dir.flip_h = false
		squishvertdown = true
		squishhoriz = true
		if squishvert and squishhorizright and is_on_wall():
			$Anim.play("SquishCorner1",-1,10) #1
			squishvert = false
			squishhorizright = false
	elif dir.y < 0 and dir.x < 0:
		$Main/Dir.animation = "newupright"
		$Main/Dir.flip_h = true	
		squishvertdown = true
		squishhorizright = true
		if squishvert and squishhoriz and is_on_wall():
			$Anim.play("SquishCorner3",-1,10) #3
			squishvert = false
			squishhoriz = false
			
	else:
		$Main/Dir.animation = "none"
		
	#print(rad2deg(position.angle_to(get_global_mouse_position())))
	var lookangle = rad2deg(get_angle_to(get_global_mouse_position()))
	mousedist = position - get_global_mouse_position()
	blockdist = Vector2((round((mousedist.x)/16)*16),(round((mousedist.y)/16)*16))
	#print(mousedist)
	
	#Change pupil position based on mouse position (relative to player)
	if (mousedist.x < 5 and mousedist.y < 5) and (mousedist.x > -5 and mousedist.y > -5): $Main/Pupil.position = Vector2(0,0) #Center
	elif lookangle < -10 and lookangle > -80: $Main/Pupil.position = Vector2(1,-1) #Down Left
	elif lookangle > -170 and lookangle < -100: $Main/Pupil.position = Vector2(-1,-1) #Up Left
	elif lookangle < 170 and lookangle > 100: $Main/Pupil.position = Vector2(-1,1) #Up Right
	elif lookangle > 10 and lookangle < 80: $Main/Pupil.position = Vector2(1,1) #Down Right
	elif lookangle > -10 and lookangle < 10: $Main/Pupil.position = Vector2(1,0) #Right
	elif (lookangle < 180 and lookangle > 170) or (lookangle > -180 and lookangle < -170): $Main/Pupil.position = Vector2(-1,0) #Left
	elif lookangle < -80 and lookangle > -100: $Main/Pupil.position = Vector2(0,-1) #Up
	elif lookangle > 80 and lookangle < 100: $Main/Pupil.position = Vector2(0,1) #Down
		
	#Change emotion based on current condition
	if (gloBlockStats.roundleft <= 5 and gloBlockStats.roundleft > 0): currentemo = EMOTION.NERVOUS
	else: currentemo = EMOTION.NONE
		
	if (dir.y == 0 and dir.x == 0):
		if (mousedist.x < 10 and mousedist.y < 10) and (mousedist.x > -10 and mousedist.y > -10):
			if blushtimer: blushtimer -= 1
			#if !blushtimer:
				#currentemo = EMOTION.BLUSH
	else:
		if currentemo != EMOTION.NERVOUS: currentemo = EMOTION.NONE
		blushtimer = blushtimermax
		#$Blush.hide()
	if !blushtimer: currentemo = EMOTION.BLUSH
	
	#Update sprite based on emotion	
	if currentemo == EMOTION.NONE: $Main/Blush.hide()
	if currentemo == EMOTION.BLUSH:
		$Main/Blush.texture = blushsprite
		$Main/Blush.show()
	if currentemo == EMOTION.NERVOUS:
		$Main/Blush.texture = nervoussprite
		$Main/Blush.show()
				

func _process(_delta): #Connect Signals, check for input, update pos vars, etc
	if gloBlockStats.roundnum == 10:
		if lives == maxlives and health == 250:
			gloSettings.stat_change(gloSettings.STAT.SPECIAL1,999,false)
	if frozen:
		set_physics_process(false)
	else:
		set_physics_process(true)
	
	update()

	if init:
		init = false
		if root.has_node("GameHandler/HUD"):
			connect("health",root.get_node("GameHandler/HUD"),"_on_Player_health")
			connect("blockchange",root.get_node("GameHandler/HUD"),"_on_Player_blockchange")
		if root.has_node("GameHandler/UI"):
			connect("health",root.get_node("GameHandler/UI"),"_on_Player_health")
			connect("whatischange",root.get_node("GameHandler/UI"),"_on_Player_whatischange")
		if root.has_node("GameHandler/YSort/BlockHandler"):
			connect("breaking",root.get_node("GameHandler/YSort/BlockHandler"),"delete_block")
			connect("placing",root.get_node("GameHandler/YSort/BlockHandler"),"place_block")
		emit_signal("blockchange",blockid,blocklimits)
		emit_signal("health",health,lives)	
		
	if markfordeath and !invincibilitytimer and !respawning:
		$Main/Marked.visible = true
		$UnderLava.start(0.2)
		speed = 50
		take_damage(markfordeath)
		hsound.ui_play_sound(load("res://sounds/misc/damage.wav"))
		if !$Anim.is_playing(): $Anim.play("Blink")
	if !markfordeath:
		speed = 100
		if !$Anim.is_playing(): $Anim.stop(true)
			
	if respawning: if !$Anim.is_playing(): $Anim.play("Flash",-1,0.8)
	if !respawning: if !$Anim.is_playing(): $Anim.stop(true)
			
	if gloBlockStats.controls == 0:
		mouseplacex = round(get_global_mouse_position().x/16)
		mouseplacey = round(get_global_mouse_position().y/16)
	
	canplaceplayerpos = (abs(position.x - mouseplacex*16) <= playerblocklimit and abs(position.y - mouseplacey*16) <= playerblocklimit)
	toofarplayerpos = (abs(position.x - mouseplacex*16) <= playerblocklimitmax and abs(position.y - mouseplacey*16) <= playerblocklimitmax)
	canplace = int(!canplaceplayerpos) * int(toofarplayerpos)
		
	if root.has_node("GameHandler/Cursor"):
		var cursor1 = root.get_node("GameHandler/Cursor")
		cursor1.pos_set(mouseplacex*16,mouseplacey*16)
		whatis = get_cell_type(mouseplacex,mouseplacey)
		emit_signal("whatischange",whatis,Vector2(mouseplacex,mouseplacey))
		if (get_cell_type(mouseplacex,mouseplacey) != null and get_cell_type(mouseplacex,mouseplacey) != 5) or !canplace or respawning:
			cursor1.col_set(gloConst.uiredcolor)
			cursor1.pre_clear()
			cursor1.sprite_set("cursornoplace")
		elif blocklimits[blockid] == 0:
			cursor1.col_set(gloConst.uipurplecolor)
			cursor1.pre_set(blockid)
			cursor1.sprite_set("cursorout")
		elif blockid == 6 and ((get_cell_type(mouseplacex-1,mouseplacey) != 2 or get_cell_type(mouseplacex+1,mouseplacey) != 2) and (get_cell_type(mouseplacex,mouseplacey-1) != 2 or get_cell_type(mouseplacex,mouseplacey+1) != 2)):
			cursor1.col_set(gloConst.uiredcolor)
			cursor1.pre_set(blockid)
			cursor1.sprite_set("cursordoor")
		else:
			cursor1.col_set(gloConst.uibluecolor)
			cursor1.pre_set(blockid)
			cursor1.sprite_set("cursorwhite")
			
	if blockline:
		update()
		blockline -= 1
			
	if Input.is_action_just_pressed("place_block") and !respawning:
		if mouseplacex*16 < 0: return 0
		if !canplace: return 0
		emit_signal("placing",mouseplacex,mouseplacey,blockid,self.blocklimits,true)
		emit_signal("blockchange",blockid,blocklimits)
		blockline = 7
		blocklinex = mouseplacex*16
		blockliney = mouseplacey*16
		blocklinedel = gloConst.uibluecolor
	
	if Input.is_action_just_pressed("right_click") and !respawning:
		if !toofarplayerpos: return 0
		emit_signal("breaking",mouseplacex,mouseplacey,self)
		emit_signal("blockchange",blockid,blocklimits)
		blockline = 7
		blocklinex = mouseplacex*16
		blockliney = mouseplacey*16
		blocklinedel = gloConst.uiredcolor
			
	gloBlockStats.p1respawntime = $Respawn.time_left

		
func _draw(): #Draw a rectangle showing how close is too close for block placement, and lines between player and altered blocks
	if drawlimit and !frozen:
		var close = playerblocklimit
		var far = playerblocklimitmax	
		if canplaceplayerpos:
			draw_rect(Rect2(0-close,0-close,0+2*close,0+2*close),Color(selfcolor.r,selfcolor.g,selfcolor.b,0.1))
			draw_rect(Rect2(0-close,0-close,0+2*close,0+2*close),Color(selfcolor.r,selfcolor.g,selfcolor.b,0.7),false)
		
		if !toofarplayerpos:	
			draw_rect(Rect2(0-far,0-far,0+2*far,0+2*far),Color(selfcolor.r,selfcolor.g,selfcolor.b,0.05))
			draw_rect(Rect2(0-far,0-far,0+2*far,0+2*far),Color(selfcolor.r,selfcolor.g,selfcolor.b,0.5),false)
	
	if blockline and !frozen: draw_line($Main/Pupil.position,-blockdist,Color(blocklinedel.r,blocklinedel.g,blocklinedel.b,0.75),1.5)
	
	
func take_damage(amount): #Take the specified amount of damage
	if !respawning:
		health -= amount
		if health <= 0: die()
#		else:
#			hsound.ui_play_sound(load("res://sounds/misc/damage.wav"))
	emit_signal("health",health,lives)
		
		
func mark_for_death(amount): #Change the variable which makes the player take the specified amount of damage every frame
	markfordeath = amount
	
	
func die(): #Lose a life, reset health
	if timesdied < maxlives:
		timesdied += 1
		gloSettings.stat_change(gloSettings.STAT.TIMESDIED,1)
	hsound.misc_play_sound(load("res://sounds/misc/Explosion2.ogg"))
	$PlayerCam.shake(0.5,20,15)
	lives -= 1
	$Main/Burn.visible = true
	gloBlockStats.reset_blocks()
	blocklimits = gloBlockStats.blocklimit
	emit_signal("blockchange",blockid,blocklimits)
	if lives <= 0:
		if root.has_node("GameHandler"):
			root.get_node("GameHandler").game_over("Out of lives",1)
		return 0
	respawning = true
	$Respawn.set_wait_time(min(8,gloBlockStats.roundleft))
	$Respawn.start()
	invincibilitytimer = 0
	$Tween.interpolate_property(self,"health",0,250,$Respawn.time_left,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()
	emit_signal("health",health,lives)
	
	
func _input(event): #Get input to change block id
	if event.is_action_pressed("scroll_up"):
		blockid2 -= 1
		if blockid2 < 0: blockid2 = len(gloBlockStats.blocksallowed)-1
		blockid = gloBlockStats.blocksallowed[blockid2]
		emit_signal("blockchange",blockid,blocklimits)
			
	if event.is_action_pressed("scroll_down"):
		blockid2 += 1
		if blockid2 > len(gloBlockStats.blocksallowed)-1: blockid2 = 0
		blockid = gloBlockStats.blocksallowed[blockid2]
		emit_signal("blockchange",blockid,blocklimits)
		
	if Input.is_key_pressed(KEY_F3):
		drawlimit = !drawlimit
		update()
				
			
func is_cell_empty(x=0,y=0):
	if root.has_node("GameHandler/YSort/BlockHandler"):
		return root.get_node("GameHandler/YSort/BlockHandler").is_cell_empty(x,y)	
	else: return false
	
		
func get_cell_type(x=0,y=0):
	if root.has_node("GameHandler/YSort/BlockHandler"):
		return root.get_node("GameHandler/YSort/BlockHandler").get_cell_type(x,y)	
	else: return 0


func _on_Respawn_timeout():
	respawning = false
	$Main/Burn.visible = false
	
	
func get_blocks(id,number):
	blocklimits[id]+=number
	if blocklimits[id] > gloBlockStats.blocks[id].toplimit: blocklimits[id] = gloBlockStats.blocks[id].toplimit
	emit_signal("blockchange",blockid,blocklimits)
	
	
func instadie(reason="Too bad you fool",anim=null,pan=Vector2(0,0)):
	if anim==9:
		$PlayerCam.smoothing_speed = 50
		$PlayerCam.position = Vector2(pan.x-position.x,pan.y-position.y)
		print("panning camera to "+str(pan))
	if root.has_node("GameHandler"):
		root.get_node("GameHandler").game_over(reason,anim)


func set_health(newhealth):
	health = newhealth
	emit_signal("health",health,lives)


func _on_UnderLava_timeout():
	$Main/Marked.visible = false
