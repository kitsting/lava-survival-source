extends Node2D

signal roundtimechange
signal lavastatchange
signal roundstarted

var lastspeed = 0
var lastdecay = 0
var lastintense = 0


var roundnumber = 0

var pickups = 4
var pickupinstance = preload("res://objects/blocks/Pickup.tscn")
var maskinstance = preload("res://objects/misc/Mask.tscn")
var mineinstance = preload("res://objects/blocks/Mine.tscn")

onready var ui : Node = get_node("UI").get_node("PauseMenu")
onready var respawnmenu : Node = get_node("UI").get_node("DeathMenu")
onready var bhandler : Node = $YSort/BlockHandler

var pausestate = false
var respawn = false
var respawnstate = false

var preptime = true
var dir = 0
var carddir = 8
var p1dead = false

onready var playerscene = preload("res://objects/Player.tscn")


func _ready():
	gloBlockStats.roundnum = 0
	gloBlockStats.scorenum = 0
	gloSettings.lavaprevention = false
		
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	
	if has_node("CollisionMap"):
		get_node("CollisionMap").set_tile_origin(TileMap.TILE_ORIGIN_CENTER)
		var tiles = get_node("CollisionMap").get_used_cells()
		for tile in tiles:
			get_node("YSort/BlockHandler").add_to_grid(tile.x+1,tile.y+1)
			
	gloSettings.stat_change(gloSettings.STAT.GAMESPLAYED,1)
	
	start_round()
	#roundnuminc()
	
	gloBlockStats.preptime = preptime
	
	$YSort/BlockHandler.connect("make_map_object",self,"make_object")

	
func _process(_delta):
	if Input.is_action_just_pressed("ui_end"):
		pause_game()
		
	if Input.is_action_just_pressed("startround"):
		if preptime:
			_on_RoundTimer_timeout()
		
	emit_signal("roundtimechange",$RoundTimer.get_time_left(),roundnumber)
	
#	if gloBlockStats.p1dead and !respawnstate: 
#		respawn_screen()
	
	gloBlockStats.roundleft = $RoundTimer.time_left

	if gloBlockStats.roundleft <= 20 and get_node("YSort/BlockHandler").lavanumber <= 0 and !preptime:
		if $RoundTimer.time_left > 0.1:
			$RoundTimer.set_wait_time($RoundTimer.time_left - 0.1)
			$RoundTimer.start()
		

func _input(_event): #Reset game if f5 is pressed
	if Input.is_action_just_pressed("F5"):
		gloBlockStats.reset_stats()
		get_tree().reload_current_scene()
		
	if Input.is_key_pressed(KEY_F4) and gloSettings.usedebug:
		_on_RoundTimer_timeout()

		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		if gloSettings.pauseonlostfocus:
			pause_game()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		gloSettings.post_new_score()


func pause_game(): #Show paused ui and pause existing objects
	if !respawn and !p1dead:
		get_tree().paused = !get_tree().paused
		pausestate = !pausestate
		if pausestate: ui.show()
		if !pausestate: ui.hide()
		
		
func start_round():
	if !preptime:
		gloSettings.lavaprevention = false
		$RoundTimer.set_wait_time(((gloBlockStats.lavadecay/60)-gloBlockStats.lavaspeed/60)+24)
	if preptime and roundnumber > 0: 
		gloSettings.lavaprevention = true
		$RoundTimer.set_wait_time(max(5,(15-roundnumber/6)))
	$RoundTimer.start()
	
	if preptime:
		dir = randi()%4
		gloBlockStats.set_dir(dir)
		
		carddir = randi()%4 + 8
		gloBlockStats.set_dir(carddir,true)
		
		if roundnumber:
			gloBlockStats.scorenum += 10+roundnumber
			gloSettings.stat_change(gloSettings.STAT.HIGHESTSCORE,gloBlockStats.scorenum)
	
	if roundnumber > 0 and !preptime:
		if dir == 0: #Top left
			bhandler.make_lava(gloBlockStats.lavatlpos.x,gloBlockStats.lavatlpos.y)
		if dir == 1: #Top right
			bhandler.make_lava(gloBlockStats.lavatrpos.x,gloBlockStats.lavatrpos.y)
		if dir == 2: #Bottom right
			bhandler.make_lava(gloBlockStats.lavabrpos.x,gloBlockStats.lavabrpos.y)
		if dir == 3: #Bottom left
			bhandler.make_lava(gloBlockStats.lavablpos.x,gloBlockStats.lavablpos.y)
			
		if gloBlockStats.map == 3:
			if carddir == 8:
				bhandler.make_lava(gloBlockStats.lavatoppos.x,gloBlockStats.lavatoppos.y)
			if carddir == 9:
				bhandler.make_lava(gloBlockStats.lavabottompos.x,gloBlockStats.lavabottompos.y)
			if carddir == 10:
				bhandler.make_lava(gloBlockStats.lavaleftpos.x,gloBlockStats.lavaleftpos.y)
			if carddir == 11:
				bhandler.make_lava(gloBlockStats.lavarightpos.x,gloBlockStats.lavarightpos.y)
			
	if roundnumber > 1 and !preptime:
		lastdecay += 1
		lastintense += 1
		lastspeed += 1
		var lavastat = randi()%3
		if lastintense > 3:
			lavastat = 1
		elif lastspeed > 3:
			lavastat = 0
		elif lastdecay > 3:
			lavastat = 2
		if lavastat == 0 and gloBlockStats.lavaspeed >= 12: #Speed
			gloBlockStats.lavaspeed -= (randi()%2)+1
			if has_node("HUD"):
				get_node("HUD").stat_popup("Lava Speed Up")
			lastspeed = 0
		elif lavastat == 1 and gloBlockStats.lavaintensity <= 11: #Intensity
			gloBlockStats.lavaintensity += (randi()%2)+1
			if has_node("HUD"):
				get_node("HUD").stat_popup("Lava Strength Up")
			lastintense = 0
		elif lavastat == 2 and gloBlockStats.lavadecay <= 350: #Decay
			gloBlockStats.lavadecay += (randi()%7)+9
			if has_node("HUD"):
				get_node("HUD").stat_popup("Lava Decay Up")
			lastdecay = 0
	emit_signal("lavastatchange",gloBlockStats.lavaspeed,gloBlockStats.lavaintensity,gloBlockStats.lavadecay)

	if preptime:
		get_node("YSort/BlockHandler").lavanumber = 0
		if pickups:
			var hassteel = false
			for item in gloBlockStats.blocksallowed:
				if item == 4:
					hassteel = true
			while pickups:
				var tempx = (randi()%int(gloBlockStats.mapsize[gloBlockStats.map].x))*16
				var tempy = (randi()%int(gloBlockStats.mapsize[gloBlockStats.map].y))*16
				var randchance = randi()%10000 + 1
				var type = 2
				if randchance <= 5000:
					type = 2
				if randchance > 5000 and randchance <= 8000:
					type = 3
				if randchance > 8000 and randchance <= 9999:
					if hassteel: type = 4
					else: type = 3
				if randchance == 10000:
					type = 50
				if get_node("YSort/BlockHandler").is_cell_empty(round(tempx/16),round(tempy/16)):
					if type != 50:
						var newpickup = pickupinstance.instance()
						newpickup.set_id(type)
						newpickup.set_value(min(((randi()%6)+round(roundnumber/4)+1),14))
						newpickup.position.x = tempx
						newpickup.position.y = tempy
						$YSort.add_child(newpickup)
					else:
						var newmask = maskinstance.instance()
						newmask.position.x = tempx
						newmask.position.y = tempy
						$YSort.add_child(newmask)
					pickups -= 1
		pickups = 4
		
	if !preptime:
		if roundnumber%10:
			hsound.misc_play_sound(load("res://sounds/misc/round/roundstart.wav"))
		else:
			hsound.misc_play_sound(load("res://sounds/misc/round/roundstartbig.wav"))


