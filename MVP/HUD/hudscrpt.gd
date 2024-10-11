extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	#add logic here for which player has highest score? TODO
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Lets Race!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	show_message("Get Ready!")
	await get_tree().create_timer(0.5).timeout
	show_message("3")
	await get_tree().create_timer(1.0).timeout
	show_message("2")
	await get_tree().create_timer(1.0).timeout
	show_message("1")
	await get_tree().create_timer(1.0).timeout
	show_message("Go!")
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
