extends Panel

var apanel = preload("res://objects/title/SubMenus/AchievementPanel.tscn")

func _ready():
	$CheevoInfo.hide()
	
	var ii = 0
	
	for cheevo in gloSettings.achievements:
		var panel = apanel.instance()
		
		panel.set_name(cheevo.aname)
		panel.set_desc(cheevo.desc)
		panel.set_icon(cheevo.icon)
		panel.set_unlocked(gloSettings.aunlocks[ii])
		panel.set_id(ii)
		
		panel.set_obfuscate(cheevo.obfuscated,cheevo.hidden)

		panel.connect("unhovered",self,"reset_text")
		panel.connect("hovered",self,"set_text")
		panel.connect("clicked",self,"show_info")
		
		$Margin/Grid.add_child(panel)
		ii += 1


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	

func _on_Controls_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()


func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		#print("hidden")
		hide()


func set_text(new_text):
	$Name.text = new_text
	$NameReset.stop()
	

func reset_text():
	$NameReset.start(0.45)


func _on_NameReset_timeout():
	$Name.text = "Hover over an achievement to see it's name"
	
	
	
func show_info(aname="Achievement Name",desc="Achievement Description",icon="res://f",iconcolor=Color(0,0,0),unlocked=false,cheevoid=0):
	$CheevoInfo.show()
	$CheevoInfo/Panel/Label.text = aname
	$CheevoInfo/Panel/Label2.text = desc
	$CheevoInfo/Panel/TextureRect.texture = icon
	$CheevoInfo/Panel/TextureRect.self_modulate = iconcolor
	
	$CheevoInfo/Panel/Progress.max_value = gloSettings.achievements[cheevoid].statreq
	$CheevoInfo/Panel/Progress.value = gloSettings.stats[gloSettings.achievements[cheevoid].statnum]
	
	if !unlocked:
		$CheevoInfo/Panel/Progress.modulate = Color(0.980469, 0.436615, 0)
	else:
		$CheevoInfo/Panel/Progress.modulate = Color(0.095215, 0.761719, 0)
		$CheevoInfo/Panel/Progress.value = $CheevoInfo/Panel/Progress.max_value
		
		
	$CheevoInfo/Panel/Reward.text = "Reward: "+str(gloSettings.achievements[cheevoid].rewardtype).capitalize()
		


func _on_InfoClose_pressed():
	$CheevoInfo.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Stats_button_up():
	$Stats.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
