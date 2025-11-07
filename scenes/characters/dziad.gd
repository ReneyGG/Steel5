extends CharacterBody2D


const SPEED = 300.0

@onready var model_3d: Node3D = $SubViewportContainer/SubViewport/GobotSkin

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("dziad_I_move_left", "dziad_I_move_right", "dziad_I_move_up", "dziad_I_move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 10)

	handle_animation()
	move_and_slide()

func handle_animation():
	model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
