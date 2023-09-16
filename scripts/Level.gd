extends Node

export var total_time := 10
var time

signal update_timer_hud(time)
signal end_phase

func _ready():
	new_game()

func new_game():
	emit_signal("update_timer_hud", total_time)

func start():
	time = 1
	emit_signal("update_timer_hud", total_time - 1)
	$SecondTimer.start()

func _on_SecondTimer_timeout():
	time += 1
	var time_left = total_time - time
	if time_left >= 0:
		emit_signal("update_timer_hud", time_left)
	else:
		$SecondTimer.stop()
		emit_signal("end_phase")

