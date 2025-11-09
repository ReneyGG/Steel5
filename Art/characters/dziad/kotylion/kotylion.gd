extends Node3D

@onready var walk_audio_player: AudioStreamPlayer = $WalkAudioPlayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal on_attack_trigger
signal on_attack_start

var next_hand_attack_is_left:= true

func idle():
	animation_player.play("handidle_001")
	
func run():
	animation_player.play("handwalk")
	
func attack():
	if animation_player.current_animation == "hit_R" or animation_player.current_animation == "hit_L":
		return

	if next_hand_attack_is_left:
		animation_player.play("hit_L")
	else:
		animation_player.play("hit_R")
	next_hand_attack_is_left = !next_hand_attack_is_left
	
func trigger_attack():
	on_attack_trigger.emit()

func start_attack():
	on_attack_start.emit()

func play_step_sound():
	walk_audio_player.pitch_scale = randf_range(.9, 1.1)
	walk_audio_player.play()
