extends StaticBody2D

var init = false

func _ready():
	if !gloSettings.usedebug:
		hide()

func _process(delta):
	if !init:
		position = Vector2(round(position.x/16)*16,round(position.y/16)*16)
		get_parent().get_node("GameHandler").get_node("YSort").get_node("BlockHandler").add_to_grid(position.x,position.y)
		init = true
		set_process(false)