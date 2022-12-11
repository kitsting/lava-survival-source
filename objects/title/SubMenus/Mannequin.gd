extends Sprite

var colorful = false


func change_color(new_color=Color(0,0,0)):
	$Pupil.modulate = new_color
	if colorful: $Cosmetic.modulate = new_color
	

func change_cosmetic(new_cosmetic=""):
	$Cosmetic.texture = load("res://sprites/player/cosmetic/%s.png"%new_cosmetic)
	if new_cosmetic == "1colorful":
		$Cosmetic.modulate = gloSettings.pinfo.color
		colorful = true
	else:
		$Cosmetic.modulate = Color(1,1,1)
		colorful = false
		
		
func change_badge(new_badge=""):
	#print(new_badge)
	$Badge.texture = load("res://sprites/icons/badge/%s.png"%new_badge)
	

func _process(_delta):
	var lookangle = rad2deg(get_angle_to(get_global_mouse_position()))
	var mousedist = position - get_global_mouse_position()
	
	#if (mousedist.x < 5 and mousedist.y < 5) and (mousedist.x > -5 and mousedist.y > -5): $Main/Pupil.position = Vector2(0,0) #Center
	if lookangle < -10 and lookangle > -80: $Pupil.position = Vector2(1,-1) #Down Left
	elif lookangle > -170 and lookangle < -100: $Pupil.position = Vector2(-1,-1) #Up Left
	elif lookangle < 170 and lookangle > 100: $Pupil.position = Vector2(-1,1) #Up Right
	elif lookangle > 10 and lookangle < 80: $Pupil.position = Vector2(1,1) #Down Right
	elif lookangle > -10 and lookangle < 10: $Pupil.position = Vector2(1,0) #Right
	elif (lookangle < 180 and lookangle > 170) or (lookangle > -180 and lookangle < -170): $Pupil.position = Vector2(-1,0) #Left
	elif lookangle < -80 and lookangle > -100: $Pupil.position = Vector2(0,-1) #Up
	elif lookangle > 80 and lookangle < 100: $Pupil.position = Vector2(0,1) #Down
