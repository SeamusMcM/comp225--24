extends Node

@export var obstacle_scene: PackedScene
@export var food_scene: PackedScene
var time
var newestObjects = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#---------------------------
func p3_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	$FoodTimer.stop()
	$HUD.show_game_over()
	
func p2_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	$FoodTimer.stop()
	$HUD.show_game_over()
#-------------------------

func _game_over() -> void:
	#rather than hiding every sprite - cover them with the load screen background?
	$Player2.visible = false
	$Player3.visible = false 	#add some logic so only one of these need be called?
	#TODO make all the obsacles and food disapear 
	
	$TimeTimer.stop()
	$ObstacleTimer.stop()
	$FoodTimer.stop()
	$HUD.show_game_over()
	AudioController.play_end_level()
	pass

func new_game():
	time = 0
	#$HUD.update_score(score)
	$Player3.start($StartPosition1.position)
	$Player2.start($StartPosition2.position)
	AudioController.play_music()
	$StartTimer.start()
	
	

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
	var velocity = Vector2(150.0, 0.0)
	obstacle.linear_velocity = velocity.rotated(direction)

	# Add to group so sprites can tell what they run into (food/obstacle)
	#obstacle.add_to_group("obstacle")

	# Spawn the mob by adding it to the Main scene.
	newestObjects.append(obstacle.position.y)
	if newestObjects.size() > 3:
		newestObjects.pop_front()
	add_child(obstacle)


func _on_time_timer_timeout() -> void:
	time += 1

func _on_start_timer_timeout() -> void:
	$ObstacleTimer.start()
	$TimeTimer.start()
	$FoodTimer.start()


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
	
	var velocity = Vector2(150.0, 0.0)
	carrot.linear_velocity = velocity.rotated(direction)
	
	add_child(carrot)


func game() -> void:
	pass # Replace with function body.
