extends CanvasLayer

func _process(delta):
	if Input.is_action_pressed("ui_select") or Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://scenes/Main.tscn")
