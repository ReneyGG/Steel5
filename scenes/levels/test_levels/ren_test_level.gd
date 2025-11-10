extends Node2D

var enemy_count := 0
var orb_count := 0

var enemy_check := false
var orb_check := false
var plate_check:= false

func _ready():
	Global.stage += 1
	$GameplayUI/Control/ColorRect2/Stage.text = str(Global.stage)
	get_node("Dziad_I").on_take_damage.connect(_on_impact)
	get_node("Dziad_II").on_take_damage.connect(_on_impact)
	for e in $Enemies.get_children():
		e.death.connect(_on_enemy_death)
		e.on_take_damage.connect(_on_impact)
		enemy_count += 1
	for o in $Orbs.get_children():
		o.death.connect(_on_orb_death)
		o.on_take_damage.connect(_on_impact)
		orb_count += 1
	
	if enemy_count == 0:
		enemy_check = true
	if orb_count == 0:
		orb_check = true
	if get_node_or_null("Plates") == null:
		plate_check = true
	check_clear()
	$AnimationPlayer.play("enter")
	$Timer.start(50 - Global.stage)
	$TimerMinus.start(50 - Global.stage - 5)
	$Pass.play()

func _physics_process(_delta):
	$GameplayUI/Control/ColorRect/Time.text = str(int($Timer.time_left))

func _on_exit_body_entered(_body):
	if $Environment/Door.position.y >= -500.0:
		return
	if $GameplayUI/Control/Water.visible:
		return
	if not $Dziad_I.other_dziad.is_merged:
		return
	$Timer.paused = true
	$AnimationPlayer.play("exit")

func exit():
	if Global.stage+1 < 4:
		get_tree().change_scene_to_file("res://scenes/levels/levels/level"+str(Global.stage+1)+".tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/levels/level"+str(randi_range(5,10))+".tscn")

func _on_timer_timeout():
	$GameOver.play()
	$GameplayUI/Control/Water.show()
	$GameplayUI/Control/Water/WaterAnim.play("default")
	$CameraHandle/Camera2D.apply_shake()
	get_tree().paused = true

# Restart
func _on_button_pressed():
	Global.stage = 0
	$AnimationPlayer.play("exit")

func _on_impact():
	$CameraHandle/Camera2D.apply_shake()

func check_clear():
	if enemy_check and orb_check and plate_check:
		$Environment/Door.position.y = -1000.0
		$Door.play()

func _on_enemy_death():
	if $GameplayUI/Control/Water.visible:
		return
	enemy_count -= 1
	if enemy_count == 0:
		enemy_check = true
	check_clear()

func _on_orb_death():
	if $GameplayUI/Control/Water.visible:
		return
	orb_count -= 1
	if orb_count == 0:
		orb_check = true
	check_clear()

func _on_plates_plate_done():
	plate_check = true
	check_clear()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_pressed():
	Global.stage = 0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/levels/level1.tscn")

func _on_timer_minus_timeout():
	$Alarm.play()
