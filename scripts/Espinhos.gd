extends Area2D

func _on_Espinhos_body_entered(body):
	if body.name == "player":
		body.damage(10)
