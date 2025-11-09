extends Sprite2D

@export var diff := -1.0

func _process(delta):
	position += (get_global_mouse_position()*delta/diff)-position
