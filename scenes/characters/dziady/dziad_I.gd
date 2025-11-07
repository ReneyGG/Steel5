extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea

func _physics_process(delta: float) -> void:
	super(delta)
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)

func attack():
	is_attacking = true
	model_3d.edge_grab()
	await get_tree().create_timer(.5).timeout
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY:
			body.take_damage()
	is_attacking = false
