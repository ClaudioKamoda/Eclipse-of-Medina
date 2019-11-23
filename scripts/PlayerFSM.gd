extends "res://scripts/state_machine.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("parado")
	add_state("run")
	add_state("jump")
	add_state("attack")
	add_state("double_jump")
	add_state("fall")
	call_deferred("set_state", states.parado)

func _input(event):
	if [states.parado, states.run, states.attack].has(state):    #pulo simples
		if event.is_action_pressed("jump") && pilha.size() == 0:
			parent.velocity.y = -parent.JUMP_SPEED    #joga pra cima
			add_pilha("jump") #adiciona o pulo na pilha
			
	if [states.jump, states.attack, states.fall].has(state):   #pulo duplo
		if event.is_action_pressed("jump") && pilha.size() == 1 && parent.double_jump:
			parent.velocity.y = -parent.JUMP_SPEED    #joga pra cima
			add_pilha("double_jump")
			
	if [states.parado, states.run, states.jump, states.double_jump, states.fall, states.attack].has(state):  #quando aperta o dash entra no estado de run e aumenta o speed
		if event.is_action_pressed("dash") && parent.dash && parent.wait_dash == false:
			parent.do_dash = true
			if(parent.anim.flip_h == true):
				parent.movedir = -1
			if(parent.anim.flip_h == false):
				parent.movedir = 1
			parent.SPEED += 800
			parent.timer_dash.start()
			
	if [states.parado, states.run, states.jump, states.double_jump, states.fall].has(state):  #primeiro ataque
		if event.is_action_pressed("attack"):
			parent.attack = true
			parent.SwordHit.set_disabled(false)
			
	if [states.attack].has(state):    #verifica a continuação do ataque
		if event.is_action_pressed("attack") && parent.timer_attack.time_left > 0:  # se apertou pra atacar e o tempo do primeiro ataque nao passou, dá o segundo ataque
			parent.attacking = true
			parent.anim.playing = true  #coloca a animação pra continuar

func _state_logic(delta):
	parent._apply_movement()

func _get_transition(delta):
	print(state)
	match state:

		states.parado:
			if parent.do_dash == true: #se mandar fazer o dash enquanto estiver parado, muda para o estado run
				return states.run
			if !parent.is_on_floor():  #se nao tiver no chão verifica se está pulando ou caindo
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0: #se tiver em movimento muda para o run
				return states.run
			if parent.attack:  # se apertar para atacar muda para attack
				return states.attack

		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.parado
			if parent.attack:
				return states.attack

		states.jump:
			if parent.velocity.y > 0:  #se começar a cair muda para o estado fall
				return states.fall
			elif parent.double_jump:  #se não estiver no chão chama o double_jump
				if pilha.size() == 2:
					return states.double_jump
			if parent.attack:
				return states.attack

		states.double_jump:
			if parent.velocity.y > 0:  #se começar a cair muda para o estado fall
				return states.fall
			if parent.attack:
				return states.attack
				
		states.fall:
			if parent.is_on_floor():  #se cair no chão acaba o fall
				return states.parado
			elif parent.double_jump:  #se o double_jump estiver ativado
				if pilha.size() == 2 && parent.velocity.y < 0:
					return states.double_jump
			if parent.attack:
				return states.attack

		states.attack:
			if parent.attack == false:  #se não estiver atacando muda para parado
				parent.SwordHit.set_disabled(true)
				if !parent.is_on_floor():
					return states.fall
				elif parent.velocity.x == 0:
					return states.parado
				else:
					return states.run
			if(!parent.attacking):  # se não estiver no segundo ataque
				parent.SwordHit.set_disabled(true)
				if parent.anim.frame > 2:  #verifica em qual frame está, mais do que 2 pausa o ataque
					parent.anim.playing = false  #pausa a animação

	return null

func _enter_state(new_state, old_state):
	#print(new_state)
	match new_state:
		states.parado:
			parent.anim.play("Parado")
			if(pilha.size() > 0):
				remove_pilha()
				remove_pilha()
			
		states.run:
			parent.anim.play("Corrida")
			if(pilha.size() > 0):
				remove_pilha()
				remove_pilha()
			
		states.jump:
			parent.anim.play("Pulo")
			
		states.double_jump:
			parent.anim.play("Pulo Duplo")
			
		states.fall:
			parent.anim.play("Caindo")
			
		states.attack:
			parent.timer_attack.start()  #tempo para apertar novamente o ataque e continuar o combo
			parent.anim.play("Atacar")

func _exit_state(old_state, new_state):
	pass