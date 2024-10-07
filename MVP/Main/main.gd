extends Node

@export var obstacle_scene: PackedScene
var time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func p3_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()


func p2_game_over() -> void:
	$TimeTimer.stop()
	$ObstacleTimer.stop()

func new_game():
	time = 0
	$Player3.start($StartPosition1.position)
	$Player2.start($StartPosition2.position)
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

	# Spawn the mob by adding it to the Main scene.
	add_child(obstacle)


func _on_time_timer_timeout() -> void:
	time += 1

func _on_start_timer_timeout() -> void:
	$ObstacleTimer.start()
	$TimeTimer.start()
