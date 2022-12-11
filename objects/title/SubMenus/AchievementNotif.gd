extends Panel

var leaving = false


func _ready():
	if !gloSettings.notifs:
		queue_free()
	
	rect_position.y = -40
	$Tween.interpolate_property(self,"rect_position",Vector2(88,-40),Vector2(88,0),0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()


func _on_Tween_tween_all_completed():
	if !leaving:
		leaving = true
		$Timer.start(3)
	else:
		queue_free()


func _on_Timer_timeout():
	$Tween.interpolate_property(self,"rect_position",Vector2(88,0),Vector2(88,-40),0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$Tween.start()

func set_name(new_name):
	print(new_name)
	$Margin/HBox/VBox/Label.text = new_name
	
func set_icon(icon_path):
	$Margin/HBox/TextureRect.texture = load(icon_path)
