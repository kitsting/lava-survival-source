extends Control

var pressed = false
var allowed_tiles = [0,1,5,7,8,9,10,13,17,18,19,20,21]

func _ready():
	var temptile = randi()%allowed_tiles.size()
	for tile in $TileMap.get_used_cells():
		$TileMap.set_cell(tile.x,tile.y,allowed_tiles[temptile],false,false,false,Vector2(1,1))

func _process(_delta):
	if (Input.is_action_just_pressed("ui_end") or Input.is_action_just_pressed("ui_accept")) and !pressed:
		$Timer.stop()
		_on_Timer_timeout()
		pressed = false


func _on_Timer_timeout():
	Transition.set_scene("res://objects/menus/Title.tscn")
