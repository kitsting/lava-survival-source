extends Control

# Declare member variables here. Examples:
var joining = false
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Panel/Label.text = "Play multiplayer. Enter your name in the box to start"
	
	if !joining:
		peer = NetworkedMultiplayerENet.new()
		peer.create_server(19132, 4)
		get_tree().set_network_peer(peer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
