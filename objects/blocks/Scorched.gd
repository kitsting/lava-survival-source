extends Area2D


var rounds = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("GameHandler").connect("roundstarted",self,"round_decrease")


func round_decrease():
	rounds -= 1
	if rounds <= 1:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),1.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()
		



func _on_Tween_tween_all_completed():
	queue_free()
