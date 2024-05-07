extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $RayCast2D as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var anim := $anim as AnimationPlayer

var direction := -1

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:    

	if is_on_floor():
		velocity.y += gravity * delta * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction ==1:
		texture.flip_h = true
	else:
		texture.flip_h = false

	velocity.x = direction * SPEED * delta

	move_and_slide()


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		Globals.score += 100
		queue_free()
