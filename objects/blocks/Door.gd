extends Area2D

onready var handler : Node = get_parent().get_node("BlockHandler")
onready var sound : Node = handler.get_node("BlockAudio")

var pickup = load("res://objects/blocks/Pickup.tscn")

#var gridposx = round(position.x/16)
#var gridposy = round(position.y/16)
var mode = 0
var die = false
var madepickup = false

func _ready():
	if handler.get_cell_type(round(position.x/16)-1,round(position.y/16)) == 2 and handler.get_cell_type(round(position.x/16)+1,round(position.y/16)) == 2:
		mode = 0
	elif handler.get_cell_type(round(position.x/16),round(position.y/16)-1) == 2 and handler.get_cell_type(round(position.x/16),round(position.y/16)+1) == 2:
		mode = 1
		$Sprite.texture = load("res://sprites/block/door/doorhoriz.png")
	else: remove()


func _process(_delta):
	if die:
		remove()
	
	if mode == 0:
		if handler.get_cell_type(round(position.x/16)-1,round(position.y/16)) != 2 or handler.get_cell_type(round(position.x/16)+1,round(position.y/16)) != 2:
			handler.remove_from_grid(round(position.x/16),round(position.y/16))
			if !madepickup:
				var newpickup = pickup.instance()
				newpickup.set_value(1)
				newpickup.set_id(6)
				newpickup.position.x = position.x
				newpickup.position.y = position.y
				get_tree().get_root().add_child(newpickup)
				madepickup = true
			die = true
	if mode == 1:
		if handler.get_cell_type(round(position.x/16),round(position.y/16)-1) != 2 or handler.get_cell_type(round(position.x/16),round(position.y/16)+1) != 2:
			handler.remove_from_grid(round(position.x/16),round(position.y/16))
			if !madepickup:
				var newpickup = pickup.instance()
				newpickup.set_value(1)
				newpickup.set_id(6)
				newpickup.position.x = position.x
				newpickup.position.y = position.y
				get_tree().get_root().add_child(newpickup)
				madepickup = true
			die = true


func remove():
	sound.stream = load("res://sounds/block/doorplace.wav")
	sound.pitch_scale = float(rand_range(0.4,0.8))
	sound.play(0.0)
	queue_free()
