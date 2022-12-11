extends CanvasLayer

var p1health# = $Margin1/P1Health
var hotbarknown = null
var maxlives

var modifier = ""

var hotbarinit = 0
var roundinit = false

var heartfull = load("res://sprites/ui/LifeSmall.png")

var p1livesbase = "Margin1/Life/P1Lives/Life"
var hotbarbase = "Margin2/Hotbar/HotbarBox"
var hotbarcontainer = "Margin2/Hotbar"

var playerlife = load("res://objects/game/hudelements/PlayerLife.tscn")
var minehealth = load("res://objects/game/hudelements/MineHealth.tscn")

var popup = preload("res://objects/StatPopup.tscn")

#var visible = true
var updatevisible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Margin1.show()
	$Margin2.show()
	$Margin3.show()
	$BlockName.show()
	$Time.show()
	$vbox.show()
	
	p1health = $Margin1/Life/P1Health
	p1health.set_tint_progress(gloSettings.pinfo.color)
	p1health.set_tint_under(gloSettings.pinfo.color)
	$Margin1/Life/P1Lives.modulate = gloSettings.pinfo.color
	
	$Margin1/Life.add_constant_override("separation",1)
	$Margin1/Life/P1Lives.add_constant_override("separation",3)
	$Margin2/Hotbar.add_constant_override("separation",18)
	
	if gloBlockStats.map == 3:
		$Indicator1.texture = load("res://sprites/ui/LavaIndicatorMap3Corner.png")
		$Indicator2.texture = load("res://sprites/ui/LavaIndicatorMap3Corner.png")
		$Indicator3.texture = load("res://sprites/ui/LavaIndicatorMap3Corner.png")
		$Indicator4.texture = load("res://sprites/ui/LavaIndicatorMap3Corner.png")
		$WaterBottom.texture = load("res://sprites/ui/LavaIndicatorMap3H.png")
		$WaterLeft.texture = load("res://sprites/ui/LavaIndicatorMap3V.png")
		$WaterRight.texture = load("res://sprites/ui/LavaIndicatorMap3V.png")
		$WaterTop.texture = load("res://sprites/ui/LavaIndicatorMap3H.png")
	
#	if !gloSettings.usedebug:
#		$Margin2/Hotbar/HotbarBox1.hide()
	update_hotbar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if gloBlockStats.dying:
		$Time.visible = false
	var rrtime = str(stepify(gloBlockStats.roundleft,0.1))
	if rrtime.find(".") == -1:
		rrtime = rrtime + ".0"
	if gloBlockStats.preptime:
		if roundinit:
			$Time.text = "%s seconds until next round"%rrtime
			if gloBlockStats.roundleft <= 5 and gloBlockStats.roundleft > 0 and gloSettings.uselava:
				$Time.rect_position.y = 80
				$Time.set("custom_colors/font_color", Color(1, 0.33, 0.33))
			else:
				$Time.rect_position.y = 199
				$Time.set("custom_colors/font_color", Color(1,1,1))
		else:
			roundinit = true
	elif !gloBlockStats.preptime:
		$Time.text = "%s seconds until round end"%rrtime
		$Time.rect_position.y = 199
		$Time.set("custom_colors/font_color", Color(1,1,1))
		roundinit = false
		
	$vbox/Round.text = "Round " + str(gloBlockStats.roundnum)
	$vbox/Score.text = "Score: "+str(gloBlockStats.scorenum)
	if gloSettings.usecheats:
		$vbox/Score.set("custom_colors/font_color", Color(1, 0.37, 0.37))
	else:
		$vbox/Score.set("custom_colors/font_color", Color(1,1,1))

	if gloSettings.uselava:
		$Time.visible = true
		$vbox/Round.visible = true
	else:
		$Time.visible = false
		$vbox/Round.visible = false

func _on_Player_health(amount,lives):
	
	if maxlives == null: #Make the lives indicators/sprites
		maxlives = lives
		var templife = 1
		while templife <= maxlives:
			var lifenode = playerlife.instance()
			lifenode.set_name("Life"+str(templife))
			lifenode.texture = heartfull
			$Margin1/Life/P1Lives.add_child(lifenode)
			templife += 1
			
	if has_node(p1livesbase+str(lives+1)):
		get_node(p1livesbase+str(lives+1)).breaklife()
		#get_node(p1livesbase+str(lives)).beat(health_to_speed(amount))
		
	if has_node(p1livesbase+str(lives)):
		get_node(p1livesbase+str(lives)).beat(health_to_speed(amount))
	
	$Margin1/Life/P1Health.value = (amount)
	

func health_to_speed(health):
	var rval = 1
	if health > 250:
		rval = 0.25
	elif health <= 250 and health > 200:
		rval = 0.5
	elif health <= 200 and health > 150:
		rval = 0.6
	elif health <= 150 and health > 100:
		rval = 0.7
	elif health <= 100 and health > 5:
		rval = 0.9
	elif health <= 50:
		rval = 1.5
		
	if gloBlockStats.p1respawntime:
		rval *= 1.5
	else:
		rval *= 1
		
	return rval