func _on_RoundTimer_timeout(): #Start a new round and increase the round number
	preptime = !preptime
	gloBlockStats.preptime = preptime
	if gloSettings.uselava and !preptime:
		roundnuminc()
	start_round()
	
	
func roundnuminc(): #Increase the round number
	emit_signal("roundstarted")
	roundnumber+=1
	gloBlockStats.roundnum = roundnumber
	gloSettings.stat_change(gloSettings.STAT.ROUNDSURVIVED,1)
	gloSettings.stat_change(gloSettings.STAT.BESTROUND,roundnumber,false)
	gloSettings.save_game()
		
	if roundnumber == 8 and !gloSettings.usedebug:
		gloBlockStats.new_allowed([2,3,4,6])
	
	
func respawn_screen():
	respawnstate = true
	get_tree().paused = true
	respawnmenu.show()

			
func game_over(reason="",anim=null):
	if !gloBlockStats.dying:
		hsound.stop_sound(2)
		gloBlockStats.dying = true
		p1dead = true
		if anim == 1:
			death_anim_lives()
			var t = Timer.new(); t.set_wait_time(4); t.set_one_shot(true); self.add_child(t); t.start()
			yield(t, "timeout"); t.queue_free()
		if anim == 9:
			death_anim_mines()
			var t = Timer.new(); t.set_wait_time(6); t.set_one_shot(true); self.add_child(t); t.start()
			yield(t, "timeout"); t.queue_free()
			
		if !respawnstate:
			respawn_screen()
			get_node("UI").set_death_reason(reason)
		
			
func death_anim_lives():
	gloSettings.lavaprevention = true
	for child in get_node("YSort").get_children():
		if child.is_in_group("Lava"):
			child.get_node("DecayTimer").set_wait_time(round(child.get_node("DecayTimer").time_left / 20))
			
	get_node("Players/Player").frozen = true
	get_node("Players/Player/Anim").play("die")
	$Cursor.visible = false
	$RoundTimer.paused = true
	
	
func death_anim_mines():
	gloSettings.lavaprevention = true
	for child in get_node("YSort").get_children():
		if child.is_in_group("Lava"):
			child.get_node("DecayTimer").set_wait_time(round(child.get_node("DecayTimer").time_left / 20))
	
	get_node("Players/Player").frozen = true
	
	$Cursor.visible = false
	$RoundTimer.paused = true


func _on_Map_make_mines(number):
	while number:
		var tempx = (randi()%int(gloBlockStats.mapsize[gloBlockStats.map].x))*16
		var tempy = (randi()%int(gloBlockStats.mapsize[gloBlockStats.map].y))*16
		if get_node("YSort/BlockHandler").is_cell_empty(round(tempx/16),round(tempy/16)):
			var newmine = mineinstance.instance()
			newmine.position.x = tempx
			newmine.position.y = tempy
			newmine.name = "mine"+str(number)
			$Map.add_child(newmine)
			get_node("YSort/BlockHandler").add_to_grid(round(tempx/16),round(tempy/16),9)
			number -= 1


func make_object(scene):
	if has_node("Map"):
		$Map.add_child(scene)
