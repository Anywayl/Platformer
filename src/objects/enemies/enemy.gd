extends Node

@export var HP = 1
@export var SPEED = 1
@export var DAMAGE = 1

func _on_enemy_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("swordArea"):
		onHit()
		
func onHit(): 
	pass
	
func die():
	pass
