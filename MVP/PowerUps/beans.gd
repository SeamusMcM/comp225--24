extends RigidBody2D

var nombre = "beans"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_nombre():
	return nombre
