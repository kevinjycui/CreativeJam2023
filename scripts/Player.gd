extends KinematicBody2D

export var speed = 400
export var controls : Resource = null

var started = false

export var data : Resource = null

var item : Resource = null

func _ready() -> void:
	$CollisionShape2D.disabled = false
	$Dialogue/DialogueUI.set_text(data.dialogue)
	$Dialogue/DialogueUI.hide()
	show()
	
func show_dialogue():
	$Dialogue/DialogueUI.show()
	$ShowDialogueTimer.start()

func _on_ShowDialogueTimer_timeout():
	$Dialogue/DialogueUI.hide()

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed(controls.move_right):
		velocity.x += 1
	if Input.is_action_pressed(controls.move_left):
		velocity.x -= 1
	if Input.is_action_pressed(controls.move_down):
		velocity.y += 1
	if Input.is_action_pressed(controls.move_up):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		if !started:
			started = true
			get_parent().get_parent().start()
	else:
		$AnimatedSprite2D.stop()
		
	velocity = move_and_slide(velocity) 
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		if "data" in other and other.data != null:
			other.show_dialogue()
		if "item" in other and other.item != null:
			item = other.item
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

