extends KinematicBody2D

export var data : Resource = null
export var item : Resource = null

func _ready() -> void:
	$Dialogue/DialogueUI.set_text(data.dialogue)
	$Dialogue/DialogueUI.hide()
	show()
	
func show_dialogue():
	$Dialogue/DialogueUI.show()
	$ShowDialogueTimer.start()

func _on_ShowDialogueTimer_timeout():
	$Dialogue/DialogueUI.hide()
