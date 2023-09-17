extends KinematicBody2D

export var speed = 400
export var controls : Resource = null

export var flag = 0

export var sprite_frames : SpriteFrames = null


var velocity

var flip_h = false

var item_scene = preload("res://scenes/Item.tscn")
var carry = null

var phase = 0

export var data : Resource = null

func _ready() -> void:
	$AnimatedSprite2D.frames = sprite_frames
	$CollisionShape2D.disabled = false
	$Dialogue/DialogueUI.set_text(data.dialogue)
	$Dialogue/DialogueUI.hide()
	$Tool.hide()
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
		if !get_parent().get_parent().started:
			get_parent().get_parent().start()
	else:
		$AnimatedSprite2D.stop()
		
	velocity = move_and_slide(velocity) 
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		
		if phase > 0:
			if "flag" in other and phase == 1:
				# If other is player and you are killer, end game with killer (you) wins
				get_parent().get_parent().end_game(flag + 1)	
				return
			if "gate" in other and phase == 2:
				# If other is gate and you are runner, end game with runner (you) wins
				get_parent().get_parent().end_game(flag + 1)	
				return				
		elif "data" in other and other.data != null:
			other.show_dialogue()
			
		if carry == null and "item" in other and other.item != null:
			$SpawnTimer.start()
			carry = item_scene.instance()
			carry.speed = other.item_speed
			add_child(carry)
			carry.global_position = other.get_node("ItemSpawn").global_position
			carry.set_data(other.item)
			other.remove_item()
			carry.hide()
			get_parent().get_parent().add_trial(carry.index)
			
		if "desires" in other and other.desires != -1:
			get_parent().get_parent().add_trial(other.desires)
			if carry != null and other.desires == carry.index:
				carry.set_target(other.get_node("ItemDespawn"))
				carry.to_despawn = true
				get_parent().get_parent().complete_trial(other.desires)
				other.change_dialogue("Nice.")
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		flip_h = velocity.x < -1
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

func _on_Level_end_phase(rng): # rng is player that is killer
	if flag == rng:
		phase = 1 # killer
		$Tool.texture = load("res://art/InventoryItems/Dagger.PNG")
	else:
		phase = 2 # runner
		$Tool.texture = load("res://art/InventoryItems/Final_key.png")
	if carry != null:
		carry.hide()
		carry = null
	$Tool.show()
