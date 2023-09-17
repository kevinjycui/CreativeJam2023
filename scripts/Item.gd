extends KinematicBody2D

export var speed = 400
export var follow_distance = 120

var index = -1
var target = null

var to_despawn = false

func _process(delta):
	if target == null:
		return
	var velocity = Vector2.ZERO
	var target_position = target.global_position
	if "velocity" in target:
		target_position -= follow_distance * target.velocity
	
	var distance = global_position.distance_to(target_position)
	
	if distance > follow_distance or to_despawn:
		velocity = global_position.direction_to(target_position) * speed
		
	if distance < 50 and to_despawn:
		hide()
		
	move_and_slide(velocity)

func set_target(player):
	target = player
	
func set_data(item):
	index = item.index
	$Sprite.texture = item.texture
	
func set_to_despawn():
	to_despawn = true
	var scene = get_parent().get_parent()
	get_parent().remove_child(self)
	scene.add_child(self)
	set_owner(scene)
	
