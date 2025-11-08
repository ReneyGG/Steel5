extends CanvasLayer

var clicked := false
var last_mode

func _ready():
	hide()

func _input(event):
	if event.is_action_released("pause"):
		#$Click.play()
		if visible:
			get_tree().paused = false
			Input.set_mouse_mode(last_mode)
			hide()
		else:
			last_mode = Input.mouse_mode
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			show()

func _on_resume_button_pressed():
	#$Click.play()
	Input.set_mouse_mode(last_mode)
	#$Press.play()
	hide()
	get_tree().paused = false

func _on_menu_button_pressed():
	get_tree().quit()
	#$Click.play()
	#$Press.play()
	#hide()
	#get_tree().paused = false
	#Fade.fade_out("res://Scenes/Menu/menu.tscn")

#func _on_resume_button_mouse_entered():
#	$Hover.play()

#func _on_menu_button_mouse_entered():
#	$Hover.play()
