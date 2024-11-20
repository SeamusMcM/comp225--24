extends Area2D
signal hit

var animation

@export var speed = 400 #player speed (pxl/sec) 
var screen_size #size of game window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	animation = "default"
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.flip_h = true
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("p2_right"):
		velocity.x += 1
	if Input.is_action_pressed("p2_left"):
		velocity.x -= 1
	if Input.is_action_pressed("p2_down"):
		velocity.y += 1
	if Input.is_action_pressed("p2_up"):
		velocity.y -= 1

	if velocity.length() > -1:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = animation
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x > 0
	# TODO modify this later if end up doign more than 1 direction movement
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0


	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body: Node2D) -> void:
	#print(body.get_groups())
	#if body.is_in_group("obstacle"):
		#hide() # Player disappears after being hit.
		#hit.emit()
		## Must be deferred as we can't change physics properties on a physics callback.
		#$CollisionShape2D.set_deferred("disabled", true)
		#print("hit a tree")
	#else:
		#p2_score += 1
		#print(p2_score)
		
	if body.get_nombre() == "food":
		print("got food")
		AudioController.play_bleat()
		body.queue_free()
		GlobalScript._p2_points_earned(int(100))
	elif body.get_nombre() == "shield":
		body.queue_free()
		animation = "shield"
		set_collision_mask_value(1,false)
		set_collision_mask_value(2,true)
		$AnimatedSprite2D.animation = animation
		$ShieldTimer.start()
	else:
		hide() # Player disappears after being hit.
		#hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		GlobalScript.set_player_inactive(2)  # Mark player 2 as inactive
		print("tree")


func _on_shield_timer_timeout() -> void:
	animation = "losingShield"
	$AnimatedSprite2D.animation = animation
	$ShieldTimer.stop()
	$LosingShieldTimer.start()

func reset():
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.animation = "default"
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	show()
func _on_losing_shield_timer_timeout() -> void:
	animation = "default"
	$AnimatedSprite2D.animation = animation
	set_collision_mask_value(1,true)
	set_collision_mask_value(2,false)
	$LosingShieldTimer.stop()
