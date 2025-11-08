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
	await get_tree().create_timer(.5).timeout
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY:
			body.take_damage()
	is_attacking = false

func start_merge_with_other_dziad():
	super()
	other_dziad.is_merged = true
	other_dziad.model_3d.reparent(other_dziad_origin)
	other_dziad.reparent(self)

func end_merge_with_other_dziad():
	super()
	#other_dziad.reparent(get_parent())
	
func _on_merge_area_body_entered(body: Node2D) -> void:
	if body == other_dziad:
		start_merge_with_other_dziad()
