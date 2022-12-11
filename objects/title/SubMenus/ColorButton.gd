extends Button



func _on_Button_mouse_exited():
	get_parent().self_modulate = Color(1,1,1)

func _on_Button_mouse_entered():
	get_parent().self_modulate = Color(0.404784, 0.28125, 1)
