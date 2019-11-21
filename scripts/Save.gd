extends Node

const SAVE_PATH = "res://save.json"

func _ready():
	load_game()

func save_game():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	
	save_file.store_line(save_dict.to_json())
	
	save_file.close()
	pass

func load_game():
	pass
