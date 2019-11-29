extends Node

onready var health_bar = $player/HealthBar
onready var player = $player


func _ready():
	 player.connect("health_updated", health_bar, "_on_health_updated")
	
