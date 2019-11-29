extends Control

const SAVE_PATH = "res://save.json"

var scene_path_to_load
var nome_botao
var save_file = File.new()

func _ready():
	for button in $Menu/HBoxContainer/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.botao])
	

func _on_Button_pressed(scene_to_load, botao):
	scene_path_to_load = scene_to_load
	nome_botao = botao
	
	if(nome_botao == "Continuar" && not save_file.file_exists(SAVE_PATH)):
		return
	
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	
	if(nome_botao == "Continuar" && save_file.file_exists(SAVE_PATH)):
		Save.load_game()
		
	get_tree().change_scene(scene_path_to_load)
