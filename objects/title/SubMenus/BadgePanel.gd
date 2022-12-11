extends Panel

signal hovered
signal clicked
signal unhovered

var empty = true
var type = ""
var unlocked = false

func _process(_delta):
	if type == "":
		unlocked = true


func _on_Button_mouse_entered():
	self_modulate = Color(0.404784, 0.28125, 1)
	emit_signal("hovered")


func _on_Button_mouse_exited():
	self_modulate = Color(1,1,1)
	emit_signal("unhovered")


func _on_Button_pressed():
	if unlocked:
		emit_signal("clicked",type)
		hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	

func set_badge(badge=""):
	#print(badge)
	if badge != "res://sprites/icons/badge/.png":
		type = badge
		empty = false
		$Icon.texture = load(badge)
		$Icon.visible = true
		$LockedIcon.visible = false
		
	if !unlocked:
		$Icon.visible = false
		$LockedIcon.visible = true


func update_unlocked(temp_array): 
	var temptype = type.trim_prefix("res://sprites/icons/badge/")
	temptype = temptype.trim_suffix(".png")
	#print(temptype)
	for item in temp_array:
		if item == temptype:
			unlocked = true
			$Icon.visible = true
			$LockedIcon.visible = false
			return true
	return false







