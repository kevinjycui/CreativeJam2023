extends "res://scripts/Interactable.gd"

export var texture : Texture = null

func _ready() -> void:
	._ready()
	$Sprite.texture = texture
