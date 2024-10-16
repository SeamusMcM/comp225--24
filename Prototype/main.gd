extends Node

@export var mob_scene: PackedScene
@export var carrot_scene: PackedScene
var score
var time = 0
var difficulty_level = 1
var velocity = Vector2(-250, 0.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CarrotTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	time = 0
	score = "Time: 0"
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$Player.set_points(0)

func _on_score_timer_timeout() -> void:
	time += 1
	score = "Time: " + str(time)
	$HUD.update_score(score)
	$HUD.update_points("Points: " + str($Player.get_points()))
	
	if time%30 == 0 :
		update_difficulty()
#change the difficulty of the game based on time	
#func _on_difficulty_timer_timeout() 	-> void:
	#difficulty_level += 1
	#update_difficulty_display()
	
func update_difficulty() -> void:
	difficulty_level += 1
	adjust_mod_speed()
	$HUD.show_difficulty(difficulty_level)
		
func adjust_mod_speed() -> void:
	velocity -= Vector2(difficulty_level,0)
		

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$CarrotTimer.start()

func _on_mob_timer_timeout() -> void:
		# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
#
	## Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	#mob.linear_velocity = velocity.rotated(direction)
	mob.linear_velocity = velocity

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)



func _on_carrot_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var carrot = carrot_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	carrot.position = mob_spawn_location.position
#
	## Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(250, 0.0)
	carrot.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(carrot)
