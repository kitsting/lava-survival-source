extends Node2D

onready var handler : Node = get_parent().get_parent().get_node("YSort/BlockHandler")


func _ready():
	if gloBlockStats.map == 2:
		$Sprite.texture = load("res://sprites/particle/residue2.png")
	if gloBlockStats.map == 3:
		$Sprite.texture = load("res://sprites/particle/residue3.png")
	if !gloBlockStats.roundnum%5:
		$Sprite.texture = load("res://sprites/particle/residueslime.png")
	handler.add_to_grid(round(position.x/16),round(position.y/16),5)


func _on_Timer_timeout():
	var tempremove = handler.get_cell_type(round(position.x/16),round(position.y/16))
	var blocks = $Area2D.get_overlapping_areas()
	for block in blocks:
		if block.is_in_group("Lava"):
			return 0
			
	handler.remove_from_grid(round(position.x/16),round(position.y/16))
	if tempremove == 2:
		handler.add_to_grid(round(position.x/16),round(position.y/16),2)
	handler.lava_change(-1)
	queue_free()
