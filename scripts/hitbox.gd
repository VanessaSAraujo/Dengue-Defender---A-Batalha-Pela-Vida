extends Area2D

@export var enemy_score := 100


func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		body.velocity.y = body.JUMP_FORCE
		Globals.score += enemy_score
		owner.queue_free()


func _on_area_entered(area):
	if area.is_in_group("bullets"):
		area.queue_free()
		Globals.score += enemy_score
		owner.queue_free()

