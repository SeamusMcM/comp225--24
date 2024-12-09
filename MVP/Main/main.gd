extends Node

@export var obstacle_scene: PackedScene
@export var food_scene: PackedScene
@export var shield_scene: PackedScene
@export var beans_scene: PackedScene
@export var puddle_scene: PackedScene

var temp_players = []  # Temporary list to store players
var time
var newestObjects = []
var allObjects = []
var difficulty_level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_tree_pretty()
	var global_script = get_node("/root/GlobalScript")
	GlobalScript.connect("puddle_placed", spawn_puddle)
	if global_script:
		global_script.connect("game_over", Callable(self, "_game_over"))
	#GlobalScript.connect("removed", deleteObstacle)
	#print_debug("hello")
	
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#---------------------------
func p3_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	$FoodTimer.stop()
	$PowerUpTimer.stop()
	$HUD.show_game_over()
	GlobalScript._set_diff(1)
	$TextureRect.material.set_shader_parameter("difficulty", 1)
	
func p2_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	$FoodTimer.stop()
	$PowerUpTimer.stop()
	$HUD.show_game_over()
	GlobalScript._set_diff(1)
	$TextureRect.material.set_shader_parameter("difficulty", 1)
#-------------------------

func _game_over() -> void:
	for player in temp_players:
		if player:  # Ensure player reference is valid
			player.queue_free()
	temp_players.clear()
	# for each thing on screen - remove it 
	for child in get_children():
		if child is RigidBody2D:	#check if it is food/obsacle type
			child.queue_free()		#remove from canvas entirely
	#$Player2.visible = false
	#$Player3.visible = false 	#add some logic so only one of these need be called?
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	print ("liom")
	$FoodTimer.stop()
	$PowerUpTimer.stop()
	GlobalScript.set_p1_item("none")
	GlobalScript.set_p2_item("none")
	
	var hud=get_node("HUD")
	if hud:
		await hud._on_game_over() 
	else:
		print("HUD node not found")
		
	#$HUD.show_game_over()
	AudioController.play_end_level()
	#pass

func on_player_collision(player):
	temp_players.append(player)  # Add player to the temporary list

func new_game():
	temp_players.clear()
	for child in get_children():
		if child is RigidBody2D:
			child.queue_free()
	allObjects.clear()
	
	$Player3.reset()
	$Player2.reset()
	
	time = 0
	#$HUD.update_score(score)
	difficulty_level = 1
	$ObstacleTimer.wait_time = 3.0
	GlobalScript._set_p1_points(0)
	GlobalScript._set_p2_points(0)
	GlobalScript._p1_points_earned(0)
	GlobalScript._p2_points_earned(0)
	GlobalScript.p1_active = true
	GlobalScript.p2_active = true
	$Player3.start($StartPosition1.position)
	$Player2.start($StartPosition2.position)
	$HUD.show_message("New Game Started!")

	AudioController.play_music()
	$StartTimer.start()
	allObjects.clear()

func _on_obstacle_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var obstacle = obstacle_scene.instantiate()

	# Choose a random location on Path2D.
	var obstacle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	obstacle_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = obstacle_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	obstacle.position = obstacle_spawn_location.position

	# Choose the velocity for the mob.
	#var velocity = Vector2(150.0, 0.0)
	var base_velocity = 150
	var velocity = Vector2(base_velocity * (1 + (GlobalScript._get_diff() * 0.001)), 0.0)
	obstacle.linear_velocity = velocity.rotated(direction)

	# Add to group so sprites can tell what they run into (food/obstacle)
	#obstacle.add_to_group("obstacle")

	# Spawn the mob by adding it to the Main scene.
	newestObjects.append(obstacle.position.y)
	allObjects.append(obstacle)
	if newestObjects.size() > 3:
		newestObjects.pop_front()
	add_child(obstacle)

func deleteObstacle():
	allObjects.pop_front()

func _on_time_timer_timeout() -> void:
	time += 1
	if time == 1:
		$TextureRect.material.set_shader_parameter("startTime", Time.get_ticks_msec()/1000)
		pass
	$TextureRect.material.set_shader_parameter("newTime", time)
	if time % 100 == 0:
		GlobalScript._p1_points_earned(10)
		GlobalScript._p2_points_earned(10)
	if time % 1 == 0:
		GlobalScript._increment_diff(1)
		var velocity = Vector2(150 * (1 + (GlobalScript._get_diff() * 0.0011)), 0.0)
		#for i in allObjects:
			#i.linear_velocisty = velocity.rotated(3.14159269730118)
		$TextureRect.material.set_shader_parameter("difficulty", GlobalScript._get_diff())

func adjust_timers() -> void:
	$ObstacleTimer.wait_time = max(0.5, $ObstacleTimer.wait_time - 0.1 * GlobalScript._get_diff())
	#Add code to check if each player is alive before adding time-points

