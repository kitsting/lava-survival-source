extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_val(new_val):
	if new_val <= $Bar.max_value:
		$Bar.modulate = Color(0.125, 1, 0)
	if new_val <= $Bar.max_value*.75:
		$Bar.modulate = Color(0.640625, 1, 0)
	if new_val <= $Bar.max_value*.5:
		$Bar.modulate = Color(1, 0.703125, 0)
	if new_val <= $Bar.max_value*.25:
		$Bar.modulate = Color(1, 0.328125, 0)
	if new_val <= $Bar.max_value*.175:
		$Bar.modulate = Color(1, 0, 0)
		
	$Bar.value = new_val
	
	
func initialize(val):
	$Bar.max_value = val
	$Bar.value = $Bar.max_value
