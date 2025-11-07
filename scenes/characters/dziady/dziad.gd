extends CharacterBody2D


@export var SPEED = 500.0

@export var model_3d: Node3D

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(name + "_move_left", name + "_move_right", name + "_move_up", name + "_move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	handle_animation()
	move_and_slide()

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.run()
	else:
		model_3d.idle()
