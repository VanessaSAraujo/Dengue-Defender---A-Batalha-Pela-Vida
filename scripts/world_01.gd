extends Node2D

@onready var player := $player as CharacterBody2D
@onready var camera := $camera as Camera2D
@onready var control = $HUD/control


# Called when the node enters the scene tree for the first time.
func _ready():
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
	control.time_is_up.connect(game_over)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3
	Globals.repelente = 1
	Globals.powder = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://prefabs/game_over.tscn")
	

func game_over():
	get_tree().change_scene_to_file("res://prefabs/game_over.tscn")
