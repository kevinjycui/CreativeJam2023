extends Node

onready var players := {
	"1": {
		viewport = $"HBoxContainer/ViewportContainer/Viewport",
		camera = $"HBoxContainer/ViewportContainer/Viewport/Camera2D",
		player = $"HBoxContainer/ViewportContainer/Viewport/Level/Players/Player1"
	},
	"2": {
		viewport = $"HBoxContainer/ViewportContainer2/Viewport",
		camera = $"HBoxContainer/ViewportContainer2/Viewport/Camera2D",
		player = $"HBoxContainer/ViewportContainer/Viewport/Level/Players/Player2"
	}
}

func _ready() -> void:
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
