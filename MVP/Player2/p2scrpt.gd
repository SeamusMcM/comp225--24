extends Area2D
signal hit

var animation
var dampener = 1
var backwardsModifier = 1
var mysteryItem = "none"

@export var speed = 400 #player speed (pxl/sec) 
var screen_size #size of game window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	animation = "default"
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.flip_h = true
	GlobalScript.set_p2_item("none")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("p2_right"):
		velocity.x += 1
		backwardsModifier = 1
	if Input.is_action_pressed("p2_left"):
		velocity.x -= 1
		backwardsModifier = 1.3
	if Input.is_action_pressed("p2_down"):
		velocity.y += 1
	if Input.is_action_pressed("p2_up"):
		velocity.y -= 1
	if Input.is_action_pressed("p2_item") && GlobalScript.get_p2_item() == "shield":
		use_shield()
	if Input.is_action_pressed("p2_item") && GlobalScript.get_p2_item() == "beans":
		use_beans()
	if Input.is_action_pressed("p2_item") && GlobalScript.get_p2_item() == "mysterybox":
		use_mysterybox()
	if velocity.length() > -1:
		velocity = velocity.normalized() * speed * dampener * backwardsModifier
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
		if GlobalScript.get_p2_item() == "none":
			GlobalScript.set_p2_item("shield")
	elif body.get_nombre() == "beans":
		body.queue_free()
		if GlobalScript.get_p2_item() == "none":
			GlobalScript.set_p2_item("beans")
	elif body.get_nombre() == "puddle":
		dampener = 0.5
	elif body.get_nombre() == "mysterybox":
		body.queue_free()
		if GlobalScript.get_p2_item() == "none":
			GlobalScript.set_p2_item("mysterybox")
	else:
		hide() # Player disappears after being hit.
		#hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		GlobalScript.set_player_inactive(2)  # Mark player 2 as inactive
		print("tree")

func _on_body_exited(body: Node2D) -> void:
	if body.get_nombre() == "puddle":
		dampener = 1

func use_shield():
	AudioController.play_shield()
	animation = "shield"
	set_collision_mask_value(1,false)
	set_collision_mask_value(2,true)
	$AnimatedSprite2D.animation = animation
	$ShieldTimer.start()

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
	AudioController.stop_shield()
	GlobalScript.set_p2_item("none")

func use_beans():
	GlobalScript.place_puddle(position.x-30, position.y)
	GlobalScript.set_p2_item("none")

func use_mysterybox():
	GlobalScript.set_p2_item("mystery_reward")
	var r = RandomNumberGenerator.new()
	var mysteryboxValue = r.randi_range(1, 7)
	if mysteryboxValue == 1:
		GlobalScript.p2_play_mysterybox_result("plus_50")
		GlobalScript._p2_points_earned(int(50))
	if mysteryboxValue == 2:
		GlobalScript.p2_play_mysterybox_result("plus_100")
		GlobalScript._p2_points_earned(int(100))
	if mysteryboxValue == 3:
		GlobalScript.p2_play_mysterybox_result("plus_500")
		GlobalScript._p2_points_earned(int(500))
	if mysteryboxValue == 4:
		GlobalScript.p2_play_mysterybox_result("minus_100")
		GlobalScript._p2_points_earned(int(-100))
	if mysteryboxValue == 5:
		GlobalScript.p2_play_mysterybox_result("minus_500")
		GlobalScript._p2_points_earned(int(-500))
	if mysteryboxValue == 6:
		mysteryItem = "shield"
		$MysteryItemTimer.start()
		GlobalScript.p2_play_mysterybox_result("hide")
	if mysteryboxValue == 7:
		mysteryItem = "beans"
		$MysteryItemTimer.start()
		GlobalScript.p2_play_mysterybox_result("hide")

func _on_mystery_item_timer_timeout() -> void:
	GlobalScript.set_p2_item(mysteryItem)
	$MysteryItemTimer.stop()
