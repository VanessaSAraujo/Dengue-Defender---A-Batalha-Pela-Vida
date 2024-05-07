extends Area2D



func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.velocity.y = body.JUMP_FORCE
		owner.anim.play("hurt")
		owner.queue_free()
