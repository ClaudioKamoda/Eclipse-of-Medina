extends TextureProgress


func _on_max_health_updated(max_health):
	max_value = max_health

func _on_health_enemy_updated(health, amount):
	value = health
