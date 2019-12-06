extends Area2D

onready var timer = $Timer
var option
var jogador

func _on_Acido_body_entered(body):
	if body.name == "player" && Global.checkpoint == 1:
		option = 2
		jogador = body
		body.damage(10)
		timer.start()
	elif body.name == "player" && Global.checkpoint == 2:
		option = 1
		jogador = body
		body.damage(10)
		timer.start()
	elif body.name == "player" && Global.checkpoint == 3:
		option = 3
		jogador = body
		body.damage(10)
		timer.start()

func _on_Timer_timeout():
	if option == 1:
		jogador.position = Vector2(-900, 543)
	elif option == 2:
		jogador.position = Vector2(-2050, -480)
	else:
		jogador.position = Vector2(-1000, 2740)
