extends Node2D

var enemy_count := 0

func _ready():
	Global.stage += 1
	$CanvasLayer/Control/ColorRect2/Stage.text = str(Global.stage)
	for i in $Enemies.get_children():
		i.death.connect(_on_enemy_death)
		enemy_count += 1
	$AnimationPlayer.play("enter")
	$Timer.start(20 - Global.stage)

func _physics_process(_delta):
	$CanvasLayer/Control/ColorRect/Time.text = str(int($Timer.time_left))

func _on_exit_body_entered(_body):
	if not $Environment/Door.flip_h:
		return
	if $CanvasLayer/Control/Water.visible:
		return
	if not $Dziad_I.other_dziad.is_merged:
		return
	$Timer.paused = true
	$AnimationPlayer.play("exit")

func exit():
	get_tree().reload_current_scene()

func _on_timer_timeout():
	$CanvasLayer/Control/Water.show()
	$CameraHandle/Camera2D.apply_shake()

# Restart
func _on_button_pressed():
	Global.stage = 0
	$AnimationPlayer.play("exit")

func _on_enemy_death():
	if $CanvasLayer/Control/Water.visible:
		return
	enemy_count -= 1
	if enemy_count == 0:
		$Environment/Door.flip_h = true
