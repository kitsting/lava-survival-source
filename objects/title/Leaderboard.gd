extends Panel

var topscores = true
var place = 0
var scorelocked = false

func _ready():
	$VScrollBar.max_value = $Margin/VBox1.get_size().x-225
	$StatsMenu.hide()
	
	for child in $Margin/VBox1.get_children():
		child.connect("show_stats",self,"show_data")
		
func _on_Close_button_up():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _on_Leaderboard_visibility_changed():
	if visible:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),gloConst.menutween,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.start()
		#var ii = 0
		#var scorelocked = false
		$LoadTimer.start(15)
#		yield(SilentWolf.Scores.get_score_position(gloSettings.stats[gloSettings.STAT.HIGHESTSCORE]),"sw_position_received")
#		place = SilentWolf.Scores.position
#		yield(SilentWolf.Scores.get_high_scores(max(10,place+10)), "sw_scores_received")
		$LoadTimer.stop()
		refresh()
		
func _on_Tween_tween_all_completed():
	if modulate.a == 0:
		hide()

func _on_VScrollBar_value_changed(value):
	$Margin/VBox1.set_position(Vector2($Margin/VBox1.get_position().x,-value))
	
	
func _input(event):
	if event.is_action_pressed("scroll_up"):
		if visible:
			$VScrollBar.value -= $VScrollBar.max_value/15
			
	if event.is_action_pressed("scroll_down"):
		if visible:
			$VScrollBar.value += $VScrollBar.max_value/15

func refresh():
	#var offset = max(0,place - SilentWolf.Scores.scores.size() + 3)
	#print(offset)
	var ii = 0
	var isyou = false
	var hasisyou = false
#	if topscores:
#		for score in SilentWolf.Scores.scores:
#			if ii >= 10:
#				ii += 1
#				continue
#
#			#print(OS.get_datetime_from_unix_time(score.timestamp/1000))
#			var name = JSON.parse(score.player_name).result
#			var color = name.color.split(",")
#			var newcolor = Color(color[0],color[1],color[2],1)
#			var newcos = ""
#			var newmap = ""
#			print(name)
#			if " (You)" in name.name:
#				name.name = name.name.rstrip(" (You)")
#			#print(name.color)
#			if name.has("cosmetic"):
#				newcos = name.cosmetic
#
#			if name.has("bestmap"):
#				newmap = name.bestmap
#
#			if name.has("id"):
#				if name.id == OS.get_unique_id():
#					name = gloSettings.pinfo
#					newcolor = gloSettings.pinfo.color
#					if !" (You)" in name.name:
#						name.name += " (You)"
#					if !hasisyou:
#						isyou = true
#						hasisyou = true
#					if !scorelocked:
#						place = ii+1
#						scorelocked = true
#
#			elif name.name == gloSettings.pinfo.name and newcolor == gloSettings.pinfo.color:
#				if name.name != "Guest" and newcolor != Color(0.75, 0.1, 0):
#					if !" (You)" in name.name:
#						name.name += " (You)"
#					if !hasisyou:
#						isyou = true
#						hasisyou = true
#					if !scorelocked:
#						place = ii+1
#						scorelocked = true
#			#if ii < 10:
#			#print(ii)
#			if topscores:
#				print(ii+1)
#				if has_node("Margin/VBox1/P"+str(ii+1)):
#					get_node("Margin/VBox1/P"+str(ii+1)).change_name(name.name)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_score(score.score)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_color(newcolor)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_badge(name.badge)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_place(ii+1)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_isyou(isyou)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_cosmetic(newcos)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_map(newmap)
#					get_node("Margin/VBox1/P"+str(ii+1)).change_time(OS.get_datetime_from_unix_time(score.timestamp/1000))
#
#			ii += 1
#			isyou = false
#
#	if !topscores:
#		var offset = (7+place) + (place - SilentWolf.Scores.scores.size() + 1)
#		var newoffset = 3-place
#		print("size "+str(SilentWolf.Scores.scores.size()))
#		var oldplace = place
#		for child in $Margin/VBox1.get_children():
#			print(oldplace+newoffset)
#			if oldplace+newoffset > SilentWolf.Scores.scores.size() - 1:
#				offset += 1# = SilentWolf.Scores.scores.size() - 1
#			var score = SilentWolf.Scores.scores[oldplace+newoffset]
#			var name = JSON.parse(score.player_name).result
#			var color = name.color.split(",")
#			var newcolor = Color(color[0],color[1],color[2],1)
#			var newcos = ""
#			var newmap = ""
#			#print(name)
#			#print(name.color)
#			if " (You)" in name.name:
#				name.name = name.name.rstrip(" (You)")
#
#			if name.has("cosmetic"):
#				newcos = name.cosmetic
#
#			if name.has("bestmap"):
#				newmap = name.bestmap
#
#			if name.has("id"):
#				if name.id == OS.get_unique_id():
#					name = gloSettings.pinfo
#					#newcos = gloSettings.pinfo.cosmetic
#					newcolor = gloSettings.pinfo.color
#					if !" (You)" in name.name:
#						name.name += " (You)"
#					if !hasisyou:
#						isyou = true
#						hasisyou = true
#					if !scorelocked:
#						place = place+newoffset
#						scorelocked = true
##				else:
##					name = yield(SilentWolf.Players.get_player_data(name.id), "sw_player_data_received")
#			elif name.name == gloSettings.pinfo.name and newcolor == gloSettings.pinfo.color:
#				if name.name != "Guest" and newcolor != Color(0.75, 0.1, 0):
#					name = gloSettings.pinfo
#					#newcos = gloSettings.pinfo.cosmetic
#					if !" (You)" in name.name:
#						name.name += " (You)"
#					if !hasisyou:
#						isyou = true
#						hasisyou = true
#					if !scorelocked:
#						place = oldplace+newoffset
#						scorelocked = true
#
#
#			child.change_name(name.name)
#			child.change_score(score.score)
#			child.change_color(newcolor)
#			child.change_badge(name.badge)
#			child.change_place((oldplace+newoffset+1))
#			child.change_isyou(isyou)
#			child.change_cosmetic(newcos)
#			child.change_map(newmap)
#			#print(newcos)
#			child.change_time(OS.get_datetime_from_unix_time(score.timestamp/1000))
#			offset -= 1
#			newoffset += 1
#			isyou = false
#
	if place > 8:
		$Bottom/ChangeMode.disabled = false
		
	print("Leaderboard Refreshed")
	if gloSettings.pinfo.name == "":
		$Bottom/Label.text = "You need to set a name to know your rank"
