extends KinematicBody2D

export var speed = 400
export var controls : Resource = null

export var sprite_frames : SpriteFrames = null

var started = false
var velocity

var flip_h = false

var item_scene = preload("res://scenes/Item.tscn")
var carry = null

export var data : Resource = null

func _ready() -> void:
	$AnimatedSprite2D.frames = sprite_frames
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
	velocity = Vector2.ZERO
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
			
		if carry == null and "item" in other and other.item != null:
			$SpawnTimer.start()
			carry = item_scene.instance()
			add_child(carry)
			carry.global_position = other.get_node("ItemSpawn").global_position
			carry.set_data(other.item)
			other.remove_item()
			carry.hide()
		elif carry != null and "desires" in other and other.desires == carry.index:
			carry.set_target(other.get_node("ItemDespawn"))
			carry.to_despawn = true
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		flip_h = velocity.x < 0
		$AnimatedSprite2D.flip_h = flip_h
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = flip_h
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = flip_h

func _on_SpawnTimer_timeout():
	carry.set_target(self)
	carry.show()
