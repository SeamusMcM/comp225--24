extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
#var hud = get_node("res://HUD/hud.tscn")
#var hud_scene = preload("res://HUD/hud.tscn")
#var hud = null

func _ready():
	#hud = hud_scene.instance()
	#add_child(hud)
	GlobalScript.connect("p1_points_earned", update_p1score)
	GlobalScript.connect("p2_points_earned", update_p2score)
	#GlobalScript.connect("points_earned", hud, "update_p2score")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	#$LoadScreen.show()
	#add logic here for which player has highest score? TODO
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_p1score(score):
	$P1ScoreLabel.text = "P1: " + str(score)

func update_p2score(score: int):
	$P2ScoreLabel.text = "P2: " + str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	show_message("Get Ready!")
	
	await get_tree().create_timer(1.5).timeout
	show_message("3")

	await $MessageTimer.timeout
	show_message("2")
	
	await $MessageTimer.timeout
	show_message("1")
	
	await $MessageTimer.timeout
	show_message("Go!")
	
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
	#$HUD.update_score(score)