func _on_GameHandler_roundtimechange(_rtime,_rnum):
	if !gloBlockStats.p1respawntime or $Time.rect_position.y == 80:
		$Margin3.hide()
	else:
		$Margin3.show()
		$Margin3/RespawnPrompt/Time.text = str(stepify(gloBlockStats.p1respawntime,0.1))
		
	if !gloBlockStats.p1respawntime:
		$Margin1/Life/P1Health.texture_over = load("res://sprites/ui/HealthOver.png")
		#$Margin1/Life/P1Health.texture_under = load("res://sprites/ui/HealthBack.png")
	else:
		$Margin1/Life/P1Health.texture_over = load("res://sprites/ui/HealthOverDead.png")
		#$Margin1/Life/P1Health.texture_under = load("res://sprites/ui/HealthBackDead.png")
	
	#0 = Towards bottom right
	#1 = Towards bottom left
	#2 = Towards top left
	#3 = Towards top right
	$Indicator1.hide()
	$Indicator2.hide()
	$Indicator3.hide()
	$Indicator4.hide()
	$WaterBottom.hide()
	$WaterLeft.hide()
	$WaterRight.hide()
	$WaterTop.hide()
	
	$Indicator1Slime.hide()
	$Indicator2Slime.hide()
	$Indicator3Slime.hide()
	$Indicator4Slime.hide()
	$WaterBottomSlime.hide()
	$WaterLeftSlime.hide()
	$WaterRightSlime.hide()
	$WaterTopSlime.hide()
	
	if gloSettings.uselava:
		if !(gloBlockStats.roundnum+1)%5 and gloBlockStats.roundnum != 0:
			modifier = "Slime"
		else:
			modifier = ""
		if gloBlockStats.map != 2:
			if gloBlockStats.lavadirection == 0:
				get_node("Indicator2"+modifier).show()
			elif gloBlockStats.lavadirection == 1:
				get_node("Indicator1"+modifier).show()
			elif gloBlockStats.lavadirection == 2:
				get_node("Indicator3"+modifier).show()
			elif gloBlockStats.lavadirection == 3:
				get_node("Indicator4"+modifier).show()
		if gloBlockStats.map == 2:
			if gloBlockStats.lavadirection == 0:
				get_node("WaterTop"+modifier).show()
			elif gloBlockStats.lavadirection == 1:
				get_node("WaterRight"+modifier).show()
			elif gloBlockStats.lavadirection == 2:
				get_node("WaterBottom"+modifier).show()
			elif gloBlockStats.lavadirection == 3:
				get_node("WaterLeft"+modifier).show()
		if gloBlockStats.map == 3:
			if gloBlockStats.lavadircardinal == 8:
				get_node("WaterTop"+modifier).show()
			if gloBlockStats.lavadircardinal == 9:
				get_node("WaterBottom"+modifier).show()
			if gloBlockStats.lavadircardinal == 10:
				get_node("WaterLeft"+modifier).show()
			if gloBlockStats.lavadircardinal == 11:
				get_node("WaterRight"+modifier).show()
		
	if updatevisible:
		updatevisible = false
		var children = get_children()
		for child in children:
			child.visible = visible


func _on_Player_blockchange(id,limit : Array):
	if hotbarknown != null:
		hotbarknown.set_state(false)
	
	if has_node(hotbarbase + str(id)):
		get_node(hotbarbase + str(id)).set_state(true)
		hotbarknown = get_node(hotbarbase + str(id))
	
	$BlockName.text = gloBlockStats.blocks[id].name
	
	for i in range(0, len(limit)):
		#print(i)
		if has_node(hotbarbase + str(i)):
			get_node(hotbarbase+str(i)).set_text(str(limit[i]))
			
			
func update_hotbar():
	for i in gloBlockStats.blocksallowed:
		if has_node(hotbarbase+str(i)):
			get_node(hotbarbase+str(i)).show()
			

func _input(_event):
	if Input.is_key_pressed(KEY_F3):
		updatevisible = true
		visible = !visible
	if Input.is_action_pressed("shift"):
		for child in self.get_children():
			child.modulate = Color(1,1,1,0.3)
	if Input.is_action_just_released("shift"):
		for child in self.get_children():
			child.modulate = Color(1,1,1,1)
			
func _on_Mine_health(health,mname):
	if !has_node("Margin1/Life/Mines/"+str(mname)):
		var newmhealth = minehealth.instance()
		newmhealth.name = str(mname)
		newmhealth.initialize(health)
		newmhealth.set_val(health)
		get_node("Margin1/Life/Mines").add_child(newmhealth)
		#get_node("Margin1/Life/"+str(mname)).position = 0
	else:
		get_node("Margin1/Life/Mines/"+str(mname)).set_val(health)


func stat_popup(text):
	var newpopup = popup.instance()
	newpopup.text = text
	$vbox/statpopups.add_child(newpopup)







