extends CharacterBody2D


const SPEED = 800.0
const FLY_FORCE = 100.0  # Força para voar

@onready var texture := $texture as Sprite2D
@onready var anim:= $anim as AnimationPlayer

var direction := -1
var is_flying := true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.y = -FLY_FORCE * delta
	velocity.x = direction * SPEED * delta

		
		
	move_and_slide()


func _ready() -> void:
	set_physics_process(true)


func _fixed_process(delta: float) -> void:
	# Change direction when reaching boundaries
	if position.x <= 100:
		direction = 1
	elif position.x >= 700:
		direction = -1


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
