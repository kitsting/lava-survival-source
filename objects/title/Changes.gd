extends Panel

func _ready():
	$Margin/Text.bbcode_text = gloChangelog.changes


func _input(event):
	if event.is_action_pressed("scroll_up"):
		if visible:
			$Margin/Text.get_v_scroll().value -= 1
			
	if event.is_action_pressed("scroll_down"):
		if visible:
			$Margin/Text.get_v_scroll().value += 1


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	

func _on_Changes_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		hide()
