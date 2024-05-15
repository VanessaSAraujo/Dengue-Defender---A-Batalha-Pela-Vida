extends CharacterBody2D


const SPEED = 300.0
const JUMP_FORCE = -400.0
const BULLET_SCENE = preload("res://prefabs/bullet.tscn")
const BULLET_POWDER_SCENE = preload("res://prefabs/bullet_powder.tscn")
const BULLET_FUMACA_SCENE = preload("res://prefabs/bullet_fumaca.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false 
var is_hurted := false
var knockback_vector := Vector2.ZERO
var direction
var is_shooting := false
var is_repelente := false
var is_powder := false
var is_fumaca := false

@onready var animation :=$animation as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var bullet_position = $bullet_position
@onready var shoot_cooldown = $shoot_cooldown
@onready var bullet_powder_position = $bullet_powder_position
@onready var powder_cooldown = $powder_cooldown
@onready var bullet_fumaca_position = $bullet_fumaca_position
@onready var fumaca_cooldown = $fumaca_cooldown
@onready var jump_sfx = $jump_sfx as AudioStreamPlayer
@onready var shot_sfx = $shot_sfx as AudioStreamPlayer
@onready var hurt_sfx = $"hurt-sfx"
@onready var pneus = $"../pneus"





signal player_has_died()




func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
		
		
	if Input.is_action_pressed("shoot"):
		is_shooting = true
		shot_sfx.play()
		if shoot_cooldown.is_stopped():
			shoot_bullet()
	else:
		is_shooting = false
		
		
	if Input.is_action_pressed("fumaca"):
		is_fumaca = true
		shot_sfx.play()
		if fumaca_cooldown.is_stopped():
			fumaca_bullet()
	else:
		is_fumaca = false
		
		
	if Input.is_action_just_pressed("repelente"):
		if Globals.repelente > 0 and Globals.player_life < 3:
			is_repelente = true
			
	if Input.is_action_just_pressed("powder"):
		if Globals.powder > 0:
			is_powder = true
			shot_sfx.play()
			if powder_cooldown.is_stopped():
				powder_bullet()
	else:
		is_powder = false
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("ui_left"):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
			bullet_powder_position.position.x *= -1
			bullet_fumaca_position.position.x *= -1
			
	if Input.is_action_pressed("ui_right"):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
			bullet_powder_position.position.x *= -1
			bullet_fumaca_position.position.x *= -1
		
	
	if direction != 0:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if $ray_right.is_colliding():
		take_damage(Vector2(-200,-200))
	elif $ray_right2.is_colliding():
		take_damage(Vector2(-200,-200))
	elif $ray_right3.is_colliding():
		take_damage(Vector2(-200,-200))
	elif $ray_left.is_colliding():
		take_damage(Vector2(200,-200))
	elif $ray_left2.is_colliding():
		take_damage(Vector2(200,-200))
	elif $ray_left3.is_colliding():
		take_damage(Vector2(200,-200))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
#
func take_damage(knockback_force : = Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
		hurt_sfx.play()
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
		
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		if !is_shooting and !is_powder and !is_fumaca:
			state = "jump"
	elif !is_powder and !is_fumaca:
		if direction != 0 and !is_shooting:
			state = "run"
		elif !direction and is_shooting:
			state = "shoot"
		elif is_shooting or direction != 0:
			state = "run_shoot"
		elif !direction and is_repelente:
			state = "repelente"
	elif is_powder:
		if !direction:
			state = "powder"
		elif direction != 0:
			state = "run_powder"
		elif !direction and is_repelente:
			state = "repelente"
	elif is_fumaca:
		if !direction:
			state = "fumaca"
		elif direction != 0:
			state = "run_fumaca"
		elif !direction and is_repelente:
			state = "repelente"
	elif is_repelente:
		if !direction:
			state = "repelente"
	
	if is_hurted:
		state = "hurt"
	
	if animation.name != state:
		animation.play(state)

	print("State:", state)


func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else:
		bullet_instance.set_direction(-1)
		
	add_sibling(bullet_instance)
	bullet_instance.global_position = bullet_position.global_position
	shoot_cooldown.start()

func fumaca_bullet():
	var bullet_fumaca_instance = BULLET_FUMACA_SCENE.instantiate()
	
	if sign(bullet_fumaca_position.position.x) == 1:
		bullet_fumaca_instance.set_direction(1)
	else:
		bullet_fumaca_instance.set_direction(-1)
		
	add_sibling(bullet_fumaca_instance)
	bullet_fumaca_instance.global_position = bullet_fumaca_position.global_position
	fumaca_cooldown.start()

func powder_bullet():
	var bullet_powder_instance = BULLET_POWDER_SCENE.instantiate()
	
	if sign(bullet_powder_position.position.x) == 1:
		bullet_powder_instance.set_direction(1)
	else:
		bullet_powder_instance.set_direction(-1)
	
	add_child(bullet_powder_instance)
	bullet_powder_instance.global_position = bullet_powder_position.global_position
	powder_cooldown.start()

func _on_animation_animation_finished():
	if is_repelente == true:
		is_repelente = false
		Globals.player_life += 1
		Globals.repelente -= 1
	
	if is_powder == true:
		Globals.powder -= 1
