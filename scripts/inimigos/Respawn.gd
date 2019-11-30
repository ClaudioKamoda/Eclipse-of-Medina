extends Area2D

signal respawnded()

onready var enemy1 = get_parent().get_node('enemy1')
onready var enemy2 = get_parent().get_node('enemy2')
onready var player = get_parent().get_node('player')
var respawn = false
var enemy

func _ready():
	pass # Replace with function body.

func _process(delta):
	if respawn == true && (player.global_position - enemy.global_position).length() > 1500:
		add_child(enemy)
		emit_signal("respawnded")
		respawn = false

func _on_enemy_killed(number):
	respawn = true
	match number:
		1:
			enemy = enemy1
		2:
			enemy = enemy2
	
	remove_child(enemy)