extends CanvasLayer

var change = null
var type = 0

func _ready():
	$TextureRect.hide()

func set_scene(new_scene):
	$TextureRect.show()
	$AnimationPlayer.play("fadeout",-1,gloConst.transitionspeed)
	type = 0
	change = new_scene
	
	
func reload_scene():
	$TextureRect.show()
	$AnimationPlayer.play("fadeout",-1,gloConst.transitionspeed)
	type = 1
	change = 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadein":
		$TextureRect.hide()
	if anim_name == "fadeout":
		if change:
			if type == 0:
				get_tree().change_scene(change)
			elif type == 1:
				get_tree().reload_current_scene()			
				
			change = null
			$AnimationPlayer.play("fadein",-1,gloConst.transitionspeed)		
