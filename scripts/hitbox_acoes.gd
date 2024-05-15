extends Area2D

@onready var hurt_pneu = $"../hurt_pneu"

@export var actions_score := 150




func _on_area_entered(area):
	if area.is_in_group("bullet_powder"):
		if Globals.powder > 0:
			hurt_pneu.visible = true
			area.queue_free()
			Globals.score += actions_score
			Globals.coins += 1
			Globals.powder -= 1
		owner.queue_free()