func _on_start_timer_timeout() -> void:
	$ObstacleTimer.start()
	$TimeTimer.start()
	$FoodTimer.start()
	$PowerUpTimer.start()

func _on_food_timer_timeout() -> void:
	var carrot = food_scene.instantiate()
	var food_spawn_location
	food_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	food_spawn_location.progress_ratio = randf()
	
	
	#Attempt at making the carrots not spawn on top of the other objects
	var rng = RandomNumberGenerator.new()
	var my_random_number
	for i in range(10):
		my_random_number = rng.randf_range(40, 720.0)
		var goodNumber = true
		for num in newestObjects:
			if my_random_number >= num - 15 && my_random_number <= num + 100:
				goodNumber = false
		if goodNumber == true:
			break
	
	food_spawn_location.position.y = my_random_number
	
	
	var direction = food_spawn_location.rotation + PI / 2
	
	carrot.position = food_spawn_location.position
	
	
	
	#Check if carrot and obstacle collide
	if food_spawn_location.position.y >= newestObjects[-1] -15 && food_spawn_location.position.y <= newestObjects[-1] + 100:
		print("Objects Spawned On Top of Eachother")
		print("Object y: " + str(newestObjects[-1]))
		print("Carrot y: " + str(carrot.position.y))
	
	#var velocity = Vector2(150.0, 0.0)
	var base_velocity = 150
	var velocity = Vector2(base_velocity * (1+ (GlobalScript._get_diff() * 0.001)), 0.0)
	carrot.linear_velocity = velocity.rotated(direction)
	
	add_child(carrot)


func game() -> void:
	pass # Replace with function body.


func _on_power_up_timer_timeout() -> void:
	var r = RandomNumberGenerator.new()
	var powerupValue = r.randi_range(1, 2)
	var powerup
	if powerupValue == 1:
		#powerup = shield_scene.instantiate()
		powerup = beans_scene.instantiate()
	if powerupValue == 2:
		powerup = beans_scene.instantiate()
	var powerup_spawn_location
	powerup_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	powerup_spawn_location.progress_ratio = randf()
	
	
	#Attempt at making the powerups not spawn on top of the other objects
	var rng = RandomNumberGenerator.new()
	var my_random_number
	for i in range(10):
		my_random_number = rng.randf_range(40, 720.0)
		var goodNumber = true
		for num in newestObjects:
			if my_random_number >= num - 15 && my_random_number <= num + 100:
				goodNumber = false
		if goodNumber == true:
			break
	
	powerup_spawn_location.position.y = my_random_number
	
	
	var direction = powerup_spawn_location.rotation + PI / 2
	
	powerup.position = powerup_spawn_location.position
	
	#Check if powerup and obstacle collide
	if powerup_spawn_location.position.y >= newestObjects[-1] -15 && powerup_spawn_location.position.y <= newestObjects[-1] + 100:
		print("Objects Spawned On Top of Eachother")
		print("Object y: " + str(newestObjects[-1]))
		print("Powerup y: " + str(powerup.position.y))
	
	#var velocity = Vector2(150.0, 0.0)
	var base_velocity = 150
	var velocity = Vector2(base_velocity * (1+ (GlobalScript._get_diff() * 0.001)), 0.0)
	powerup.linear_velocity = velocity.rotated(direction)
	
	add_child(powerup)

func spawn_puddle(x,y):
	var puddle = puddle_scene.instantiate()
	var puddle_spawn_location
	puddle_spawn_location = $ObstaclePath/ObstacleSpawnLocation
	puddle_spawn_location.progress_ratio = randf()
	
	
	##Attempt at making the powerups not spawn on top of the other objects
	#var rng = RandomNumberGenerator.new()
	#var my_random_number
	#for i in range(10):
		#my_random_number = rng.randf_range(40, 720.0)
		#var goodNumber = true
		#for num in newestObjects:
			#if my_random_number >= num - 15 && my_random_number <= num + 100:
				#goodNumber = false
		#if goodNumber == true:
			#break
	
	puddle_spawn_location.position.x = x
	puddle_spawn_location.position.y = y
	
	
	var direction = puddle_spawn_location.rotation + PI / 2
	
	puddle.position = puddle_spawn_location.position
	
	#Check if powerup and obstacle collide
	if puddle_spawn_location.position.y >= newestObjects[-1] -15 && puddle_spawn_location.position.y <= newestObjects[-1] + 100:
		print("Objects Spawned On Top of Eachother")
		print("Object y: " + str(newestObjects[-1]))
		print("Powerup y: " + str(puddle.position.y))
	
	#var velocity = Vector2(150.0, 0.0)
	var base_velocity = 150
	var velocity = Vector2(base_velocity * (1+ (GlobalScript._get_diff() * 0.001)), 0.0)
	puddle.linear_velocity = velocity.rotated(direction)
	
	add_child(puddle)
