extends "res://scenes/characters/character.gd"
class_name DZIAD

@export var other_dziad: DZIAD
var is_merged := false
@onready var merge_area: Area2D = $MergeArea
@onready var on_attack_audio_player: AudioStreamPlayer2D = $OnAttackAudioPlayer
@onready var on_take_damage_player: AudioStreamPlayer2D = $OnTakeDamagePlayer
@onready var main_audio_player: AudioStreamPlayer2D = $MainAudioPlayer

signal on_take_damage

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	direction = Input.get_vector(name + "_move_left", name + "_move_right", name + "_move_up", name + "_move_down")
	if direction and can_move:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 400)

	handle_animation()
	move_and_slide()
	if Input.is_action_just_pressed(name + "_attack") and !is_attacking:
		attack()

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.run()
	else:
		model_3d.idle()
	
func attack():
	pass
	
@warning_ignore("unused_parameter")
func take_damage(instigator, knockback):
	on_take_damage.emit()
	
func start_merge_with_other_dziad():
	if is_merged: return
	is_merged = true
	
func end_merge_with_other_dziad():
	is_merged = false
	
func play_sound(sound_path):
	main_audio_player.stream = load(sound_path)
	main_audio_player.play()
