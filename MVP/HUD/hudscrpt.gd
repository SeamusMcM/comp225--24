extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
#var hud = get_node("res://HUD/hud.tscn")
#var hud_scene = preload("res://HUD/hud.tscn")
#var hud = null

func _ready():
	#hud = hud_scene.instance()
	#add_child(hud)
	var global_script = get_node("/root/GlobalScript")
	$P1ShieldCapsule.hide()
	$P2ShieldCapsule.hide()
	if global_script:
		global_script.connect("game_over", Callable(self, "_on_game_over"))
		GlobalScript.connect("p1_points_earned",update_p1score)
		GlobalScript.connect("p2_points_earned", update_p2score)
		GlobalScript.connect("p1_item_got", display_p1_item_box)
		GlobalScript.connect("p2_item_got", display_p2_item_box)
		#GlobalScript.connect("points_earned", hud, "update_p2score")

func _process(float) -> void:
	if Input.is_action_pressed("p1_item"):
		hide_p1_item_box()
	if Input.is_action_pressed("p2_item"):
		hide_p2_item_box()

func _on_game_over():
	var global_script = get_node("/root/GlobalScript")
	if global_script:
		var p1_score=global_script._get_p1_points()
		var p2_score=global_script._get_p2_points()
		
		if p1_score>p2_score:
			show_message("Player 1 Wins!")
		elif p1_score<p2_score:
			show_message("Player 2 Wins!")
		else:
			show_message("It's a Tie!")
	await get_tree().create_timer(3.0).timeout	
	$StartButton.show()
	
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

	
func update_p1score(score):
	$P1ScoreLabel.text = "P1: " + str(score)
	

func update_p2score(score: int):
	$P2ScoreLabel.text = "P2: " + str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	show_message("Get Ready!")
	
	await get_tree().create_timer(1.5).timeout
	AudioController.play_countdown()
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

func display_p1_item_box(item):
	if item == "shield":
		$P1ShieldCapsule.show()

func display_p2_item_box(item):
	if item == "shield":
		$P2ShieldCapsule.show()

func hide_p1_item_box():
	$P1ShieldCapsule.hide()

func hide_p2_item_box():
	$P2ShieldCapsule.hide()
