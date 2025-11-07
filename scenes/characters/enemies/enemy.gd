extends "res://scenes/characters/character.gd"

class_name ENEMY

var dziad_I : DZIAD
var dziad_II : DZIAD
var focus_dziad: DZIAD = dziad_I
var attack_range: float = 400

func _ready() -> void:
	var dziady = get_tree().get_nodes_in_group("dziady")
	dziad_I = dziady[0]
	dziad_II = dziady[1]
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	find_first_dziad()
	if !is_attacking and can_move:
		handle_movement()
		handle_animation()
	move_and_slide()
	
func find_first_dziad():
	if global_position.distance_to(dziad_I.global_position) <= global_position.distance_to(dziad_II.global_position):
		focus_dziad = dziad_I
	else :
		focus_dziad = dziad_II
		
func handle_movement():
	if global_position.distance_to(focus_dziad.global_position) <= attack_range:
		attack()
	else:
		direction = global_position.direction_to(focus_dziad.global_position)
		velocity = direction * SPEED
	
func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))

func attack():
	is_attacking = true
	velocity = Vector2.ZERO
	model_3d.attack()
	await get_tree().create_timer(1).timeout
	is_attacking = false

func take_damage():
	can_move = false
	model_3d.power_off()
