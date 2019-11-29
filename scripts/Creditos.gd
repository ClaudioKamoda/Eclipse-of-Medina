extends Node2D

func _ready():
	_on_Voltar_pressed()

func _on_Voltar_pressed():
	get_tree().change_scene("res://cenas/Interface.tscn")
