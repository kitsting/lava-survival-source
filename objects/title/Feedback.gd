extends Panel


func _ready():
	$Copied.hide()
	$Margin/Text.bbcode_text = "Have a suggestion, need to report a bug, or just want to share your thoughts? You can do that here!\n\n"+\
	"All you have to do is send an email to "+gloConst.supportmail+". I'll try to reply as soon as possible!\n\n"+\
	"All feedback is greatly appreciated!"


func _on_Mail_button_up():
	OS.shell_open("mailto:"+gloConst.supportmail)
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Clip_button_up():
	OS.set_clipboard(gloConst.supportmail)
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	$Copied.show()


func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_Feedback_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()


func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		hide()
