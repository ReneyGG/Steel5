extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea
@export var catapult_projectile: PackedScene
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
var can_attack:= true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(name + "_merge"):
		if is_merged:
			end_merge_with_other_dziad()
			other_dziad.end_merge_with_other_dziad()
	if is_merged:
		handle_aiming()
		return
		
	direction = Input.get_vector(name + "_move_left", name + "_move_right", name + "_move_up", name + "_move_down")
	if direction and !is_attacking and can_move:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 400)

	handle_animation()
	move_and_slide()
	handle_aiming()
	
	if Input.is_action_just_pressed(name + "_merge"):
		if is_merged:
			end_merge_with_other_dziad()
			other_dziad.end_merge_with_other_dziad()
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.walk()
	else:
		model_3d.idle()
		
func handle_aiming():
	direction = Input.get_vector(name + "_move_left", name + "_move_right", name + "_move_up", name + "_move_down")
	if direction != Vector2.ZERO:
		model_3d.look_at(Vector3(-direction.x, 0, -direction.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		attack_area.look_at(attack_area.global_position + direction)
	if Input.is_action_pressed(name + "_attack"):
		attack()
		is_attacking = true
	else:
		is_attacking = false
			
func attack():
	if can_attack:
		can_attack = false
		model_3d.attack()
		apply_damage()
		await get_tree().create_timer(.3).timeout
		can_attack = true

			
func apply_damage():
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY:
			body.take_damage(self)

func take_damage(instigator):
	super(instigator)
	if is_merged:
		end_merge_with_other_dziad()
	else:
		var knocback_direction = instigator.global_position.direction_to(global_position)
		can_move = false
		velocity = knocback_direction * 5000
		move_and_slide()
		await get_tree().create_timer(.5).timeout
		can_move = true
		
func start_merge_with_other_dziad():
	merge_area.set_deferred("monitoring", false)
	#merge_area.monitoring = false
	model_3d.idle()
	#other_dziad.start_merge_with_other_dziad()
	
func end_merge_with_other_dziad():
	model_3d.reparent($SubViewportContainer/SubViewport)
	var new_catapult_projectile = catapult_projectile.instantiate()
	get_parent().get_parent().add_child(new_catapult_projectile)
	var point_to_land = find_point_to_land()
	var projectile_direction
	var desired_distance
	if point_to_land:
		projectile_direction = global_position.direction_to(point_to_land.global_position)
		desired_distance = global_position.distance_to(point_to_land.global_position)
	else:
		projectile_direction = global_position.direction_to(Vector2.ZERO)
		desired_distance = global_position.distance_to(Vector2.ZERO)
	var desired_angle_deg = 45
	new_catapult_projectile.LaunchProjectile(self, global_position, projectile_direction, desired_distance, desired_angle_deg)
	await new_catapult_projectile.landing
	is_merged = false
	merge_area.set_deferred("monitoring", true)

func find_point_to_land() -> Node2D:
	var landing_points = get_tree().get_nodes_in_group("landing_points")
	landing_points.sort_custom(sort_by_range)
	return landing_points[0]
	
func sort_by_range(a: Node2D, b: Node2D):
	if a.global_position.distance_to(global_position) > b.global_position.distance_to(global_position):
		return true
	return false

func _on_merge_area_body_entered(body: Node2D) -> void:
	if is_merged: return
	if body == other_dziad:
		other_dziad.start_merge_with_other_dziad()
		start_merge_with_other_dziad()

#
#func _on_attack_cooldown_timer_timeout() -> void:
	#can_attack = true
