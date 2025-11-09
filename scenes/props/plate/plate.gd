extends Node2D
signal plate_done

var done := false

func _on_plate_body_entered(_body):
	var plate1 = $Plate1.has_overlapping_bodies()
	var plate2 = $Plate2.has_overlapping_bodies()
	if plate1 and plate2:
		plate_done.emit()
		done = true
