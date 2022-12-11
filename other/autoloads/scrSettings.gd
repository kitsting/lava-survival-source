extends Node

signal fullscreenchange

const savefile = "user://save.vnd"
#const settingsfile = "user://settings.vnd"

var achievementnotif = preload("res://objects/title/SubMenus/AchievementNotif.tscn")

var usescreenshake = true
var pauseonlostfocus = false
var stretchscreen = false
var usecursortrans = true
var notifs = true

var initialpost = false
var firsttime = true

var mapunlocks = [false,false]

var stats = [0,0,0,0,0,0,gloConst.version,0,0,0,0,0,0,0,0,0]
var aunlocks = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
var loop = 0

enum STAT {
	BESTROUND = 0,
	ROUNDSURVIVED = 1,
	BESTTIME = 2,
	TOTALTIME = 3,
	TIMESOPENED = 4,
	GAMESPLAYED = 5,
	SCOREVERSION = 6,
	TIMESDIED = 7,
	NULL2 = 8,
	BLOCKSPLACED = 9,
	PICKUPSCOLLECTED = 10,
	HIGHESTSCORE = 11,
	MASKSEEN = 12,
	SPECIAL1 = 13,
	SPECIAL2 = 14,
	SPECIAL3 = 15
}

var usedebug = false
var uselava = true
var lavaprevention = false
var usecheats = false
var usecam = false

var highscore = 0
var playername = ""

var canpost = false

var pinfo = {
	name = "Guest",
	color = Color(0.75, 0.1, 0),
	badge = "",
	cosmetic = "",
	id = OS.get_unique_id(),
	bestmap = ""
}

var soundval = 0.0
var musval = -6.0
	
func _ready():
	OS.set_min_window_size(Vector2(384,216))
	print(pinfo)
	stat_change(STAT.TIMESOPENED,1)
	
## Code for configuring the leaderboard API
#	SilentWolf.configure({
#		"api_key": "<API Key>",
#		"game_id": "<Game ID>",
#		"game_version": "1.5.0", #1.3.0 is previous
#		"log_level": 1
#	})
#
#	SilentWolf.configure_scores({
#		"open_scene_on_close": "res://objects/menus/title.tscn"
#	})

	
func save_game():
	#print(str(aunlocks))
	var data = ""
	data += "Score: " + str(highscore)
	data += "\nFullscreen: "+str(int(OS.window_fullscreen))
	data += "\nScreenshake: "+str(int(usescreenshake))
	data += "\nP1Col: "+str(pinfo.color)
	data += "\nFocusPause: "+str(int(pauseonlostfocus))
	data += "\nStats: "+str(stats)
	data += "\nStretch: "+str(int(stretchscreen))
	data += "\nCheats: "+str(int(usecheats))
	data += "\nName: "+str(pinfo.name)
	data += "\nScorePost: "+str(int(initialpost))
	data += "\nBadge: "+str(pinfo.badge)
	data += "\nSoundVol: "+str(soundval)
	data += "\nMusicVol: "+str(musval)
	data += "\nCursorTrans: "+str(usecursortrans)
	data += "\nCosmetic: "+str(pinfo.cosmetic)
	data += "\nAUnlocks: "+str(aunlocks)
	data += "\nNotifications: "+str(int(notifs))
	data += "\nBestMap: "+str(pinfo.bestmap)
	data += "\nFirstTime: "+str(firsttime)
	data += "\nMapUnlocks: "+str(mapunlocks)
	#print(OS.window_fullscreen)
	var save_game = File.new()
	save_game.open_encrypted_with_pass(savefile, File.WRITE, OS.get_unique_id())
	save_game.store_line(data)
	save_game.close()
	print("Game Saved")
	
