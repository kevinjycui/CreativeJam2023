extends CanvasLayer

var end = false

func _ready():
	$LastTrialLabel1.hide()
	$LastTrialLabel2.hide()

func _on_Level_update_timer_hud(time):
	$TimerLabel.text = str(time / 60) + "m " + str(time % 60).pad_zeros(2) + "s"
	$TimerLabel.show()

func _on_Level_update_trial_message(message):
	if !end:
		$TrialLabel.text = message
		$TrialLabel.show()

func _on_Level_end_phase(rng):
	$TimerLabel.text = "LAST CHANCE"
	$TrialLabel.text = "TRIALS\n"
	$TrialLabel.show()
	if rng == 0:
		$LastTrialLabel1.text = "Hades desires death"
		$LastTrialLabel2.text = "You desire freedom"
	else:
		$LastTrialLabel2.text = "Hades desires death"
		$LastTrialLabel1.text = "You desire freedom"
	$LastTrialLabel1.show()
	$LastTrialLabel2.show()
	end = true