#	elif SilentWolf.Scores.scores.size() != 0:
#		$Bottom/Label.text = "You place #"+str(place)+" on the leaderboard"+("!" if place <= 10 else "")
	else:
		$Bottom/Label.text = "There are no scores to show"

func _on_ChangeMode_button_up():
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	topscores = !topscores
	if topscores:
		$Bottom/ChangeMode.text = "Highest"
	elif !topscores:
		$Bottom/ChangeMode.text = "Relative"
	refresh()


func _on_LoadTimer_timeout():
	$Bottom/Label.text = "There was a loading issue. Sorry!"
	
	
func show_data(name : String,score : String,time,map="unknown",badge="dev",place=1,color=Color(0,0,0),cosmetic=""):
	if map == "":
		map = "unknown"
	$StatsMenu.show()
	$StatsMenu/Panel/Margin/Base.change_badge(badge)
	$StatsMenu/Panel/Margin/Base.change_color(color)
	$StatsMenu/Panel/Margin/Base.change_cosmetic(cosmetic)
	$StatsMenu/Panel/Margin/VBoxContainer/HBox/Name.text = name
	$StatsMenu/Panel/Margin/VBoxContainer/Score.text = "Score: "+score
	$StatsMenu/Panel/Margin/VBoxContainer/HBox/Place.text = "#"+str(place)
	var date = str(time.month)+"/"+str(time.day)+"/"+str(time.year)
	var scoretime = str(time.hour)+":"+str(time.minute)
	$StatsMenu/Panel/Margin/VBoxContainer/Time.text = "Obtained on "+date+" at "+scoretime
	$StatsMenu/Panel/Margin/VBoxContainer/Map.text = "Map: "+map.capitalize()


func _on_Ok_pressed():
	$StatsMenu.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
