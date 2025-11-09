extends "res://scenes/characters/dziady/dziad.gd"

@onready var attack_area: Area2D = $AttackArea
@export var catapult_projectile: PackedScene
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var on_merge_player: AudioStreamPlayer2D = $OnMergePlayer
var can_attack:= true

signal on_merge
signal on_end_merge

func _ready() -> void:
	model_3d.on_attack_trigger.connect(apply_damage)
	model_3d.on_attack_start.connect(play_attack_sound)

@warning_ignore("unused_parameter")
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
	if is_attacking: return
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.run()
	else:
		model_3d.idle()
		
func handle_aiming():
	direction = Input.get_vector(name + "_move_left", name + "_move_right", name + "_move_up", name + "_move_down")
	if direction != Vector2.ZERO:
		model_3d.look_at(Vector3(-direction.x, model_3d.global_position.y, -direction.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		attack_area.look_at(attack_area.global_position + direction)
	if Input.is_action_pressed(name + "_attack"):
		attack()
		is_attacking = true
	else:
		if velocity != Vector2.ZERO and !is_merged:
			model_3d.run()
		else:
			model_3d.idle()
		is_attacking = false
			
func attack():
	model_3d.attack()

func play_attack_sound():
	on_attack_audio_player.pitch_scale = randf_range(.8, 1.2)
	on_attack_audio_player.play()
			
func apply_damage():
	for body in attack_area.get_overlapping_bodies():
		if body is ENEMY or body.is_in_group("props"):
			body.take_damage(self, 3000)

func take_damage(instigator, knockback):
	super(instigator, knockback)
	if !is_merged:
		#on_take_damage_player.stream = load(["res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 1 kotylion.mp3", "res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 2 kotylion.mp3", "res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 3 kotylion.mp3"].pick_random())
		#on_take_damage_player.play()
		play_sound(["res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 1 kotylion.mp3", "res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 2 kotylion.mp3", "res://audio/SFX/Kotylion/kwestie przy uderzeniach przeciwnika albo jak on dostaje hita/krzyk 3 kotylion.mp3"].pick_random())
	if is_merged:
		end_merge_with_other_dziad()
	else:
		var knocback_direction = instigator.global_position.direction_to(global_position)
		can_move = false
		velocity = knocback_direction * knockback
		move_and_slide()
		await get_tree().create_timer(.5).timeout
		can_move = true
		
func start_merge_with_other_dziad():
	is_merged = true
	#on_merge_player.stream = load(["res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/opa kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/skok kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/uważaj kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/wskakuje kotylion.mp3"].pick_random())
	#on_merge_player.play()
	play_sound(["res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/opa kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/skok kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/uważaj kotylion.mp3", "res://audio/SFX/Kotylion/wskakiwanie na plecy Kotylion/wskakuje kotylion.mp3"].pick_random())
	merge_area.set_deferred("monitoring", false)
	on_merge.emit()
	model_3d.idle()
	
func end_merge_with_other_dziad():
	on_end_merge.emit()
	$CollisionShape2D.disabled = true
	model_3d.reparent($SubViewportContainer/SubViewport)
	model_3d.position = Vector3.ZERO
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
	$CollisionShape2D.disabled = false
	is_merged = false
	merge_area.set_deferred("monitoring", true)

func launch_to_point(point):
	on_end_merge.emit()
	$CollisionShape2D.disabled = true
	model_3d.reparent($SubViewportContainer/SubViewport/SubViewport)
	model_3d.position = Vector3.ZERO
	var new_catapult_projectile = catapult_projectile.instantiate()
	new_catapult_projectile.should_splash = true
	get_parent().get_parent().add_child(new_catapult_projectile)
	var projectile_direction = global_position.direction_to(point)
	var desired_distance = global_position.distance_to(point)
	var desired_angle_deg = 45
	new_catapult_projectile.LaunchProjectile(self, global_position, projectile_direction, desired_distance, desired_angle_deg)
	is_merged = false
	await new_catapult_projectile.landing
	$CollisionShape2D.disabled = false
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


func _on_dialog_timer_timeout() -> void:
	if !other_dziad.main_audio_player.playing:
		play_sound(["res://audio/SFX/Kotylion/losowe kwestie Kotylion/dziwnie widzieć świat z poziomu kurzu kotylion.mp3", "res://audio/SFX/Kotylion/losowe kwestie Kotylion/moje pięści mają dwa imiona kotylion.mp3", "res://audio/SFX/Kotylion/losowe kwestie Kotylion/piona rick, a sorry kotylion.mp3", "res://audio/SFX/Kotylion/losowe kwestie Kotylion/woda po pas, szkoda, że go nie mam kotylion.mp3"].pick_random())
	dialog_timer.wait_time = randf_range(8,12)
	dialog_timer.start()
