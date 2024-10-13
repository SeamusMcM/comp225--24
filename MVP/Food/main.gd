extends Node

@export var obstacle_scene: PackedScene
@export var player_speed = 150.0
@export var background_scroll_speed = 200.0
var time
var bg1: Sprite2D
var bg2: Sprite2D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	#bg1 = $Background/Layer1/Layer1Image1
	#bg2 = $Background/Layer1/Layer1Image2
	#bg1.texture = preload("res://grass.png") 
	#bg2.texture = bg1.texture
	#bg2.position.x = bg1.position.x + bg1.texture.get_size().x
	#var viewport_size = get_viewport().size    
	#background.scale = Vector2(viewport_size.x / background.texture.get_width(), viewport_size.y / background.texture.get_height())

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#bg1.position.x -= background_scroll_speed * delta
	#bg2.position.x -= background_scroll_speed * delta
	#var screen_width = get_viewport().size.x
	#
	#var bg1_right_edge = bg1.position.x + (bg1.texture.get_size().x * bg1.scale.x) / 2
	#var bg2_right_edge = bg2.position.x + (bg2.texture.get_size().x * bg2.scale.x) / 2
	#
	##print(screen_width)
	##print(bg1_right_edge)
	#if abs(bg1_right_edge - screen_width) <= 200:
		#bg2.position.x = bg1_right_edge + (bg2.texture.get_size().x * bg2.scale.x) / 2
		#print("wtf")
		#
	#if abs(bg2_right_edge - screen_width) <= 200:
		#bg1.position.x = bg2_right_edge + (bg1.texture.get_size().x * bg1.scale.x) / 2
	
	




		 

	
		
	
	   






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
