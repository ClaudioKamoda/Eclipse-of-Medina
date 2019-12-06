extends Area2D

func _on_Area2D_body_entered(body):
	if(body.name == "player"):
		Global.Position = Global.pos_Rubidia
		get_tree().change_scene("res://cenas/main.tscn")
