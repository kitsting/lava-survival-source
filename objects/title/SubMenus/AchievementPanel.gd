extends Panel

signal hovered
signal clicked
signal unhovered

export var aname : String = "Achievement Name"
export var adesc : String = "Achievement Description"
export var aunlocked : bool = false
var id = 0


func _ready():
	if !aunlocked:
		$Icon.self_modulate = Color(0, 0, 0)


func _on_Button_mouse_entered():
	self_modulate = Color(0.404784, 0.28125, 1)
	emit_signal("hovered",aname)


func _on_Button_mouse_exited():
	self_modulate = Color(1,1,1)
	emit_signal("unhovered")


func _on_Button_pressed():
	emit_signal("clicked",aname,adesc,$Icon.texture,$Icon.self_modulate,aunlocked,id)
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func set_name(new_name="Achievement Name"):
	aname = new_name
	

func set_desc(new_desc="Achievement Description"):
	adesc = new_desc
	
	
func set_unlocked(new_unlocked = false):
	aunlocked = new_unlocked
	
	
func set_icon(new_icon=""):
	$Icon.texture = load(new_icon)
	
	
func set_obfuscate(obfuscated,hidden):
	if obfuscated:
		adesc = "???"
	if hidden:
		if !aunlocked:
			hide()
			

func set_id(new_id):
	id = new_id
