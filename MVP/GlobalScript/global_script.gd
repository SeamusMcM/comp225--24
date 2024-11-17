extends Node
signal p1_points_earned
signal p2_points_earned
signal removed
signal spawn_collision
signal game_over 

var p1_points
var p2_points

var diff = 1
var p1_active=true
var p2_active=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_points = 0
	p2_points = 0

func _get_diff():
	return diff

func _set_diff(new_value):
	diff = new_value

func _increment_diff(num):
	diff = diff + num

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _remove_obstacle():
	emit_signal("removed")

func _get_p1_points():
	return p1_points

func _get_p2_points():
	return p2_points

func _set_p1_points(points: int):
	p1_points = points

func _set_p2_points(points: int):
	p2_points = points


func _p1_points_earned(added_points: int):
	p1_points = p1_points + added_points
	emit_signal("p1_points_earned", p1_points)

func _p2_points_earned(added_points: int):
	p2_points = p2_points + added_points
	emit_signal("p2_points_earned", p2_points)

func set_player_inactive(player:int):
	if player==1:
		p1_active = false
	elif player==2:
		p2_active=false
	check_game_over()

func check_game_over():
	if not p1_active and not p2_active:
		emit_signal("game_over")
	
