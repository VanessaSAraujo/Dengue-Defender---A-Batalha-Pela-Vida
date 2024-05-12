extends Control

@onready var start_btn = $MarginContainer/HBoxContainer/VBoxContainer/start_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	start_btn.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://world_01.tscn")


func _on_credits_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
