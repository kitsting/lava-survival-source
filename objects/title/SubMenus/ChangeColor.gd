extends ColorRect

signal closing

var tempcolor = Color(0,0,0,1)
var tempcosmetic = ""
var tempbadge = ""

var unlockedcosmetics = ["2sentry","1colorful"]
var unlockedbadges = ["2dev","1globe"]

var cosmeticpanel = preload("res://objects/title/SubMenus/CosmeticPanel.tscn")
var badgepanel = preload("res://objects/title/SubMenus/BadgePanel.tscn")


func _ready():
	var tempi = 0
	for item in gloSettings.aunlocks:
		if item == true:
			if tempi >= len(gloSettings.achievements):
				tempi += 1
				continue
			var newtype = gloSettings.achievements[tempi].rewardtype
			if newtype == "badge":
				unlockedbadges.append(gloSettings.achievements[tempi].rewardname)
			elif newtype == "cosmetic":
				unlockedcosmetics.append(gloSettings.achievements[tempi].rewardname)
		tempi += 1
	print(unlockedcosmetics)
	print(unlockedbadges)
		
		
	tempcolor = gloSettings.pinfo.color
	tempcosmetic = gloSettings.pinfo.cosmetic
	tempbadge = gloSettings.pinfo.badge
	
	$Panel/Background/Margin/Color/VBox/CustomColourPicker.set_colour(gloSettings.pinfo.color)
	$Panel/Margin/VBox/Selection/Color/ColorRect.color = gloSettings.pinfo.color
	$Panel/Margin/VBox/Player/Base.change_color(gloSettings.pinfo.color)
	$Panel/Margin/VBox/Player/Base.change_cosmetic(gloSettings.pinfo.cosmetic)
	$Panel/Margin/VBox/Player/Base.change_badge(gloSettings.pinfo.badge)
	
	var cosmeticlength = gloBlockStats.cosmetics.size()
	var badgelength = gloBlockStats.badges.size()
	
	var empty_cos_panel = cosmeticpanel.instance()
	$Panel/Background/Margin/Cosmetic/VBox/Grid.add_child(empty_cos_panel)
	empty_cos_panel.connect("clicked",self,"cosmetic_change")
	
	var empty_badge_panel = badgepanel.instance()
	$Panel/Background/Margin/Badge/VBox/Grid.add_child(empty_badge_panel)
	empty_badge_panel.connect("clicked",self,"badge_change")
	
	for i in cosmeticlength:
		var new_panel = cosmeticpanel.instance()
		new_panel.set_cosmetic(gloBlockStats.cosmetics[i])
		new_panel.update_unlocked(unlockedcosmetics)
		new_panel.connect("clicked",self,"cosmetic_change")
		#new_panel.unlocked = false
		$Panel/Background/Margin/Cosmetic/VBox/Grid.add_child(new_panel)
		
	for i in badgelength:
		var new_panel = badgepanel.instance()
		new_panel.set_badge(gloBlockStats.badges[i])
		new_panel.update_unlocked(unlockedbadges)
		new_panel.connect("clicked",self,"badge_change")
		$Panel/Background/Margin/Badge/VBox/Grid.add_child(new_panel)
	

func _on_Done_button_up():
	gloSettings.pinfo.color = tempcolor
	gloSettings.pinfo.cosmetic = tempcosmetic
	gloSettings.pinfo.badge = tempbadge
	gloSettings.save_game()
	#$VBox2/HBox/ColorRect.color = gloSettings.pinfo.color
	hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	emit_signal("closing")


func _on_Cancel_button_up():
	hide()
	#$Panel/Background/Margin/Color/VBox/CustomColourPicker.set_colour(gloSettings.pinfo.color)
	#$ChangeColor/Panel/HBox2/ColorRect2.color = gloSettings.pinfo.color
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	emit_signal("closing")


func _on_ColorButton_button_up():
	$Panel/Background/Margin/Color.show()
	$Panel/Background/Margin/Cosmetic.hide()
	$Panel/Background/Margin/Badge.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_CosmeticButton_button_up():
	for panel in $Panel/Background/Margin/Cosmetic/VBox/Grid.get_children():
		panel.update_color(tempcolor)
	$Panel/Background/Margin/Color.hide()
	$Panel/Background/Margin/Cosmetic.show()
	$Panel/Background/Margin/Badge.hide()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))


func _on_BadgeButton_button_up():
	$Panel/Background/Margin/Color.hide()
	$Panel/Background/Margin/Cosmetic.hide()
	$Panel/Background/Margin/Badge.show()
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))
	
	
func _on_CustomColourPicker_colour_changed(_button, new_colour):
	#print(new_colour)
	tempcolor = new_colour
	$Panel/Margin/VBox/Selection/Color/ColorRect.color = tempcolor
	$Panel/Margin/VBox/Player/Base.change_color(tempcolor)
	
	
func cosmetic_change(path):
	var new_cos = path.trim_prefix("res://sprites/player/cosmetic/")
	new_cos = new_cos.trim_suffix(".png")
	print(new_cos)
	tempcosmetic = new_cos
	$Panel/Margin/VBox/Player/Base.change_cosmetic(tempcosmetic)
	$Panel/Margin/VBox/Player/Base.change_color(tempcolor)
	

func badge_change(path):
	var new_badge = path.trim_prefix("res://sprites/icons/badge/")
	new_badge = new_badge.trim_suffix(".png")
	print(new_badge)
	tempbadge = new_badge
	$Panel/Margin/VBox/Player/Base.change_badge(tempbadge)
	
	
	
	
