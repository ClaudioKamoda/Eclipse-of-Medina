extends Area2D

signal respawnded(player_position)

onready var enemy1 = get_parent().get_node('enemy1')
onready var enemy2 = get_parent().get_node('enemy2')
onready var enemy3 = get_parent().get_node('enemy3')
onready var enemy4 = get_parent().get_node('enemy4')
onready var enemy5 = get_parent().get_node('enemy5')
onready var player = get_parent().get_node('player')
var enemyaux
var enemy
var enemyList = []

func _ready():
	pass # Replace with function body.

func _process(delta):
	for enemyaux in enemyList:
		if (player.global_position - enemyaux.global_position).length() > 1500:
			add_child(enemy)
			enemyList.erase(enemy)
			emit_signal("respawnded", player.global_position)

func _on_enemy_killed(number):
	match number:
		1:
			enemyList.append(enemy1)
			enemy = enemy1
		2:
			enemyList.append(enemy2)
			enemy = enemy2
		3:
			enemyList.append(enemy3)
			enemy = enemy3
		4:
			enemyList.append(enemy4)
			enemy = enemy4
		5:
			enemyList.append(enemy5)
			enemy = enemy5
	
	remove_child(enemy)

