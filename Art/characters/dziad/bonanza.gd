extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func idle():
	animation_player.play("idle")
	
func crouch_idle():
	animation_player.play("crouch_idle")
	
func run():
	animation_player.play("walk")
	
func crouch_run():
	animation_player.play("crouch_walk")
	
func attack():
	animation_player.play("kick")
