extends Panel

signal show_stats

export var place : int = 1
var time = OS.get_datetime()
var can_display = false
var oldmodulate = Color(1,1,1)
var badgetype = ""
var cosmetictype = ""
var mapname = ""
var currentcolor = Color(0,0,0)

func _ready():
	$HBox/Place.text = str(place)

func change_name(new_name):
	$HBox/Name.text = str(new_name)
	

func change_score(new_score):
	$HBox/Score.text = str(new_score)
	
	
func change_color(new_col):
	$HBox/Color.color = new_col
	currentcolor = new_col
	
	
func change_place(new_place):
	$HBox/Place.text = str(new_place)
	
	
func change_time(new_time):
	time = new_time
	
	
func change_isyou(new_isyou):
	if new_isyou:
		self_modulate = gloSettings.pinfo.color
	else:
		self_modulate = Color(1,1,1,1)
	

func change_badge(new_badge):
	if new_badge != "":
#		var filecheck = File.new()
#		if filecheck.file_exists("res://sprites/icons/badge/"+str(new_badge)+".png.import"):
#			$HBox/Badge.texture = load("res://sprites/icons/badge/"+str(new_badge)+".png")
		#print("looking for "+new_badge)
		for badge in gloBlockStats.badges:
			#print("currently on "+badge)
			if badge == "res://sprites/icons/badge/"+str(new_badge)+".png":
				$HBox/Badge.texture = load("res://sprites/icons/badge/"+str(new_badge)+".png")
				
	if new_badge == "":
		$HBox/Badge.texture = null
	badgetype = new_badge
	
	
func change_cosmetic(new_cosmetic):
	cosmetictype = new_cosmetic
	

func change_map(new_map):
	mapname = new_map


func _on_ShowStats_button_up():
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	if can_display:
		emit_signal("show_stats",$HBox/Name.text,$HBox/Score.text,time,mapname,badgetype,place,currentcolor,cosmetictype)


func _on_Timer_timeout():
	$Timer.queue_free()
	can_display = true


func _on_ShowStats_mouse_entered():
	oldmodulate = self_modulate
	self_modulate = Color(0.404784, 0.28125, 1)


func _on_ShowStats_mouse_exited():
	self_modulate = oldmodulate
