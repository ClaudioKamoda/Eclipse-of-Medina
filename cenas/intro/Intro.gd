extends TextureRect

onready var timer = $Timer
onready var text = $RichTextLabel

var i = 0
var j = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = load("res://imagens/Intro/sky.jpg")
	timer.start()


func _process(delta):
	if timer.is_stopped() || Input.is_action_just_pressed("ui_accept"):
		match(i):
			0:
				texture = load("res://imagens/Intro/hands.jpg")
				text.text = "Do amor dos deuses surgiram outros cinco deuses, esses sem poderes divinos."
				i += 1
			
			1:
				texture = load("res://imagens/Intro/forge.jpg")
				match(j):
					0:
						text.text = "Por isso, Suna ordenou que fossem forjados 4 poderosas reliquias, que dariam a qualquer criatura poderes trancendentais."
						j += 1
					1:
						text.text = "No entanto, foram forjadas apenas 4 reliquias, deixando Kasuf, alguns seculos mais novo que os outros filhos, sem nenhuma."
						j = 0
						i += 1
			
			2:
				texture = load("res://imagens/Intro/sky.jpg")
				text.text = "Milenios se passaram ate que os deuses falecessem. Mas antes, esses decidiram oferecer suas reliquias a humanidade."
				i += 1
			
			3:
				texture = load("res://imagens/Intro/king.jpg")
				match(j):
					0:
						text.text = "Aaravos, um homem puro e humilde do reino de Medina foi escolhido."
						j += 1
					1:
						text.text = "Com o auxilio das reliquias ele ascendeu ao posto mais alto do reino, tornando o lugar muito prospero."
						i += 1
						j = 0
			
			4:
				texture = load("res://imagens/Intro/lapide.jpg")
				match(j):
					0:
						text.text = "Porem, depois de anos de prosperidade do reino, Aaravos adoeceu fortemente e morreu."
						j += 1
					1: 
						text.text = "A seu pedido, suas reliquias foram escondidas em 4 lugares diferentes do reino, a fim de impedir que outros usassem-as de forma errada."
						j = 0
						i += 1
			
			5:
				texture = load("res://imagens/Intro/battle.jpg")
				match(j):
					0:
						text.text = "O que ele nao esperava era a consequencia dessa acao."
						j += 1
					1:
						text.text = "A busca pelas reliquias escondidas gerou diversas guerras por todo o reino."
						j += 1
					2:
						text.text = "Quatro grandes familias lideraram a cacada, tendo cada uma dessas encontrado uma reliquia."
						j = 0
						i += 1
			
			6:
				texture = load("res://imagens/Intro/misery.jpg")
				text.text = "Os resultados das guerras foram desastrosos para o reino, deixando muitas pessoas desabrigadas e sem alimentos."
				i += 1
			
			7:
				texture = load("res://imagens/Intro/city.png")
				text.text = "Das quatro grandes familias surgiram quatro distritos no reino, diferentes territorialmente e economicamente."
				i += 1
				
			8:
				texture = load("res://imagens/Intro/preto.png")
				text.text = "Voce comeca em rubidia."
				i += 1
			
			9:
				get_tree().change_scene("res://cenas/main.tscn")
		timer.start()
