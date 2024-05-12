extends Area2D

@onready var transition = $"../transition"
#depois alterar o nome dessa var next_level, apenas para testes
@export var next_level : String = ""


func _on_body_entered(body):
	if body.name == "player" and !next_level == "":
		transition.change_scene(next_level)
	else:
		print("no scene loaded")
