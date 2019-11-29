extends Area2D

export (String) var ProxCena
export (String) var Lugar
onready var Label = $Label

func _ready():
	pass

func _on_EntraTemplo_body_entered(body):
	if body.name == "player":
		Label.percent_visible = 1
	else: 
		Label.percent_visible = 0

func _on_EntraTemplo_body_exited(body):
	if body.name == "player":
		Label.percent_visible = 0

func _input(event):
	if Label.percent_visible == 1 && Input.is_action_pressed("entrar"):
		$FadeIn.show()
		$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	if Lugar == "Rubidia":
		Global.Position = Vector2(1696, 543)
	elif Lugar == "Industria":
		print("oi")
	elif Lugar == "Planalto":
		print("oi")
	get_tree().change_scene(ProxCena)
