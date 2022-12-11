extends Control



func _process(_delta):
	if gloSettings.usecursortrans:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("fade")
	else:
		$Block.modulate = Color(1,1,1,0.99)

func pos_set(x,y):
	$Sprite.rect_position = Vector2((x-8),(y-8))
	$Block.rect_position = Vector2((x-8),(y-8))
	
func col_set(color):
	$Sprite.modulate = color


func sprite_set(sprite : String):
	$Sprite.texture = load("res://sprites/cursor/%s.png"%sprite)
	
	
func _input(_event):
	if Input.is_key_pressed(KEY_F3):
		visible = !visible

	
func pre_set(id):
	if id != 6 and id != 5:
		$Block.set_texture(load(gloBlockStats.blocks[id].sprite))
		$Block.stretch_mode = 2
		$Block.rect_position.y -= 3
	elif id == 6:
		$Block.set_texture(load("res://sprites/block/6.png"))
		$Block.stretch_mode = 0
		$Block.rect_position.y -= 1
	elif id == 5:
		$Block.set_texture(load("res://sprites/block/mine/landmine.png"))
		$Block.stretch_mode = 0
		$Block.rect_position.y -= 1


func pre_clear():
	$Block.texture = load("res://sprites/empty.png")
	
	
func get_collide(areas=false):
	if !areas:
		return $Area2D.get_overlapping_bodies()
	else:
		return $Area2D.get_overlapping_areas()
