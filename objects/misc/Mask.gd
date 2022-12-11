extends Node2D


func _on_VisibilityNotifier2D_screen_entered():
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
