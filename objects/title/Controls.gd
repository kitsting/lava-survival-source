extends Panel


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

func _input(event): #Get input to change tabs
	if event.is_action_pressed("scroll_up"):
		$Tabs.current_tab -= 1
			
	if event.is_action_pressed("scroll_down"):
		$Tabs.current_tab += 1
