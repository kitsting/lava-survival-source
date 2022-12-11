extends Node

#UI Colors
const uibluecolor = Color(0.18, 0.18, 0.76)
const uiredcolor = Color(0.58, 0, 0)
const uipurplecolor = Color(0.84, 0.08, 0.75)

#Support
const version : String = "Version 1.0"
const supportmail : String = "email@mailclient"

#Menu Speed
const menutween = 0.15
const transitionspeed = 3.5

#Weather and variation colors
const weathernormal = Color(1,1,1)
const weathernight = Color(0.718, 0.717, 0.922)
const weathersunset = Color(0.949, 0.861, 0.797)
const weathersunrise = Color(0.875, 0.875, 0.875)
const weatherrain = Color(0.604, 0.597, 0.691)

const labblue = Color(0.576141, 0.688566, 0.847656)
const labgreen = Color(0.598206, 0.773438, 0.650227)
const labred = Color(0.746094, 0.616675, 0.603287)


#Map Stats
const mapfactory = {
	mapname = "Factory",
	desc = "Single screen madness!",
	picture = "res://sprites/misc/mapselect/postcard0.png",
	path = 0,
	unlock = 0,
	unlockid = 0,
	size = Vector2(28,16)
}

const mapdesert = {
	mapname = "Desert Plateau",
	desc = "A pretty (deadly) view.",
	picture = "res://sprites/misc/mapselect/postcard1.png",
	path = 1,
	unlock = 0,
	unlockid = 0,
	size = Vector2(37,37)
}

const mapbeach = {
	mapname = "Grassy Shores",
	desc = "Tropical getaway gone wrong...",
	picture = "res://sprites/misc/mapselect/postcard2.png",
	path = 2,
	unlock = 0,
	unlockid = 0,
	size = Vector2(68,48)
}

const maplab = {
	mapname = "Waste Disposal",
	desc = "Double the pain",
	picture = "res://sprites/misc/mapselect/postcard3.png",
	path = 3,
	unlock = 5,
	unlockid = 0,
	size = Vector2(39,27)
}

const mapmines = {
	mapname = "Deep Mines",
	desc = "Defend the landmines!",
	picture = "res://sprites/misc/mapselect/postcard4.png",
	path = 4,
	unlock = 15,
	unlockid = 1,
	size = Vector2(43,32)
}

const mapsky = {
	mapname = "Sky Station",
	desc = "Unused",
	picture = "res://sprites/misc/mapselect/postcard0.png",
	path = 5,
	unlock = 10,
	unlockid = 1,
	size = Vector2(0,0)
}

const mapfuture = {
	mapname = "The Future",
	desc = "Unused",
	picture = "res://sprites/misc/mapselect/postcard0.png",
	path = 6,
	unlock = 20,
	unlockid = 2,
	size = Vector2(56,43)
}
