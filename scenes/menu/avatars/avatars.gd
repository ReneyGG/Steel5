extends CanvasLayer

var dziad_I : DZIAD
var dziad_II : DZIAD
@onready var dziad_i_avatar: TextureRect = $Control/Dziad_I_Avatar
@onready var dziad_ii_avatar: TextureRect = $Control/Dziad_II_Avatar

#func _ready() -> void:
	#var dziady = get_tree().get_nodes_in_group("dziady")
	#dziad_I = dziady[0]
	#dziad_II = dziady[1]
	#dziad_II.on_merge.connect(on_dziad_merge)
	#
#func on_dziad_merge():
	#pass
	#dziad_ii_avatar.texture
