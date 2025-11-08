extends Node2D


func _on_button_start_pressed():
	pass # Replace with function body.

func _on_button_quit_pressed():
	get_tree().quit()

func _physics_process(_delta):
	$Camera2D.position.y += 10
