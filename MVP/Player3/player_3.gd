extends Area2D
signal hit

var animation

@export var speed = 400 #player speed (pxl/sec) 
var screen_size #size of game window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = "default"
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("p1_right"):
		velocity.x += 1
	if Input.is_action_pressed("p1_left"):
		velocity.x -= 1
	if Input.is_action_pressed("p1_down"):
		velocity.y += 1
	if Input.is_action_pressed("p1_up"):
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
		$AnimatedSprite2D.flip_h = velocity.x < 0
	# TODO modify this later if end up doign more than 1 direction movement
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0


	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body: Node2D) -> void:
	#hide() # Player disappears after being hit.
	#hit.emit()
	## Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	
	if body.get_nombre() == "food":
		AudioController.play_horse_pedaling()
		body.queue_free()
		GlobalScript._p1_points_earned(int(100))
	elif body.get_nombre() == "shield":
		body.queue_free()
		animation = "shield"
		set_collision_mask_value(1,false)
		set_collision_mask_value(2,true)
		$AnimatedSprite2D.animation = animation
		print("got the shield")
	else:
		hide() # Player disappears after being hit.
		#hit.emit()
		print("Horse")
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		GlobalScript.set_player_inactive(1)