func load_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass(savefile, File.READ, OS.get_unique_id())
	var data = save_game.get_as_text()
	save_game.close()
	
	data = data.split("\n")
	for line in data:
		if line.begins_with("Score:"):
			highscore = int(line.split(" ")[1])
			
		if line.begins_with("Fullscreen:"):
			OS.window_fullscreen = int(line.split(" ")[1])
			
		if line.begins_with("Screenshake:"):
			usescreenshake = int(line.split(" ")[1])
			
		if line.begins_with("FirstTime:"):
			firsttime = int(line.split(" ")[1])
			
		if line.begins_with("Notifications:"):
			notifs = int(line.split(" ")[1])
			
		if line.begins_with("CursorTrans:"):
			usecursortrans = int(line.split(" ")[1])
			
		if line.begins_with("P1Col:"):
			var temp1 = line.split(" ")[1]
			var tempr = temp1.split(",")[0]
			var tempg = temp1.split(",")[1]
			var tempb = temp1.split(",")[2]
			pinfo.color = Color(tempr,tempg,tempb)
			#print(line.split(" ")[1])
			
		if line.begins_with("FocusPause:"):
			pauseonlostfocus = int(line.split(" ")[1])
			
		if line.begins_with("Stats:"):
			loop = 0
			var tempstats = line.split("[")[1]
			tempstats = tempstats.trim_suffix("]")
			var loadstats = tempstats.split(",")
			for statdata in loadstats:
				stats[loop] = int(statdata)
				loop += 1
				
		if line.begins_with("MapUnlocks:"):
			loop = 0
			var tempmap = line.split("[")[1]
			tempmap = tempmap.trim_suffix("]")
			var loadmap = tempmap.split(",")
			for mapdata in loadmap:
				print(mapdata)
				if mapdata == "1" or mapdata == "True" or mapdata == " 1" or mapdata == " True":
					if loop < len(mapunlocks):
						mapunlocks[loop] = true
				loop += 1
				
		if line.begins_with("AUnlocks:"):
			loop = 0
			var tempunlock = line.trim_prefix("AUnlocks: [")
			tempunlock = tempunlock.trim_suffix("]")
			var loadunlocks = tempunlock.split(", ")
			for unlockdata in loadunlocks:
				if loop >= len(aunlocks):
					loop += 1
					continue
				if unlockdata == "False": aunlocks[loop] = false
				else: aunlocks[loop] = true
				loop += 1
				
			
		if line.begins_with("Stretch:"):
			stretchscreen = int(line.split(" ")[1])
			
		if line.begins_with("Cheats:"):
			usecheats = int(line.split(" ")[1])
		
		if line.begins_with("Name:"):
			pinfo.name = line.split(" ")[1]
			
		if line.begins_with("BestMap:"):
			pinfo.bestmap = line.split(" ")[1]
			
		if line.begins_with("ScorePost:"):
			initialpost = int(line.split(" ")[1])
			
		if line.begins_with("Badge:"):
			pinfo.badge = line.split(" ")[1]
			
		if line.begins_with("Cosmetic:"):
			pinfo.cosmetic = line.split(" ")[1]
			
		if line.begins_with("SoundVol:"):
			soundval = int(line.split(" ")[1])
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),soundval)
			
		if line.begins_with("MusicVol:"):
			musval = int(line.split(" ")[1])
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),musval)
			
		if aunlocks.size() < achievements.size():
			for i in aunlocks.size() - achievements.size():
				aunlocks.append(false)
	
	print("Game Loaded")
	#print(stats)
				
func _enter_tree():
	var savecheck = File.new()
	if savecheck.file_exists(savefile):
		load_game()
	else:
		save_game()

		
func _process(_delta):
	if Input.is_action_just_pressed("f11"):
		set_fullscreen()
		
	if Input.is_action_just_pressed("screenshot"):
		take_screenshot()
		
func set_fullscreen():
	OS.window_fullscreen = !OS.window_fullscreen
	emit_signal("fullscreenchange")
	save_game()
	
func set_screenshake():
	usescreenshake = !usescreenshake
	save_game()
	
func set_notifications():
	notifs = !notifs
	save_game()
	
func set_focus():
	pauseonlostfocus = !pauseonlostfocus
	save_game()
	
