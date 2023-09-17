extends Node

export var total_time := 300
var time

signal update_timer_hud(time)
signal end_phase(rng)

var started = false

var trials = []
var completed_trials = []

var trials_remaining

var trial_message

var trial_names = {
	0: "Grim Reaper desires souls.\n",
	1: "Cthulhu desires eyes.\n",
	2: "Cerberus desires bones.\n",
}

onready var trial_beings = {
	0: $"YSort/Grim",
	1: $"YSort/Cthulhu",
	2: $"YSort/Cerberus",
}

signal update_trial_message(message)

func _ready():
	randomize()
	new_game()

func new_game():
	trials_remaining = trial_names.size()
	trial_message = ""
	emit_signal("update_timer_hud", total_time)
	emit_signal("update_trial_message", trial_message)

func start():
	if !started:
		time = 1
		emit_signal("update_timer_hud", total_time - 1)
		$SecondTimer.start()
		started = true

func _on_SecondTimer_timeout():
	time += 1
	var time_left = total_time - time
	if time_left >= 0:
		if time_left <= 10:
			$AudioStreamPlayer.pitch_scale = 1.0		
		emit_signal("update_timer_hud", time_left)
	else:
		$SecondTimer.stop()
		$AudioStreamPlayer.pitch_scale = 1.1
		emit_signal("end_phase", randi() % 2)
		
func trial_message():
	trial_message = "TRIALS\n"
	for trial in trials:
		if !(trial in completed_trials):
			trial_message += trial_names[trial]
	emit_signal("update_trial_message", trial_message)

func add_trial(index):
	if !(index in trials):
		trials.append(index)
	trial_message()

func complete_trial(index):
	if index in trials and !(index in completed_trials):
		completed_trials.append(index)
		trials_remaining -= 1
		trial_message()
		if trials_remaining == 0:
			$AudioStreamPlayer.stop()
			get_tree().change_scene("res://scenes/GoodEnding.tscn")
	
func end_game(player, phase):
	if player == 1 and phase == 1:
		# Player 1 kills
		get_tree().change_scene("res://scenes/Ending2.tscn")
	elif player == 2 and phase == 1:
		# Player 2 kills
		get_tree().change_scene("res://scenes/Ending1.tscn")
	elif player == 1 and phase == 2:
		# Player 1 escapes
		get_tree().change_scene("res://scenes/endingDoor2.tscn")
	elif player == 2 and phase == 2:
		# Player 2 escapes
		get_tree().change_scene("res://scenes/endingDoor1.tscn")
