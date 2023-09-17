extends Node

export var total_time := 300
var time

signal update_timer_hud(time)
signal end_phase

var trials = []
var trials_remaining

var trial_message

var trial_names = {
	0: "Grim Reaper desires souls.\n",
	1: "Cthulhu desires eyes.\n",
	2: "Cerberus desires bones.\n",
}

onready var trial_beings = {
	0: $"YSort/Grim",
	1: "$YSort/Cthulhu",
	2: "$YSort/Cerberus",
}

signal update_trial_message(message)

func _ready():
	new_game()

func new_game():
	trials_remaining = trial_names.size()
	trial_message = ""
	emit_signal("update_timer_hud", total_time)
	emit_signal("update_trial_message", trial_message)

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
		
func trial_message():
	trial_message = "TRIALS\n"
	for trial in trials:
		trial_message += trial_names[trial]
	emit_signal("update_trial_message", trial_message)

func add_trial(index):
	if !(index in trials):
		trials.append(index)
	trial_message()

func complete_trial(index):
	if index in trials:
		trials.erase(index)
	trials_remaining -= 1
	trial_message()
