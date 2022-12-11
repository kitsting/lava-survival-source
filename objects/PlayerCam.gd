extends Camera2D

var _duration = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _timer = 0.0
var _last_shook_timer = 0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

var unlocked = false

func _ready():
	set_process(true)

	if gloBlockStats.map == 0:
		limit_top = 0
		limit_bottom = 0
		limit_right = get_viewport_rect().size.x-8
		limit_bottom = get_viewport_rect().size.y-8
	else:
		limit_top = 0
		limit_bottom = 0
		limit_right = (gloBlockStats.mapsize[gloBlockStats.map].x*16)-16
		limit_bottom = (gloBlockStats.mapsize[gloBlockStats.map].y*16)-16

# Shake with decreasing intensity while there's time remaining.
func _process(delta):
    # Only shake when there's shake time remaining.
	if _timer == 0:
		if gloBlockStats.map == 0:
			set_offset(Vector2(10,0))
		return
    # Only shake on certain frames.
	_last_shook_timer = _last_shook_timer + delta
    # Be mathematically correct in the face of lag; usually only happens once.
	while _last_shook_timer >= _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
	   # Lerp between [amplitude] and 0.0 intensity based on remaining shake time.
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
	   # Noise calculation logic from http://jonny.morrill.me/blog/view/14
		var new_x = rand_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = rand_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
	   # Track how much we've moved the offset, as opposed to other effects.
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
    # Reset the offset when we're done shaking.
	_timer = _timer - delta
	if _timer <= 0:
		_timer = 0
		set_offset(get_offset() - _last_offset)

# Kick off a new screenshake effect.
func shake(duration, frequency, amplitude):
    # Initialize variables.
    if gloSettings.usescreenshake:
	    _duration = duration
	    _timer = duration
	    _period_in_ms = 1.0 / frequency
	    _amplitude = amplitude
	    _previous_x = rand_range(-1.0, 1.0)
	    _previous_y = rand_range(-1.0, 1.0)
	    # Reset previous offset, if any.
	    set_offset(get_offset() - _last_offset)
	    _last_offset = Vector2(0, 0)
	
func _input(_event):
	if Input.is_key_pressed(KEY_F7) and gloBlockStats.map != 0 and gloSettings.usecam:
		if zoom == Vector2(1,1):
			zoom = Vector2(1.5,1.5)
			limit_bottom = 10000
			limit_left = -10000
			limit_right = 10000
			limit_top = -10000
		else:
			zoom = Vector2(1,1)
			limit_top = 0
			limit_bottom = 0
			limit_right = (gloBlockStats.mapsize[gloBlockStats.map].x*16)-16
			limit_bottom = (gloBlockStats.mapsize[gloBlockStats.map].y*16)-16
			
	if Input.is_key_pressed(KEY_F10) and gloSettings.usecam:
		unlocked = !unlocked
		if !unlocked:
			set_offset(Vector2(0,0))
	
	if unlocked:	
		if Input.is_key_pressed(KEY_KP_8):
			set_offset(Vector2(offset.x,offset.y-5))
		if Input.is_key_pressed(KEY_KP_2):
			set_offset(Vector2(offset.x,offset.y+5))
		if Input.is_key_pressed(KEY_KP_4):
			set_offset(Vector2(offset.x-5,offset.y))
		if Input.is_key_pressed(KEY_KP_6):
			set_offset(Vector2(offset.x+5,offset.y))
