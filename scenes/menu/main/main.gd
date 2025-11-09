extends Node2D

var t = 0
var ts = ["Podziemia Las Vegas to miejsce dla tych, którzy postawili wszystko na jedną kartę. Życie mija tutaj od powodzi do powodzi.","Gra przeznaczona dla dwóch graczy.","DZIADÓW DWÓCH"]

var start := false

func _ready():
	VegasMusic.play()

func _on_button_start_pressed():
	VegasMusic.stop()
	FightclubMusic.play()
	start = true
	$Timer.start()

func _on_button_quit_pressed():
	get_tree().quit()

func _physics_process(_delta):
	if start:
		$Camera2D.position.y += 10

func _on_timer_timeout():	
	$CanvasLayer/Control/ButtonOk.show()
	$CanvasLayer/Control/Label.text = ts[t]
	if t == 2:
		$CanvasLayer/Control/Sewer.show()

func _on_button_ok_pressed():
	t += 1
	if t >= 3:
		get_tree().change_scene_to_file("res://scenes/levels/levels/level1.tscn")
	else:
		$CanvasLayer/Control/ButtonOk.hide()
		$CanvasLayer/Control/Label.text = ""
		$Timer.start()
