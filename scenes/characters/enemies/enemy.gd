extends "res://scenes/characters/character.gd"

class_name ENEMY

var dziad_I : DZIAD
var dziad_II : DZIAD
var focus_dziad: DZIAD = dziad_I
var attack_range: float = 400
var is_dead:= false
@onready var attack_area: Area2D = $AttackArea
@onready var on_death_audio_player: AudioStreamPlayer2D = $OnDeathAudioPlayer
@export var health: int = 3
@export var blood_pool: PackedScene
var stunned:= false

signal death
signal on_take_damage

func _ready() -> void:
	var dziady = get_tree().get_nodes_in_group("dziady")
	dziad_I = dziady[0]
	dziad_II = dziady[1]
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	find_first_dziad()
	if direction != Vector2.ZERO:
		attack_area.look_at(attack_area.global_position + direction)
	handle_movement()
	handle_animation()
	move_and_slide()
	
func find_first_dziad():
	if global_position.distance_to(dziad_I.global_position) <= global_position.distance_to(dziad_II.global_position) or dziad_II.is_merged:
		focus_dziad = dziad_I
	else :
		focus_dziad = dziad_II
		
func handle_movement():
	if can_move and !is_attacking:
		if global_position.distance_to(focus_dziad.global_position) <= attack_range:
			attack()
		else:
			model_3d.run()
			direction = global_position.direction_to(focus_dziad.global_position)
			velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 400)
	
func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))

func attack():
	if is_attacking:
		return
	is_attacking = true
	velocity = Vector2.ZERO
	model_3d.attack()
	for body in attack_area.get_overlapping_bodies():
		if body is DZIAD:
			body.take_damage(self, 5000)
			#break
	await get_tree().create_timer(1).timeout
	is_attacking = false
	
func drop_blood():
	var new_blood_pool = blood_pool.instantiate()
	add_sibling(new_blood_pool)
	new_blood_pool.global_position = global_position

func take_damage(instigator, knockback):
	if instigator == dziad_I:
		on_hit_audio_player.stream = load(["res://audio/kotylion/uderzenie w przeciwnika 2 kotylion.mp3", "res://audio/kotylion/uderzenie w przeciwnika kotylion.mp3"].pick_random())
	else:
		on_hit_audio_player.stream = load("res://audio/bonanza/uderzanie w przeciwnika nogą.mp3")
	on_hit_audio_player.pitch_scale = randf_range(.8, 1.2)
	on_hit_audio_player.play()
	is_attacking = false
	if is_dead: return
	on_take_damage.emit()
	if instigator != dziad_I:
		health -= 1
		drop_blood()
	if health <= 0:
		dead(instigator)
		return
	var knocback_direction = instigator.global_position.direction_to(global_position)
	can_move = false
	velocity = knocback_direction * knockback
	move_and_slide()
	$SubViewportContainer.material.set("shader_parameter/active",true)
	await get_tree().create_timer(.25).timeout
	$SubViewportContainer.material.set("shader_parameter/active",false)
	await get_tree().create_timer(.25).timeout
	can_move = true
	
func dead(instigator):
	model_3d.death()
	on_death_audio_player.pitch_scale = randf_range(.8, 1.2)
	on_death_audio_player.play()
	$CollisionShape2D.disabled = true
	var knocback_direction = instigator.global_position.direction_to(global_position)
	can_move = false
	if instigator == dziad_II:
		velocity = knocback_direction * 3000
	else:
		velocity = knocback_direction * 5000
	move_and_slide()
	
	$SubViewportContainer.material.set("shader_parameter/active",true)
	await get_tree().create_timer(.25).timeout
	$SubViewportContainer.material.set("shader_parameter/active",false)
	await get_tree().create_timer(4.75).timeout
	
	is_dead = true
	is_attacking = false
	SPEED = 0
	velocity = Vector2.ZERO
	death.emit()
