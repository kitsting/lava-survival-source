extends Area2D

signal remove
signal health

var health = 500
var markedfordeath = false


func _ready():
	if get_parent().has_node("BlockHandler"):
		connect("remove",get_parent().get_node("BlockHandler"),"remove_from_grid")
	if get_tree().get_root().has_node("GameHandler/HUD"):
			connect("health",get_tree().get_root().get_node("GameHandler/HUD"),"_on_Mine_health")
		
	$Anim.play("blink1",4)
	emit_signal("health",health,name)
		
func explode():
		emit_signal("remove",position.x/16,position.y/16)
		$Anim.stop()
		$Anim.play("death")
				
		get_tree().get_root().get_node("GameHandler/Players/Player").instadie("You lost the game",9,Vector2(self.position.x,self.position.y))
#			if block.is_in_group("BlockMine"):
#				block.explode()
		
			
		#queue_free()

func _on_Mine_area_entered(area):
	if area.is_in_group("Lava"):
		mark_for_death(gloBlockStats.lavaintensity)
		#take_damage(100)


func _on_Sprite_animation_finished():
	if $Sprite.animation == "exploding":
		queue_free()


func _on_Explosion_area_entered(area):
		if area.is_in_group("Lava"):
			if !$Anim.is_playing():
				$Anim.play("blink1",4)
				

func take_damage(amount):
	#print("taking "+str(amount)+" damage")
	health -= amount
	if health <= 0:
		#print("f")
		explode()
	emit_signal("health",health,name)
	
	
func _process(_delta):
	if markedfordeath:
		take_damage(markedfordeath)
		
func mark_for_death(val):
	markedfordeath = val


func _on_Mine_area_exited(area):
	if area.is_in_group("Lava"):
		mark_for_death(0)


func _on_Anim_animation_finished(anim_name):
	if anim_name == "death":
		z_index = 1
		$Sprite.animation = "exploding"
		hsound.misc_play_sound(load("res://sounds/misc/Explosion1.ogg"))
		get_tree().get_root().get_node("GameHandler/Players/Player/PlayerCam").shake(0.5,20,15)
		var blocks = $Explosion.get_overlapping_bodies()
		#print(blocks)
		for block in blocks:
			if block.is_in_group("Block"):
				block.take_damage(100)


func _on_Light_visibility_changed():
	if $Light.visible:
		if $Anim.current_animation == "death":
			hsound.misc_play_sound(load("res://sounds/block/mineplace.wav"))





