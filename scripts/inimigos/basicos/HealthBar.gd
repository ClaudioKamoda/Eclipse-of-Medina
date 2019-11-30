extends TextureProgress

export (Color) var green = Color.green
export (Color) var yellow = Color.yellow
export (Color) var red = Color.red
export (float, 0, 1, 0.05) var yellow_zone = 0.5
export (float, 0, 1, 0.05) var red_zone = 0.2

func _on_max_health_updated(max_health):
	max_value = max_health

func _on_health_enemy_updated(health, amount):
	value = health
	
	_assign_color(health)

func _assign_color(health):
	if health <= max_value * red_zone:
		tint_progress = red
	elif health <= max_value * yellow_zone:
		tint_progress = yellow
	else:
		tint_progress = green