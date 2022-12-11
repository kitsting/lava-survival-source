extends Control

var scrollvar = [1,0,-1]

var backoffset = 0
const scrollspeed = 24
const defaultmap = "res://rooms/Map1.tscn"

var scrollx = 0
var scrolly = 0

#var firsttimedeny = false


func _ready():
	#gloSettings.load_game()
	hsound.play_music(load("res://sounds/music/Title.ogg"))
	
	get_tree().paused = false
	get_tree().set_network_peer(null)
	
	$Text/Version.text = gloConst.version
	$FirstTime.hide()
	
	gloBlockStats.players = 1
	gloBlockStats.map = 0
	#gloNetwork.ingame = false

	while scrollx == 0 and scrolly == 0:
		scrollx = scrollspeed*gloSettings.choose(scrollvar)
		scrolly = scrollspeed*gloSettings.choose(scrollvar)

func _process(delta):
	$Score.text = "Highscore: " + str(gloSettings.stats[gloSettings.STAT.HIGHESTSCORE])
	if backoffset < 16:
		$Background.offset.x -= scrollx*delta
		$Background.offset.y -= scrolly*delta
		backoffset += scrollspeed*delta
		#print(backoffset)
	if backoffset >= 16:
		$Background.offset.x += 16*sign(scrollx)
		$Background.offset.y += 16*sign(scrolly)
		backoffset = 0
		
 
func _on_Quit_button_up():
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	get_tree().quit()


func _on_Start_button_up():
	if gloSettings.firsttime:
		$FirstTime.show()
	else:
		$StageSelect.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Settings_button_up():
	$Settings.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Multiplayer_button_up():
	$Multiplayer.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Stats_button_up():
	$Achievements.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Leaderboard_button_up():
	$Leaderboard.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _exit_tree():
	hsound.stop_sound(2)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		if gloSettings.pauseonlostfocus:
			get_tree().paused = true
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		if gloSettings.pauseonlostfocus:
			get_tree().paused = false



func _on_Deny_button_up():
	#firsttimedeny = true
	$Tween.interpolate_property($FirstTime,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	$StageSelect.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Confirm_button_up():
	#firsttimedeny = false
	$Tween.interpolate_property($FirstTime,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	$Controls.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Tween_tween_all_completed():
	if $FirstTime.modulate.a == 0:
		$FirstTime.hide()
		gloSettings.firsttime = false
		gloSettings.save_game()
