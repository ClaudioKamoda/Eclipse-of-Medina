extends Control

onready var player = get_parent()

func _input(event):
	if event.is_action_pressed("pause"):
		if player.pause.get_visible_characters() == 0:
			player.pause.set_visible_characters(-1)
		else:
			player.pause.set_visible_characters(0)
		if player.black_overlay.visible == false:
			player.black_overlay.visible = true
		else:
			player.black_overlay.visible = false
		get_tree().paused = not get_tree().paused
		