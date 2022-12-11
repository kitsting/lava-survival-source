tool
extends VBoxContainer


export var id : String = "factory"

var confirmed = false
var stats = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	if "map"+get_name() in gloConst:
		confirmed = true
		stats = gloConst.get("map"+get_name())
		
	if !confirmed:
		if "map"+id in gloConst:
			confirmed = true
			stats = gloConst.get("map"+id)
			
	if confirmed:
		$Label.text = stats.mapname
		$TextureRect.texture = load(stats.picture)
		$TextureRect/Locked.visible = true
		$Label.text = "???"
		if gloSettings.mapunlocks[stats.unlockid] or stats.unlock == 0:
			$TextureRect/Locked.visible = false
			$Label.text = stats.mapname



func _on_Button_button_up():
	gloSettings.pinfo.bestmap = id
	gloBlockStats.map = stats.path
	Transition.set_scene("res://rooms/Map"+str(stats.path)+".tscn")
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	

func get_hover():
	if $TextureRect/Button.is_hovered():
		return stats.desc
	elif $TextureRect/Locked.is_hovered():
		return "Reach round "+str(stats.unlock)+" to unlock"
	else:
		return null
	
	
	
	
	
	
	
	
