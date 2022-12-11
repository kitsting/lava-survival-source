extends MarginContainer

signal colour_changed(new_colour)

signal pressed()

func _ready():
	$Button.connect('pressed', self, 'button_pressed')
	self.connect('draw', $Button, 'update')
	

func button_pressed():
	emit_signal('pressed')


func get_colour():
	return $ColorRect.color
	
func set_colour(colour):
	$ColorRect.color = colour
	emit_signal('colour_changed', colour)
	
func get_button():
	return $Button

func get_colour_rect():
	return $ColorRect

