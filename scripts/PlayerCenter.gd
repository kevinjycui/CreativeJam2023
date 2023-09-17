extends Node2D


var player1
var player2

func _ready():
	player1 = get_parent().get_node("Player1")
	player2 = get_parent().get_node("Player2")

func _process(delta):
	position = (player1.position + player2.position) / 2
