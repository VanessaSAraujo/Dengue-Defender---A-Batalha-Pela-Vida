extends CharacterBody2D


const SPEED = 600.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var ground_check = $ground_check
@onready var anim := $anim as AnimationPlayer

#@export var enemy_score := 100

var direction := -1

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:    

	if is_on_floor():
		velocity.y += gravity * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction ==1:
		texture.flip_h = true
	else:
		texture.flip_h = false
		
	
	if !ground_check.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	velocity.x = direction * SPEED * delta

	move_and_slide()



func _on_anim_animation_finished(anim_name:StringName):
	if anim_name == "hurt":
		#Globals.score += enemy_score
		queue_free()

