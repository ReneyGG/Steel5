extends StaticBody2D


var is_dead := false
@export var health: int = 5
var dziad_I : DZIAD
var dziad_II : DZIAD

signal death
signal on_take_damage

func _ready() -> void:
	var dziady = get_tree().get_nodes_in_group("dziady")
	dziad_I = dziady[0]
	dziad_II = dziady[1]

func take_damage(instigator, _knockback):
	if is_dead: return
	on_take_damage.emit()
	if instigator == dziad_II:
		health -= 1
	if health <= 0:
		dead(instigator)
		return
	
func dead(_instigator):
	$SubViewportContainer/SubViewport/MeshInstance3D.hide()
	is_dead = true
	death.emit()
	$CollisionShape2D.disabled = true
