extends Node2D

enum CHANNEL{
	UI = 0,
	MISC = 1,
	MUSIC = 2,
	LOOP = 3
}

func ui_play_sound(sound,from=0.0,randmin=1,randmax=1):
	if !$ui.playing:
		$ui.stream = sound
		$ui.pitch_scale = float(rand_range(randmin,randmax))
		$ui.play(from)

func misc_play_sound(sound,from=0.0,randmin=1,randmax=1):
	if !$misc.playing:
		$misc.stream = sound
		$misc.pitch_scale = float(rand_range(randmin,randmax))
		$misc.play(from)
	else:
		$misc2.stream = sound
		$misc2.pitch_scale = float(rand_range(randmin,randmax))
		$misc2.play(from)
	
func play_music(sound,from=0.0,_fade=false):
	$music.stream = sound
	$music.play(from)
	
func play_loop(sound):
	$loop.stream = sound
	$loop.play()
	
func stop_sound(channel,_fade=false):
	if channel == CHANNEL.UI:
		$ui.stop()
	if channel == CHANNEL.MISC:
		$misc.stop()
		$misc2.stop()
	if channel == CHANNEL.MUSIC:
		$music.stop()
	if channel == CHANNEL.LOOP:
		$loop.stop()
