extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DifficultyLabel.text = "Difficulty: 1"
	$DifficultyLabel.position = Vector2(200, 100)  # 或者您想要的任何默认值
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Collect the Food!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_points(points):
	$PointLabel.text = str(points)

func show_difficulty(difficulty_level: int) -> void:
	if $DifficultyLabel:
		$DifficultyLabel.text = "Difficulty: " + str(difficulty_level)
	else:
		print("DifficultyLabel not found!")
	print("Setting difficulty to:", difficulty_level)



func _on_start_button_pressed() -> void:
	$StartButton.hide()
	show_difficulty(1)
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
	
