extends Control

export var icon : Texture

var on = load("res://sprites/ui/HotbarBoxOn.png")
var off = load("res://sprites/ui/HotbarBox.png")
var boxstate = false


func _ready():
	if icon != null:
		$Box/Sprite.texture = icon
#		$Box/Sprite.rect_global_position.x = rect_global_position.x + 3
#		$Box/Sprite.rect_global_position.y = rect_global_position.y + 3
	

func set_text(text):
	$Label.text = text


func set_state(state : bool):
	if state:
		$Anim.play("idle")
		#$Box.texture = on
		boxstate = true
	else:
		$Anim.stop()
		$Box.texture = off
		boxstate = false


func _on_Anim_animation_finished(anim_name):
	if anim_name == "idle" and boxstate:
		$Anim.play("idle")
