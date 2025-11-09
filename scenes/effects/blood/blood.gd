extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load(["res://Art/vfx/blood_splatter2.png", "res://Art/vfx/blood_splatter.png", "res://Art/vfx/blood_splatter3.png"].pick_random())
