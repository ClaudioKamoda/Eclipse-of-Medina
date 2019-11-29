extends Node2D

onready var camera = $player/Camera2D

func _ready():
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_bottom = 600
	camera.limit_right = 1728