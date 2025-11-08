extends Camera2D

@export var randomStrength: float = 0.1
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength,0.0,shakeFade * delta)
		randomOffset()

func apply_shake():
	shake_strength = randomStrength

func randomOffset():
	offset.x = rng.randf_range(-shake_strength,shake_strength)
	offset.y = rng.randf_range(-shake_strength,shake_strength)
