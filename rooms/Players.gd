extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reassign_child(node):
	if get_tree().get_root().has_node(node):
		var source = get_tree().get_root().get_node(node)
		source.get_parent().remove_child(source)
		add_child(source)
		source.set_owner(source.get_parent())
