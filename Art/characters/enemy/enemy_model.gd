extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack():
	animation_player.play("enemy_attack")
	
func run():
	animation_player.play("enemy_walk")

func death():
	animation_player.play("dead")
