extends PanelContainer

signal colour_changed(button, new_colour)
signal opened(new_button)
signal closed()

onready var alpha_box = find_node('AlphaBox')

onready var r_slider = find_node('RedSlider')
onready var g_slider = find_node('GreenSlider')
onready var b_slider = find_node('BlueSlider')
onready var a_slider = find_node('AlphaSlider')

onready var hex_label = find_node('HexLabel')
onready var paste_button = find_node('PasteButton')

#onready var ok_button = find_node('OkButton')
#onready var cancel_button = find_node('CancelButton')

enum UPDATED_BY {PASTE, SLIDER}

#ie you're editing one button then click on another without pressing
#okay or cancel- should we keep the edited colour or discard changes?
export var revert_colour_on_hot_switch = false

var _current_colour
var _initial_button_colour
var _current_button
var _a_editable = true



func _ready():
	r_slider.connect('value_changed', self, '_user_changed_a_slider')
	g_slider.connect('value_changed', self, '_user_changed_a_slider')
	b_slider.connect('value_changed', self, '_user_changed_a_slider')
	a_slider.connect('value_changed', self, '_user_changed_a_slider')
	
	paste_button.connect('pressed', self, '_paste_pressed')
	#ok_button.connect('pressed', self, '_colour_picker_done', [true])
	#cancel_button.connect('pressed', self, '_colour_picker_done', [false])
	
	set_alpha_editable(false)
	#self.visible = false
	
	$VBoxContainer.add_constant_override("separation", -5)
	rect_size.y = 100

func set_alpha_editable(val):
	alpha_box.visible = val
	_a_editable = val

func get_current_button():
	return _current_button

func open(new_button, constant_alpha=false):
	if visible:
		_colour_picker_done(not revert_colour_on_hot_switch)
	_current_button = new_button
	_initial_button_colour = new_button.get_colour()
	visible = true
	set_colour(new_button.get_colour())
	set_alpha_editable(not constant_alpha)
	emit_signal('opened', new_button)
	new_button.connect('pressed', self, '_colour_picker_done', [true])

func _colour_picker_done(was_ok):
	if not was_ok and _current_button != null and _initial_button_colour != null:
		_current_button.set_colour(_initial_button_colour)
		emit_signal('colour_changed', _current_button, _initial_button_colour)
	_current_button.disconnect('pressed', self, '_colour_picker_done')
	_initial_button_colour = null
	_current_button = null
	visible = false
	emit_signal('closed')
	

#func set_global_position(position):
#	rect_global_position = position

func set_colour(colour):
	_update_current_colour(colour, false)

func get_current_colour():
	return _current_colour

func _paste_pressed():
	_update_current_colour(Color(0.75, 0.1, 0), false)
	hsound.ui_play_sound(load("res://sounds/menu/button.wav"))

func _update_current_colour(new_colour, updated_by_slider):
	new_colour = Color(new_colour)
	#_current_button.set_colour(new_colour)
	_current_colour = new_colour
	hex_label.text = new_colour.to_html(new_colour.a != 1)
	if not updated_by_slider:
		_update_sliders(new_colour)
	emit_signal('colour_changed', _current_button, new_colour)


func _user_changed_a_slider(discard_this_value):
	var new_colour = Color(
		r_slider.ratio,
		g_slider.ratio,
		b_slider.ratio,
		1
	)
	_update_current_colour(new_colour, true)

func _update_sliders(new_colour):
	new_colour = Color(new_colour)
	r_slider.ratio = new_colour.r
	g_slider.ratio = new_colour.g
	b_slider.ratio = new_colour.b
	a_slider.ratio = new_colour.a


func _on_Random_button_up():
	var randr = rand_range(0.0,1.0)
	var randg = rand_range(0.0,1.0)
	var randb = rand_range(0.0,1.0)
	
	set_colour(Color(randr,randg,randb))
