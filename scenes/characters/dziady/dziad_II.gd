extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(name + "_merge"):
		if is_merged:
			end_merge_with_other_dziad()
			other_dziad.end_merge_with_other_dziad()
	if is_merged: return
	super(delta)
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.walk()
	else:
		model_3d.idle()

func attack():
	is_attacking = true
	model_3d.attack()
	await get_tree().create_timer(.5).timeout
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY:
			body.take_damage()
	is_attacking = false

func start_merge_with_other_dziad():
	model_3d.idle()
	#other_dziad.start_merge_with_other_dziad()
	
func end_merge_with_other_dziad():
	super()
	model_3d.reparent($SubViewportContainer/SubViewport)

func _on_merge_area_body_entered(body: Node2D) -> void:
	if body == other_dziad:
		start_merge_with_other_dziad()
