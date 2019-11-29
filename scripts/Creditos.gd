extends Node2D

func _ready():
	pass

func _on_Voltar_pressed():
	get_tree().change_scene("res://cenas/TitleScreen/Interface.tscn")
