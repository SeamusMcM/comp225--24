extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func play_music()-> void:
	$background_music.play()

func play_end_level()-> void:
	$background_music.stop()
	$endgame.play()

func play_horse_pedaling()->void:
	$Horse_pedaling.play()

func play_bleat()-> void:
	$bleat.play()
	
	