func set_cursortrans():
	usecursortrans = !usecursortrans
	save_game()
	
func stat_change(stat=STAT.BESTROUND,new_value=0,add=true):
	if !usecheats:
		if stat != STAT.HIGHESTSCORE and stat != STAT.BESTROUND:
			if add:
				stats[stat] += new_value
			if !add:
				stats[stat] = new_value
		elif stat == STAT.BESTROUND:
			if new_value > stats[stat]:
				stats[stat] = new_value
				if new_value >= gloConst.maplab.unlock:
					mapunlocks[0] = true
				if new_value >= gloConst.mapmines.unlock:
					mapunlocks[1] = true
		else:
			if pinfo.name != "":
				if new_value > stats[STAT.HIGHESTSCORE]:
					canpost = true
			stats[STAT.HIGHESTSCORE] = max(new_value,stats[STAT.HIGHESTSCORE])
			save_game()
			
	var i = 0
	for achievement in achievements:
		if !aunlocks[i]:
			if stats[achievement.statnum] >= achievement.statreq:
				aunlocks[i] = true
				var newnotif = achievementnotif.instance()
				newnotif.get_node("Panel").set_name(achievement.aname)
				newnotif.get_node("Panel").set_icon(achievement.icon)
				get_tree().get_root().add_child(newnotif)
				save_game()
		i += 1
	
func stat_reset():
	var tempscore = stats[STAT.HIGHESTSCORE]
	loop = 0
	for i in stats:
		stats[loop] = 0
		loop += 1
	stats[STAT.HIGHESTSCORE] = tempscore
	save_game()
	
	
func post_new_score():
	if canpost:
		gloSettings.initialpost = true
		save_game()
		canpost = false
		#Post the score to the leaderboards
#		SilentWolf.Scores.persist_score(to_json(pinfo), stats[STAT.HIGHESTSCORE])
		
func take_screenshot():
	var dir = Directory.new()
	if !dir.dir_exists("user://screenshots"):
		dir.open("user://")
		dir.make_dir("screenshots")
	
	var time = OS.get_datetime()
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("user://screenshots/"+str(time.year)+"_"+str(time.month)+"_"+str(time.day)+"-"+str(time.hour)+"_"+str(time.minute)+"_"+str(time.second)+".png")
	print("Screenshot Taken: "+"user://screenshots/"+str(time.year)+"_"+str(time.month)+"_"+str(time.day)+"-"+str(time.hour)+"_"+str(time.minute)+"_"+str(time.second)+".png")
	
	
func set_vol(bus_name : String, value):
	if bus_name == "Sound":
		soundval = value
	if bus_name == "Music":
		musval = value
		
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name),value)
	
	if soundval <= -36:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_mute(1,false)
		
	if musval <= -36:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_mute(2,false)
	#save_game()
	
	
func choose(array):
	array.shuffle()
	return array.front()
	
	
	
