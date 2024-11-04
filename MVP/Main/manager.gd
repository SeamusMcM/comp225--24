extends Node

@onready var pause_menu = $"../TextureRect/PauseMenu"
var game_pause : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		game_pause = !game_pause
		
	if game_pause == true: 
		get_tree().paused = true
		pause_menu.show()
	else: 
		get_tree().paused = false
		pause_menu.hide()



func _on_resume_pressed() -> void:
	game_pause = !game_pause


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
