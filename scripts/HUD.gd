extends CanvasLayer

func display_task(text):
	$TaskLabel.text = text
	$TaskLabel.show()

func _on_Level_update_timer_hud(time):
	$TimerLabel.text = str(time / 60) + "m " + str(time % 60).pad_zeros(2) + "s"
	$TimerLabel.show()
