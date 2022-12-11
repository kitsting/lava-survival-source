extends Position2D

var spawner = preload("res://objects/lava/LavaSpawner.tscn")

var occupy = false

enum POSTYPE{
	PLAYER1 = 4,
	PLAYER2 = 5,
	PLAYER3 = 6,
	PLAYER4 = 7,
	LAVATOPLEFT = 0,
	LAVATOPRIGHT = 1,
	LAVABOTTOMLEFT = 3,
	LAVABOTTOMRIGHT = 2,
	LAVATOP = 8,
	LAVABOTTOM = 9,
	LAVALEFT = 10,
	LAVARIGHT = 11
}

export(POSTYPE) var type = POSTYPE.PLAYER1

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	position.x = round(position.x/16)*16
	position.y = round(position.y/16)*16
	
	if (type == POSTYPE.LAVATOPRIGHT or type == POSTYPE.LAVABOTTOMRIGHT) and gloBlockStats.map == 0:
		position.x = (round(get_viewport_rect().size.x/16))*16

	match type:
		POSTYPE.PLAYER1:
			gloBlockStats.player1pos = position
		POSTYPE.LAVATOPLEFT:
			gloBlockStats.lavatlpos = position
			make_spawner()
		POSTYPE.LAVATOPRIGHT:
			gloBlockStats.lavatrpos = position
			make_spawner()
		POSTYPE.LAVABOTTOMLEFT:
			gloBlockStats.lavablpos = position
			make_spawner()
		POSTYPE.LAVABOTTOMRIGHT:
			gloBlockStats.lavabrpos = position
			make_spawner()
		
		POSTYPE.LAVATOP:
			gloBlockStats.lavatoppos = position
			make_spawner()
		POSTYPE.LAVABOTTOM:
			gloBlockStats.lavabottompos = position
			make_spawner()
		POSTYPE.LAVALEFT:
			gloBlockStats.lavaleftpos = position
			make_spawner()
		POSTYPE.LAVARIGHT:
			gloBlockStats.lavarightpos = position
			make_spawner()


func make_spawner():
	var newspawner = spawner.instance()
	newspawner.dir = type
	add_child(newspawner)
	occupy = true

func _on_Timer_timeout():
	if occupy:
		get_tree().get_root().get_node("GameHandler/YSort/BlockHandler").add_to_grid(round(position.x/16),round(position.y/16),7)
		
		get_tree().get_root().get_node("GameHandler/YSort/BlockHandler").add_to_grid(round(position.x/16)+1,round(position.y/16),7)
		get_tree().get_root().get_node("GameHandler/YSort/BlockHandler").add_to_grid(round(position.x/16)-1,round(position.y/16),7)
		get_tree().get_root().get_node("GameHandler/YSort/BlockHandler").add_to_grid(round(position.x/16),round(position.y/16)+1,7)
		get_tree().get_root().get_node("GameHandler/YSort/BlockHandler").add_to_grid(round(position.x/16),round(position.y/16)-1,7)
		
		print("Making spawner at "+str(round(position.x/16))+","+str(round(position.y/16)))
		occupy = false
