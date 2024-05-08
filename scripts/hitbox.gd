extends Area2D

@export var enemy_score := 100

func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.velocity.y = body.JUMP_FORCE
		owner.anim.play("hurt")
		Globals.score += enemy_score
		owner.queue_free()