var achievements = [
	{
		aname = "Novice Builder",
		desc = "Place 100 Blocks",
		icon = "res://sprites/icons/achievement/novicebuild.png",
		statnum = STAT.BLOCKSPLACED,
		statreq = 100,
		rewardtype = "badge",
		rewardname = "blockwood",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Apprentice Builder",
		desc = "Place 1000 Blocks",
		icon = "res://sprites/icons/achievement/apprenticebuild.png",
		statnum = STAT.BLOCKSPLACED,
		statreq = 1000,
		rewardtype = "badge",
		rewardname = "blockstone",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Master Builder",
		desc = "Place 7500 Blocks",
		icon = "res://sprites/icons/achievement/masterbuild.png",
		statnum = STAT.BLOCKSPLACED,
		statreq = 7500,
		rewardtype = "badge",
		rewardname = "blocksteel",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Disaster Planner",
		desc = "Survive 10 rounds in a single game",
		icon = "res://sprites/icons/achievement/survive1.png",
		statnum = STAT.BESTROUND,
		statreq = 10,
		rewardtype = "badge",
		rewardname = "starbronze",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Survivor",
		desc = "Survive 20 rounds in a single game",
		icon = "res://sprites/icons/achievement/survive2.png",
		statnum = STAT.BESTROUND,
		statreq = 20,
		rewardtype = "badge",
		rewardname = "starsilver",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Disaster Master",
		desc = "Survive 40 rounds in a single game",
		icon = "res://sprites/icons/achievement/survive3.png",
		statnum = STAT.BESTROUND,
		statreq = 40,
		rewardtype = "badge",
		rewardname = "stargold",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Untouchable",
		desc = "Survive 60 rounds in a single game",
		icon = "res://sprites/icons/achievement/survive4.png",
		statnum = STAT.BESTROUND,
		statreq = 60,
		rewardtype = "cosmetic",
		rewardname = "camo",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Doing this for fun",
		desc = "Survive 100 rounds across all games",
		icon = "res://sprites/icons/achievement/manyround1.png",
		statnum = STAT.ROUNDSURVIVED,
		statreq = 100,
		rewardtype = "badge",
		rewardname = "mapdesert",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Masochist",
		desc = "Survive 250 rounds across all games",
		icon = "res://sprites/icons/achievement/manyround2.png",
		statnum = STAT.ROUNDSURVIVED,
		statreq = 250,
		rewardtype = "badge",
		rewardname = "mapbeach",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Failure",
		desc = "Die 50 times",
		icon = "res://sprites/icons/achievement/death1.png",
		statnum = STAT.TIMESDIED,
		statreq = 50,
		rewardtype = "badge",
		rewardname = "brokenheart",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Learning to succeed",
		desc = "Die 120 times",
		icon = "res://sprites/icons/achievement/death2.png",
		statnum = STAT.TIMESDIED,
		statreq = 120,
		rewardtype = "cosmetic",
		rewardname = "worn",
		hidden = false,
		obfuscated = false,
	},
#	{
#		aname = "Lava Avoider",
#		desc = "Have 2 hours of in-game playtime",
#		icon = "res://sprites/icons/achievement/time1.png",
#		statnum = STAT.TOTALTIME,
#		statreq = 120,
#		rewardtype = "badge",
#		rewardname = "steel",
#		hidden = false,
#		obfuscated = false,
#	},
#	{
#		aname = "Passing the time",
#		desc = "Have 5 hours of in-game playtime",
#		icon = "res://sprites/icons/achievement/time2.png",
#		statnum = STAT.TOTALTIME,
#		statreq = 300,
#		rewardtype = "badge",
#		rewardname = "steel",
#		hidden = false,
#		obfuscated = false,
#	},
	{
		aname = "Material Collector",
		desc = "Collect 175 pickups",
		icon = "res://sprites/icons/achievement/pickup1.png",
		statnum = STAT.PICKUPSCOLLECTED,
		statreq = 175,
		rewardtype = "cosmetic",
		rewardname = "sprinkles",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Resource Supervisor",
		desc = "Collect 375 pickups",
		icon = "res://sprites/icons/achievement/pickup2.png",
		statnum = STAT.PICKUPSCOLLECTED,
		statreq = 375,
		rewardtype = "cosmetic",
		rewardname = "lifedisc",
		hidden = false,
		obfuscated = false,
	},
	{
		aname = "Perfect Score",
		desc = "Get to Round 10 without taking any damage",
		icon = "res://sprites/icons/achievement/time2.png",
		statnum = STAT.SPECIAL1,
		statreq = 999,
		rewardtype = "badge",
		rewardname = "fullheart",
		hidden = false,
		obfuscated = false,
	},
#	{
#		aname = "Close call",
#		desc = "Survive any round past 10 with only a small amount of health left",
#		icon = "res://sprites/icons/achievement/closecall.png",
#		statnum = STAT.SPECIAL2,
#		statreq = 999,
#		rewardtype = "badge",
#		rewardname = "steel",
#		hidden = false,
#		obfuscated = false,
#	},
]
