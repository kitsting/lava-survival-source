extends Node2D


func _ready():
	hsound.play_music(load("res://sounds/music/OneScreenWonder.ogg"))


func _exit_tree():
	hsound.stop_sound(2)
