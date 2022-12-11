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
	

func set_cosmetic(cosmetic=""):
	#print(cosmetic)
	if cosmetic != "res://sprites/player/cosmetic/.png":
		type = cosmetic
		empty = false
		$Icon.texture = load(cosmetic)
		$Icon.visible = true
		$LockedIcon.visible = false
		
		if cosmetic == "res://sprites/player/cosmetic/1colorful.png":
			$Icon.modulate = gloSettings.pinfo.color
		else:
			$Icon.modulate = Color(1,1,1)
			
	if !unlocked:
		$Icon.visible = false
		$LockedIcon.visible = true
		$Icon.modulate = Color(1,1,1)

func update_color(new_color=Color(1,1,1)):
	#print(type)
	if type == "res://sprites/player/cosmetic/1colorful.png":
		$Icon.modulate = new_color


func update_unlocked(temp_array):
	var temptype = type.trim_prefix("res://sprites/player/cosmetic/")
	temptype = temptype.trim_suffix(".png")
	for item in temp_array:
		if item == temptype:
			unlocked = true
			$Icon.visible = true
			$LockedIcon.visible = false
			return true
	return false

