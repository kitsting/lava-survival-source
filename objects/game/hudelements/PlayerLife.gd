extends TextureRect

var heartbroken = load("res://sprites/ui/LifeSmallBroken.png")
var animspeed = 1
var broken = false
var beating = false


func _process(_delta):
	if !$AnimationPlayer.is_playing() and beating == true:
		$AnimationPlayer.play("Beating",-1,animspeed)


func beat(speed=1):
	if !broken:
		set_process(true)
		animspeed = speed
		beating = true
	
	
func breaklife():
	if !broken:
		set_process(false)
		#$AnimationPlayer.stop()
		$AnimationPlayer.play("Breaking",-1,animspeed)
		#texture = heartbroken
		broken = true
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Breaking":
		$AnimationPlayer.stop()
		texture = heartbroken
