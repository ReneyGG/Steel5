extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea
@onready var other_dziad_origin: Node3D = $SubViewportContainer/SubViewport/SubViewport/OtherDziadOrigin

func _physics_process(delta: float) -> void:
	super(delta)
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)

func attack():
	is_attacking = true
	model_3d.edge_grab()
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY:
			body.take_damage(self)
	await get_tree().create_timer(.5).timeout
	is_attacking = false
	
func take_damage(instigator):
	super(instigator)
	if is_merged:
		end_merge_with_other_dziad()
	var knocback_direction = instigator.global_position.direction_to(global_position)
	can_move = false
	velocity = knocback_direction * 5000
	move_and_slide()
	await get_tree().create_timer(.5).timeout
	can_move = true

func start_merge_with_other_dziad():
	super()
	other_dziad.is_merged = true
	other_dziad.model_3d.reparent(other_dziad_origin)
	other_dziad.call_deferred("reparent", self)
	#other_dziad.reparent(self)
	other_dziad.global_position = global_position
