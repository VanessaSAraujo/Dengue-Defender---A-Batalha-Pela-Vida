extends Control

@onready var start_btn = $MarginContainer/HBoxContainer/VBoxContainer/start_btn
@onready var button_sfx = $button_sfx
@onready var bg_title_sfx = $bg_title_sfx

# Called when the node enters the scene tree for the first time.
func _ready():
	start_btn.grab_focus()
	bg_title_sfx.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_pressed("ui_up"):
		button_sfx.play()
	elif Input.is_action_pressed("ui_down"):
		button_sfx.play()



func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://world_01.tscn")


func _on_credits_btn_pressed():
	get_tree().change_scene_to_file("res://prefabs/objetivos.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
