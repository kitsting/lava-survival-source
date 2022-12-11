extends Panel

var hovered = false

var stage4locked = true

var hovermessage = ""



func _process(_delta):
	if visible:
		hovermessage = null
		for child in $Margin/Grid.get_children():
			if child.has_method("get_hover"):
				var temptext = child.get_hover()
				if temptext != null:
					hovermessage = temptext
					hovered = true

		if $Margin/Grid/StageRandom/TextureRect/StageRandom.is_hovered():
			hovermessage = "What will you get?"
			hovered = true

		if hovermessage != null:
			$Desc.text = hovermessage
		else:
			#$Desc.text = "Hover over a stage to see its description!"
			hovered = false
			if $DescTimer.is_stopped():
				$DescTimer.start(0.45)


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	

func _on_StageSelect_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		hide()


func _on_DescTimer_timeout():
	$Desc.text = "Hover over a stage to see its description!"


func _on_StageRandom_button_up():
	var stage = randi()%(3 + int(gloSettings.mapunlocks[0]) + int(gloSettings.mapunlocks[1]))
	
	gloBlockStats.map = stage
	Transition.set_scene("res://rooms/Map"+str(stage)+".tscn")
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
