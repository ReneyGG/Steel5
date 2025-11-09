extends CharacterBody2D

@export var SPEED = 500.0
@export var model_3d: Node3D

var can_move := true
var is_attacking: = false
var direction := Vector2.ZERO

@onready var on_hit_audio_player: AudioStreamPlayer2D = $OnHitAudioPlayer

func handle_animation():
	if abs(velocity) > Vector2.ZERO:
		model_3d.look_at(Vector3(-velocity.x, 0, -velocity.y).rotated(Vector3(0,1,0), deg_to_rad(45)))
		model_3d.run()
	else:
		model_3d.idle()

@warning_ignore("unused_parameter")
func take_damage(instigator, knockback):
	on_hit_audio_player.pitch_scale = randf_range(.8, 1.2)
	on_hit_audio_player.play()
