extends KinematicBody2D

export var data : Resource = null
export var item : Resource = null
export var desires := -1

var has_dialogue = true

func _ready() -> void:
	$Dialogue/DialogueUI.set_text(data.dialogue)
	$Dialogue/DialogueUI.hide()
	show()
	
func show_dialogue():
	if !has_dialogue:
		return
	$Dialogue/DialogueUI.show()
	$ShowDialogueTimer.start()

func _on_ShowDialogueTimer_timeout():
	$Dialogue/DialogueUI.hide()
	
func remove_item():
	item = null
	has_dialogue = false
	
func change_dialogue(message):
	$Dialogue/DialogueUI.set_text(message)
