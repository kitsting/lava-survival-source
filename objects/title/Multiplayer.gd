extends Panel

func _ready():
	var address = IP.get_local_addresses()
	var ipstring = ""
	for i in address:
		if str(i) != "127.0.0.1" and !("fe80" in str(i)):
			ipstring = ipstring + str(i)+"\n"
	$Margin/VBox/IPs.text = "Joinable IPs:\n"+str(ipstring)
	#hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Close_button_up():
	#gloNetwork.connect_to_server("Player2",$LineEdit.text)
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	
func _on_Host_button_up():
	#gloNetwork.create_server("Player")
	hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Join_button_up():
	hide()
	#gloNetwork.connect_to_server("Player2",$LineEdit.text)
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Multiplayer_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		#print("hidden")
		hide()
