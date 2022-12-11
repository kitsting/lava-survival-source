extends Node2D

onready var grid = get_parent()

func _ready():
	#set_opacity(0.2)
	pass

func _draw():
	var LINE_COLOR = Color(1, 1, 1, 0.05)
	var LINE_WIDTH = 1

	for x in range(grid.gridsize.x + 1):
		var col_pos = (x * grid.tilesize)-8
		var limit = grid.gridsize.y * grid.tilesize
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	for y in range(grid.gridsize.y + 1):
		var row_pos = (y * grid.tilesize)-8
		var limit = grid.gridsize.x * grid.tilesize
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
