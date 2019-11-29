extends Label

func _ready():
	pass

func _on_EntraTemplo_body_entered(body):
	if body.name == "player":
		percent_visible = 1
	else: 
		percent_visible = 0


func _on_EntraTemplo_body_exited(body):
	if body.name == "player":
		percent_visible = 0

func _input(event):
	if percent_visible == 1 && event.is_action_pressed("entrar"):
		get_tree().change_scene("res://cenas/TitleScreen/Interface.tscn")