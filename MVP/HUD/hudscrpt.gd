extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
#var hud = get_node("res://HUD/hud.tscn")
#var hud_scene = preload("res://HUD/hud.tscn")
#var hud = null
var p1ItemTip = false
var p2ItemTip = false

func _ready(): 
	#hud = hud_scene.instance()
	#add_child(hud)
	var global_script = get_node("/root/GlobalScript")
	hide_p1_item_box()
	hide_p2_item_box()
	hide_tips()
	if global_script:
		global_script.connect("game_over", Callable(self, "_on_game_over"))
		GlobalScript.connect("p1_points_earned",update_p1score)
		GlobalScript.connect("p2_points_earned", update_p2score)
		GlobalScript.connect("p1_item_got", display_p1_item_box)
		GlobalScript.connect("p2_item_got", display_p2_item_box)
		global_script.connect("p1_points_earned",Callable( self, "update_p1score"))
		global_script.connect("p2_points_earned", Callable(self, "update_p2score"))
		GlobalScript.connect("p1_mysterybox_opened", p1_show_reward)
		GlobalScript.connect("p2_mysterybox_opened", p2_show_reward)
		#GlobalScript.connect("points_earned", hud, "update_p2score")

func _process(float) -> void:
	if Input.is_action_pressed("p1_item") && GlobalScript.get_p1_item() != "mystery_reward":
		hide_p1_item_box()
	if Input.is_action_pressed("p2_item")  && GlobalScript.get_p2_item() != "mystery_reward":
		hide_p2_item_box()

func _on_game_over():
	#$main._game_over()
	var global_script = get_node("/root/GlobalScript")
	if global_script:
		var p1_score=global_script._get_p1_points()
		var p2_score=global_script._get_p2_points()
		
		if p1_score>p2_score:
			
			show_message("Player 1 Wins!")
			#$main._game_over()
			
		elif p1_score<p2_score:
			#$main._game_over()
			show_message("Player 2 Wins!")
		else:
			#$main._game_over()
			show_message("It's a Tie!")
		
	await get_tree().create_timer(3.0).timeout	
	$StartButton.show()
	hide_p1_item_box()
	hide_p2_item_box()
	hide_tips()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	
	#$LoadScreen.show()
	#add logic here for which player has highest score? TODO
	#$main._game_over()
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout

	
func update_p1score(score):
	$P1ScoreLabel.text = "P1: " + str(score)
	

func update_p2score(score: int):
	$P2ScoreLabel.text = "P2: " + str(score)
	
#print_tree()

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
	if p1ItemTip == false:
		$PressLabel.show()
		$LeftButtonLabel.show()
		$LeftWhiteArrow.show()
		p1ItemTip = true
	if item == "shield":
		$P1ShieldCapsule.show()
	if item == "beans":
		$P1Beans.show()
	if item == "mysterybox":
		$P1MysteryBox.animation = "default"
		$P1MysteryBox.show()
		$P1MysteryBox.play()

func display_p2_item_box(item):
	if p2ItemTip == false:
		$PressLabel.show()
		$RightButtonLabel.show()
		$RightWhiteArrow.show()
		p2ItemTip = true
	if item == "shield":
		$P2ShieldCapsule.show()
	if item == "beans":
		$P2Beans.show()
	if item == "mysterybox":
		$P2MysteryBox.animation = "default"
		$P2MysteryBox.show()
		$P2MysteryBox.play()

func hide_p1_item_box():
	$P1ShieldCapsule.hide()
	$P1Beans.hide()
	$P1MysteryBox.hide()
	$P1MysteryBox.stop()

func hide_p2_item_box():
	$P2ShieldCapsule.hide()
	$P2Beans.hide()
	$P2MysteryBox.hide()
	$P2MysteryBox.stop()

func p1_show_reward(reward):
	if reward == "plus_50":
		$P1MysteryBox.animation = "plus_50"
	if reward == "plus_100":
		$P1MysteryBox.animation = "plus_100"
	if reward == "plus_500":
		$P1MysteryBox.animation = "plus_500"
	if reward == "minus_100":
		$P1MysteryBox.animation = "minus_100"
	if reward == "minus_500":
		$P1MysteryBox.animation = "minus_500"
	if reward == "hide":
		$P1MysteryBox.hide()
	else:
		$P1MysteryBox.play()
		$P1MysteryBox.show()
		$P1RewardTimer.start()

func p2_show_reward(reward):
	if reward == "plus_50":
		$P2MysteryBox.animation = "plus_50"
	if reward == "plus_100":
		$P2MysteryBox.animation = "plus_100"
	if reward == "plus_500":
		$P2MysteryBox.animation = "plus_500"
	if reward == "minus_100":
		$P2MysteryBox.animation = "minus_100"
	if reward == "minus_500":
		$P2MysteryBox.animation = "minus_500"
	if reward == "hide":
		$P2MysteryBox.hide()
	else:
		$P2MysteryBox.play()
		$P2MysteryBox.show()
		$P2RewardTimer.start()

func _on_p_1_reward_timer_timeout() -> void:
	GlobalScript.set_p1_item("none")
	$P1MysteryBox.stop()
	$P1MysteryBox.hide()
	$P1RewardTimer.stop()

func _on_p_2_reward_timer_timeout() -> void:
	GlobalScript.set_p2_item("none")
	$P2MysteryBox.stop()
	$P2MysteryBox.hide()
	$P2RewardTimer.stop()

func hide_tips():
	$PressLabel.hide()
	$LeftButtonLabel.hide()
	$RightButtonLabel.hide()
	$LeftWhiteArrow.hide()
	$RightWhiteArrow.hide()
