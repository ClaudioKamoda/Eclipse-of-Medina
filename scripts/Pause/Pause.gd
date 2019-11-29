extends Control

onready var player = get_parent().get_node("player")

func _input(event):
	if event.is_action_pressed("pause"):
		if player.game_over.get_visible_characters() == 0:
			player.game_over.set_visible_characters(-1)
		else:
			player.game_over.set_visible_characters(0)
		visible = not visible
		get_tree().paused = not get_tree().paused
		