extends Node
signal p1_points_earned
signal p2_points_earned

var p1_points
var p2_points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1_points = 0
	p2_points = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
