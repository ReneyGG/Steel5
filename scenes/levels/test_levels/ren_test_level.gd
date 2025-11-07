extends Node2D

func _ready():
	$AnimationPlayer.play("enter")
	

func _physics_process(_delta):
	$CanvasLayer/Control/ColorRect/Time.text = str(int($Timer.time_left))

func _on_trigger_body_entered(_body):
	if not $CanvasLayer/Control/Water.visible:
		$Environment/Door.flip_h = true

func _on_exit_body_entered(_body):
	if $Environment/Door.flip_h:
		$AnimationPlayer.play("exit")

func exit():
	get_tree().reload_current_scene()

func _on_timer_timeout():
	$CanvasLayer/Control/Water.show()

func _on_button_pressed():
	$AnimationPlayer.play("exit")
