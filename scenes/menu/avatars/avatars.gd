extends CanvasLayer

var dziad_I : DZIAD
var dziad_II : DZIAD
@onready var dziad_i_avatar: TextureRect = $Control/Dziad_I_Avatar
@onready var dziad_ii_avatar: TextureRect = $Control/Dziad_II_Avatar
@onready var dziad_i_avatar_alt: TextureRect = $Control/Dziad_I_Avatar_Alt

func _ready() -> void:
	var dziady = get_tree().get_nodes_in_group("dziady")
	dziad_I = dziady[0]
	dziad_II = dziady[1]
	dziad_II.on_merge.connect(on_dziad_merge)
	dziad_II.on_end_merge.connect(on_dziad_end_merge)
	
func on_dziad_merge():
	dziad_ii_avatar.visible = false
	dziad_i_avatar_alt.visible = true
	
func on_dziad_end_merge():
	dziad_ii_avatar.visible = true
	dziad_i_avatar_alt.visible = false
