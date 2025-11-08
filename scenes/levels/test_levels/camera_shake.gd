extends Camera2D

@export var randomStrength: float = 0.1
@export var shakeFade: float = 5.0

@export var dziad1 : Node2D
@export var dziad2 : Node2D

@export var ingame := false

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _process(delta):
	if not ingame:
		return
	position = (dziad1.position + dziad2.position)/2
	var distance = dziad1.position.distance_to(dziad2.position)
	var off = -0.00003*distance+0.365
	var zoom_off = clamp(off, 0.18, 0.255)
	zoom = Vector2(zoom_off, zoom_off)
	if shake_strength > 0:
		shake_strength = lerp(shake_strength,0.0,shakeFade * delta)
		randomOffset()

func apply_shake():
	shake_strength = randomStrength

func randomOffset():
	offset.x = rng.randf_range(-shake_strength,shake_strength)
	offset.y = rng.randf_range(-shake_strength,shake_strength)
