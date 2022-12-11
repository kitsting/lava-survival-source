extends Panel

func _ready():
	reset_stats()
	$Cheats.visible = gloSettings.usecheats
	$ResetConfirm.hide()


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Stats_visibility_changed():
	$Cheats.visible = gloSettings.usecheats
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		#print("hidden")
		hide()

func reset_stats():
	$Margin2/Label.text = \
	str(gloSettings.stats[gloSettings.STAT.BESTROUND]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.ROUNDSURVIVED]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.TIMESOPENED]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.GAMESPLAYED]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.BLOCKSPLACED]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.PICKUPSCOLLECTED]) + "\n" + \
	str(gloSettings.stats[gloSettings.STAT.TIMESDIED]) + "\n\n" + \
	str(gloSettings.stats[gloSettings.STAT.HIGHESTSCORE])

func _on_Reset_button_up():
	$ResetConfirm.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Confirm_button_up():
	gloSettings.stat_reset()
	reset_stats()
	$ResetConfirm.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Cancel_button_up():
	$ResetConfirm.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
