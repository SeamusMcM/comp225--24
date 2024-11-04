extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#Start Button
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")

#Option Button
func _on_option_button_pressed() -> void:
	#var options = load()
	pass
	
#Quit Button
func _on_quit_button_pressed() -> void:
	get_tree().quit()
