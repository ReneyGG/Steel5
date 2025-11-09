extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea
@onready var other_dziad_origin: Node3D = %OtherDziadOrigin
@onready var launch_ray_cast: RayCast2D = $AttackArea/LaunchRayCast

func _ready() -> void:
	model_3d.on_attack_trigger.connect(apply_damage)
	
func _physics_process(delta: float) -> void:
	super(delta)
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)
	if Input.is_action_just_pressed(name + "_merge"):
		if is_merged:
			launch_dziad()
			
func handle_animation():
	if is_attacking: 
		if model_3d.global_position != Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)):
			model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		return
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		if is_merged:
			model_3d.crouch_run()
		else:
			model_3d.run()
	else:
		if is_merged:
			model_3d.crouch_idle()
		else:
			model_3d.idle()
			
func launch_dziad():
	var point
	if launch_ray_cast.is_colliding():
		point = launch_ray_cast.get_collision_point()
	else:
		point = $AttackArea/LaunchRayCast/LandingSpot.global_position
	
	other_dziad.launch_to_point(point)
	is_merged = false
	
func attack():
	if is_merged:
		launch_dziad()
		return
	is_attacking = true
	on_attack_audio_player.pitch_scale = randf_range(.8, 1.2)
	on_attack_audio_player.play()
	model_3d.attack()
	await get_tree().create_timer(.6).timeout
	is_attacking = false
	
func apply_damage():
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY or body.is_in_group("props"):
			body.take_damage(self, 5000)
	
func take_damage(instigator, knockback):
	super(instigator, knockback)
	if is_merged:
		end_merge_with_other_dziad()
	var knocback_direction = instigator.global_position.direction_to(global_position)
	can_move = false
	velocity = knocback_direction * knockback
	move_and_slide()
	await get_tree().create_timer(.5).timeout
	can_move = true

func start_merge_with_other_dziad():
	super()
	other_dziad.model_3d.reparent(other_dziad_origin)
	other_dziad.model_3d.position = Vector3.ZERO
	other_dziad.call_deferred("reparent", self)
	other_dziad.global_position = global_position
