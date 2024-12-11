extends Node2D

var background_music
var pitch_increment = 0.01  # Change in pitch scale per update
var max_pitch_scale = 2.0   # Maximum pitch scale to prevent it from speeding up too much


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music=$background_music
	#background_music.play() 
	set_process(true)  # Enable processing to gradually change speed



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if background_music.playing:
		if background_music.pitch_scale<max_pitch_scale:
			background_music.pitch_scale += pitch_increment * delta
func play_music()-> void:
	background_music.play()
	background_music.pitch_scale = 1.0  # Reset pitch scale to normal speed when starting


func play_end_level()-> void:
	background_music.stop()
	$endgame.play()

func play_horse_pedaling()->void:
	$Horse_pedaling.play()

func play_bleat()-> void:
	$bleat.play()

func play_countdown()-> void:
	$countdown.play()

func play_shield()-> void:
	$shield.play()

func stop_shield() -> void:
	if $shield.playing:
		$shield.stop()
	
func play_mudsound()-> void:
	$mudsound.play()
