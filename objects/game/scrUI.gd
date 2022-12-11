"""
Debug UI and fullscreen menus
"""
extends CanvasLayer

onready var p1hp : Node = $Margin/VBox1/P1HPLabel
onready var debugui : Node = $Margin/VBox1

var uihidden = true


func _ready():
	get_tree().paused = false
	$DeathMenu.hide()
	$PauseMenu.hide()
	if uihidden:
		debugui.hide()
		
	$PauseMenu/LineEdit.visible = gloSettings.usecheats
	

func _process(_delta):
	$Margin/VBox1/FPSLabel.text = "FPS:%s Debug:%s"%[Engine.get_frames_per_second(),gloSettings.usedebug]
	
	if Input.is_action_just_pressed("tab"): #Show/Hide debug ui when tab is pressed
		if uihidden:
			debugui.show()
		if !uihidden:
			debugui.hide()
		uihidden = !uihidden

func _on_BlockHandler_blockidchange(blockid,blocknumber,blocklimits): #Update the block id and the number of blocks
	$Margin/VBox1/BlockIDLabel.text = "BP:%s ID:%s B#:%s"%[blocknumber,blockid,blocklimits[blockid]]

func _on_Player_health(p1health,p1lives): #Update player health and player lives
	if p1hp != null:
		p1hp.text = "HP:%s L:%s"%[p1health,p1lives]
		if p1health < 50 or p1lives <= 1:
			p1hp.set("custom_colors/font_color", Color(1,0,0))
		else:
			p1hp.set("custom_colors/font_color", Color(1, 1, 1))

func _on_LavaHandler_lavanumberchange(lnumber): #Update lava number
	$Margin/VBox1/LavaNumberLabel.text = "L#:%s"%lnumber

func _on_GameHandler_roundtimechange(rtime,rnum): #Update round timer and round number
	$Margin/VBox1/RoundTimeLabel.text = "R%s %s"%[rnum,stepify(rtime,0.1)]

func _on_GameHandler_lavastatchange(speed,intensity,decay): #Update the lava stats display
	$Margin/VBox1/LavaStatLabel.text = "S:%s I:%s D:%s"%[speed,intensity,decay]
	
func _on_Player_whatischange(what,coords=Vector2(0,0)):
#MISC = 1
#BLOCK = 2
#LAVA = 3
#BLOCKHAZARD = 4
#LAVAHAZARD = 5
#COLLISION = 6
#SPAWNER = 7
#FULL = 8
#DUMMY1 = 9
#DUMMY2 = 10
	var whattext = what
	match what:
		1:
			whattext = "Misc"
		2:
			whattext = "Block"
		3:
			whattext = "Lava"
		5:
			whattext = "Residue"
		7:
			whattext = "Spawner"
	
	$Margin/VBox1/WhatIsLabel.text = "T:%s at %s"%[whattext,coords]


func _on_Retry_button_up():
	#gloBlockStats.p1dead = false
	$DeathMenu.hide()
	gloBlockStats.reset_stats()
	#get_tree().reload_current_scene()
	Transition.reload_scene()
	gloSettings.post_new_score()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Title_button_up():
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	#gloBlockStats.p1dead = false
	#get_tree().paused = false
	$DeathMenu.hide()
	gloBlockStats.reset_stats()
	#get_tree().change_scene("res://objects/menus/Title.tscn")
	Transition.set_scene("res://objects/menus/Title.tscn")
	#get_tree().call_group("Player","queue_free")
	gloSettings.post_new_score()


func _on_DeathMenu_visibility_changed():
	$DeathMenu/Content/Text1/Score.text = "Score: %s\nYou made it to round %s"%[gloBlockStats.scorenum,gloBlockStats.roundnum]
	gloSettings.post_new_score()


func pause_game():
	if get_parent().name == "GameHandler":
		get_parent().pause_game()

func _on_LineEdit_text_entered(new_text):
	new_text = new_text.to_lower()
	if new_text == "cmdusedebug":
		gloSettings.usedebug = !gloSettings.usedebug
		gloBlockStats.reset_stats()
		get_tree().reload_current_scene()
	elif new_text == "cmddisablelava":
		gloSettings.uselava = !gloSettings.uselava
	elif new_text == "cmdenablefreecam":
		gloSettings.usecam = !gloSettings.usecam
	elif new_text == "cmdstartround":
		get_tree().get_root().get_node("GameHandler")._on_RoundTimer_timeout()
	elif "setroundnum " in new_text:
		gloBlockStats.roundnum = int(new_text.trim_prefix("setroundnum "))
	elif "setscorenum " in new_text:
		gloBlockStats.scorenum = int(new_text.trim_prefix("setscorenum "))
	elif new_text == "cmdgameover":
		get_tree().get_root().get_node("GameHandler").pause_game()
		get_tree().get_root().get_node("GameHandler/Players/Player").instadie("Killed via commands",1)
	elif "settimescale" in new_text:
		if int(new_text.trim_prefix("setscorenum ")) <= 10:
			Engine.time_scale = int(new_text.trim_prefix("setscorenum "))
	elif "setintensity " in new_text:
		gloBlockStats.lavaintensity = int(new_text.trim_prefix("setintensity "))

	$PauseMenu/LineEdit.clear()
	pause_game()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	
func _input(event):
	if event.is_pressed() and gloSettings.usecheats:
		$PauseMenu/LineEdit.grab_focus()
#
#	if Input.is_action_just_pressed("ui_up"):
#		if !$PauseMenu/LineEdit.focused:
		
		


func _on_Resume_button_up():
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	pause_game()


func _on_Settings_button_up():
	$PauseMenu/Settings.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_PauseMenu_visibility_changed():
	$PauseMenu/Settings.hide()

func set_death_reason(reason=""):
	$DeathMenu/Content/Reason.text = reason
