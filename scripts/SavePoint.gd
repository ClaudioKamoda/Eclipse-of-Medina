extends Label

func _ready():
	#verifica_save(event)
	pass

func _on_SavePoint_body_entered(body):
	if body.name == "player":
		percent_visible = 1
	else: 
		percent_visible = 0

func _on_SavePoint_body_exited(body):
	if body.name == "player":
		percent_visible = 0

func _input(event):
	if percent_visible == 1 && event.is_action_pressed("save"):
		Save.save_game()
	