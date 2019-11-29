extends Area2D

signal health_updated

onready var label = $Label

func _ready():
	#verifica_save(event)
	pass

func _on_SavePoint_body_entered(body):
	if body.name == "player":
		label.percent_visible = 1
	else: 
		label.percent_visible = 0

func _on_SavePoint_body_exited(body):
	if body.name == "player":
		label.percent_visible = 0

func _input(event):
	if label.percent_visible == 1 && event.is_action_pressed("save"):
		Global.Health = Global.Max_Health
		emit_signal("health_updated", Global.Health, Global.Health)
		Save.save_game()
	