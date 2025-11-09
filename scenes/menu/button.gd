extends TextureButton


func _ready():
	self.mouse_entered.connect(on_hover)
	self.pressed.connect(on_click)

func on_hover():
	$Hover.play()

func on_click():
	$Click.play()
