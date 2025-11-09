extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if get_parent().done:
		$Sprite2D.frame = 2
		return
	if self.has_overlapping_bodies():
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
