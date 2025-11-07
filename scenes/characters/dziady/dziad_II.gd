extends "res://scenes/characters/dziady/dziad.gd"

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.walk()
	else:
		model_3d.idle()
