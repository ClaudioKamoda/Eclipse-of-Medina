extends "res://scripts/state_machine.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("attack")
	add_state("vigia")
	add_state("idle")
	add_state("touro")
	add_state("sleep")
	add_state("hurt")
	add_state("death")
	call_deferred("set_state", states.vigia)

func _input(event):
	pass

func _state_logic(delta):
	if state == states.vigia:
		parent._apply_movement()
	elif state == states.touro || state == states.hurt:
		parent._apply_touro()
	elif state == states.idle || state == states.sleep:
		parent._apply_stop()
	elif state == states.death:
		parent._apply_death()
	else:
		parent._apply_attack()
func _get_transition(delta):
	match state:

		states.vigia:
			if parent.touro:
				return states.touro
			if(parent.alvo != PhysicsBody2D):
				if parent.distance < 1200:
					if parent.distance >= 1000:
						parent.set_position(Vector2(parent.pos_x, parent.pos_y))
						parent.movedir = 1
						return states.vigia
			if parent.hurt:
				add_pilha("hurt")
				return states.hurt

		states.touro:
			if parent.touro == false:
				return states.idle
			elif parent.distance <= 60:
				return states.attack
			if parent.hurt:
				add_pilha("touro")
				return states.hurt

		states.idle:
			if parent.touro:
				return states.touro
			elif parent.distance >= 500:
				parent.movedir = 1
				return states.vigia
			if parent.hurt:
				add_pilha("idle")
				return states.hurt

		states.attack:
			if parent.distance > 60:
				parent.SwordHit.set_disabled(true)
				parent._sleep_time()
				
				if parent.sleepTime == false:
					return states.touro
			elif parent.repeat:
				parent.SwordHit.set_disabled(false)
				parent.repeat = false
			if parent.hurt:
				add_pilha("attack")
				return states.hurt

		states.hurt:
			if !(parent.hurt):
				var aux = pilha[pilha.size() - 1]
				remove_pilha()
				return states[aux]
			if parent.death:
				return states.death

		states.death:
			if parent.respawn:
				parent.set_position(Vector2(parent.pos_x, parent.pos_y))
				parent.movedir = 1
				parent.health = parent.max_health
				parent.respawn = false
				parent.death = false
				parent.collision.set_disabled(false)
				parent.visible = true
				return states.vigia


	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.vigia:
			parent.animationF = false
			parent.anim.play("Walk")

		states.touro:
			parent.animationF = false
			parent.anim.play("Run")

		states.idle:
			parent.animationF = false
			parent.anim.play("Idle")

		states.attack:
			parent.sleepTime = true
			parent.auxSleep = true
			parent.animationF = false
			parent.SwordHit.set_disabled(false)
			parent.anim.play("Attack")

		states.hurt:
			parent.animationF = false
			parent.anim.play("Hurt")

		states.death:
			parent.animationF = false
			parent.anim.play("Die")

func _exit_state(old_state, new_state):
	pass