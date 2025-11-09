extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal on_attack_trigger

func idle():
	animation_player.play("handidle_001")
	
func run():
	#animation_player.play("hit_R",)
	animation_player.play("handwalk")
	
func attack():
	animation_player.play("hit_R")
	
func trigger_attack():
	on_attack_trigger.emit()
