extends Node

onready var players := {
	"1": {
		viewport = $"HBoxContainer/ViewportContainer/Viewport",
		camera = $"HBoxContainer/ViewportContainer/Viewport/Camera2D",
		player = $"HBoxContainer/ViewportContainer/Viewport/Level/YSort/Player1"
	},
	"2": {
		viewport = $"HBoxContainer/ViewportContainer2/Viewport",
		camera = $"HBoxContainer/ViewportContainer2/Viewport/Camera2D",
		player = $"HBoxContainer/ViewportContainer/Viewport/Level/YSort/Player2"
	},
	"3": {
		viewport = $"ViewportContainer3/Viewport",
		camera = $"ViewportContainer3/Viewport/Camera2D",
		player = $"HBoxContainer/ViewportContainer/Viewport/Level/YSort/PlayerCenter"
	}
}

func _ready() -> void:
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	players["3"].viewport.world_2d = players["1"].viewport.world_2d
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.add_child(remote_transform)
	players["3"].viewport.get_parent().hide()

func _process(delta):
	if players["1"].player.global_position.distance_to(players["2"].player.global_position) > players["1"].viewport.get_visible_rect().size.x * 3 / 2:
		players["1"].viewport.get_parent().show()
		players["2"].viewport.get_parent().show()
		players["3"].viewport.get_parent().hide()
	else:
		players["1"].viewport.get_parent().hide()
		players["2"].viewport.get_parent().hide()
		players["3"].viewport.get_parent().show()
