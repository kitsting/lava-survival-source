extends Panel

func _ready():
	$ChangeColor.connect("closing",self,"_on_Customize_closed")
	
	if get_tree().get_current_scene().get_name() != "Title":
		$Tabs/Misc/VBox/Cheats.disabled = true
		$SidePanel/VBox2/HBox/ChangeCol.disabled = true
		$SidePanel/VBox3/LineEdit.editable = false
	
	
	$Tabs/Audio/VBoxSound/SFX/SoundSlider.value = gloSettings.soundval
	$Tabs/Audio/VBoxSound/Music/MusSlider.value = gloSettings.musval
	
	$CommandConfirm.hide()
	$ChangeColor.hide()
	
	$SidePanel/VBox3/LineEdit.text = gloSettings.pinfo.name
	
	$SidePanel/VBox2/HBox/Man/Base.change_color(gloSettings.pinfo.color)
	$SidePanel/VBox2/HBox/Man/Base.change_cosmetic(gloSettings.pinfo.cosmetic)
	$SidePanel/VBox2/HBox/Man/Base.change_badge(gloSettings.pinfo.badge)
	
	$Tabs/Accessibility/VBox/Screenshake.pressed = gloSettings.usescreenshake
	$Tabs/Video/VBox/Fullscreen.pressed = OS.window_fullscreen
	$Tabs/Video/VBox/Focus.pressed = gloSettings.pauseonlostfocus
	$Tabs/Video/VBox/Stretch.pressed = gloSettings.stretchscreen
	$Tabs/Misc/VBox/Cheats.pressed = gloSettings.usecheats
	$Tabs/Accessibility/VBox/Cursor.pressed = gloSettings.usecursortrans
	$Tabs/Video/VBox/Notifs.pressed = gloSettings.notifs
	
	if gloSettings.stretchscreen:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT,Vector2(384,216))
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP,Vector2(384,216))
	
	gloSettings.connect("fullscreenchange",self,"_on_fullscreen_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	gloSettings.save_game()
	gloSettings.post_new_score()
	#SilentWolf.Players.post_player_data(OS.get_unique_id(),gloSettings.pinfo)
	
func _on_Fullscreen_changed():
	$Tabs/Video/VBox/Fullscreen.pressed = OS.window_fullscreen
	
func _on_Fullscreen_pressed():
	gloSettings.set_fullscreen()

func _on_Screenshake_pressed():
	gloSettings.set_screenshake()
	
func _on_Focus_pressed():
	gloSettings.set_focus()
	
func _on_Feedback_button_up():
	$Feedback.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Controls_button_up():
	$Controls.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Changelog_button_up():
	$Changes.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

	#gloSettings.save_game()


func _on_Settings_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		#print("hidden")
		hide()


func _on_Stretch_pressed(state):
	if state == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT,Vector2(384,216))
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP,Vector2(384,216))
		
	gloSettings.stretchscreen = state
	gloSettings.save_game()


func _on_Cheats_pressed():
	if gloSettings.usecheats:
		gloSettings.usecheats = false
	else:
		$CommandConfirm.show()
	gloSettings.save_game()


func _on_LineEdit_text_changed(new_text):
	if new_text != "" and !gloSettings.initialpost:
		gloSettings.canpost = true
	gloSettings.pinfo.name = new_text


func _on_Deny_button_up():
	$CommandConfirm.hide()
	$Tabs/MiscVBox/Cheats.pressed = false
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Confirm_button_up():
	$CommandConfirm.hide()
	gloSettings.usecheats = true
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))



func _on_ChangeCol_button_up():
	$ChangeColor.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_SoundSlider_value_changed(value):
	gloSettings.set_vol("Sound",value)
	var percent = round((abs(value+36)/36)*100)
	var add = ""
	if percent < 100:
		add = add+"0"
	if percent < 10:
		add = add+"0"
	
	$Tabs/Audio/VBoxSound/SFX/Label2.text = add+str(percent)


func _on_MusSlider_value_changed(value):
	gloSettings.set_vol("Music",value)
	var percent = round((abs(value+36)/36)*100)
	var add = ""
	if percent < 100:
		add = add+"0"
	if percent < 10:
		add = add+"0"
		
	$Tabs/Audio/VBoxSound/Music/Label2.text = add+str(percent)


func _on_Credits_button_up():
	$Credits.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Cursor_pressed():
	gloSettings.set_cursortrans()
	
	
func _on_Customize_closed():
	$SidePanel/VBox2/HBox/Man/Base.change_color(gloSettings.pinfo.color)
	$SidePanel/VBox2/HBox/Man/Base.change_cosmetic(gloSettings.pinfo.cosmetic)
	$SidePanel/VBox2/HBox/Man/Base.change_badge(gloSettings.pinfo.badge)


func _on_Notifs_pressed():
	gloSettings.set_notifications()
	
	
func _process(_delta):
	for child in $Tabs.get_children():
		for child2 in child.get_children():
			for child3 in child2.get_children():
				if child3.has_method("is_hovered"):
					if child3.is_hovered():
						$DescPanel/Margin/Desc.text = child3.editor_description
						
	if $SidePanel/VBox2/HBox/ChangeCol.is_hovered():
		$DescPanel/Margin/Desc.text = $SidePanel/VBox2/HBox/ChangeCol.editor_description


func _on_SoundSlider_mouse_entered():
	$DescPanel/Margin/Desc.text = $Tabs/Audio/VBoxSound/SFX/SoundSlider.editor_description


func _on_MusSlider_mouse_entered():
	$DescPanel/Margin/Desc.text = $Tabs/Audio/VBoxSound/Music/MusSlider.editor_description


func _on_LineEdit_mouse_entered():
	$DescPanel/Margin/Desc.text = $SidePanel/VBox3/LineEdit.editor_description


func _on_Buttons_mouse_entered():
	$DescPanel/Margin/Desc.text = $SidePanel/Buttons.editor_description


func _input(event): #Get input to change tabs
	if event.is_action_pressed("scroll_up"):
		$Tabs.current_tab -= 1
			
	if event.is_action_pressed("scroll_down"):
		$Tabs.current_tab += 1
