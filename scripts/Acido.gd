extends Area2D

onready var timer = $Timer
var option
var jogador

func _on_Acido_body_entered(body):
	if body.name == "player" && Global.checkpoint2 == true:
		option = 2
		jogador = body
		body.damage(10)
		timer.start()
	elif body.name == "player" && Global.checkpoint1 == true:
		option = 1
		jogador = body
		body.damage(10)
		timer.start()

func _on_Timer_timeout():
	if option == 1:
		jogador.position = Vector2(-900, 543)
	else:
		jogador.position = Vector2(-2050, -480)
