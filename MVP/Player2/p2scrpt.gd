extends Area2D
signal hit


@export var speed = 400 #player speed (pxl/sec) 
var screen_size #size of game window
var p2_score = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
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
		$AnimatedSprite2D.animation = "default"
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
		p2_score += 100
		body.queue_free()
		print("p2 score" + str(p2_score))
	else:
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		print("tree")
