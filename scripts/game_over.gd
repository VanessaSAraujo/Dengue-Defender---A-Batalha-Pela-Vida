extends Control

@onready var restart_btn = $ColorRect/VBoxContainer/Restart_Btn
@onready var nanana_sfx = $nanana_sfx
@onready var button_sfx = $button_sfx


# Called when the node enters the scene tree for the first time.
func _ready():
	restart_btn.grab_focus()
	nanana_sfx.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if Input.is_action_pressed("ui_up"):
		button_sfx.play()
	elif Input.is_action_pressed("ui_down"):
		button_sfx.play()


func _on_restart_btn_pressed():
	get_tree().change_scene_to_file("res://prefabs/title_screen.tscn")

