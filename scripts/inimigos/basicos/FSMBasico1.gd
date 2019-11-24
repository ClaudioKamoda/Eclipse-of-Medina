extends "res://scripts/state_machine.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("attack")
	add_state("vigia")
	add_state("idle")
	add_state("touro")
	call_deferred("set_state", states.vigia)

func _input(event):
	pass

func _state_logic(delta):
	if state == states.vigia:
		parent._apply_movement()
	elif state == states.touro:
		parent._apply_touro()
	elif state == states.idle:
		parent._apply_stop()
	else:
		parent._apply_attack()

func _get_transition(delta):
	match state:

		states.vigia:
			if parent.touro:
				return states.touro

		states.touro:
			if parent.touro == false:
				return states.idle
			elif (parent.alvo.global_position - parent.global_position).length() <= 60:
				return states.attack

		states.idle:
			if parent.touro:
				return states.touro
			if (parent.alvo.global_position - parent.global_position).length() >= 1000:
				parent.set_position(Vector2(parent.pos_x, parent.pos_y))
				parent.movedir = 1
				return states.vigia
			if (parent.alvo.global_position - parent.global_position).length() >= 500:
				parent.movedir = 1
				return states.vigia

		states.attack:
			if (parent.alvo.global_position - parent.global_position).length() > 60:
				parent.SwordHit.set_disabled(true)
				parent._sleep_time()
				
				if parent.sleepTime == false:
					return states.touro
			elif parent.repeat:
				parent.SwordHit.set_disabled(false)
				parent.repeat = false


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

func _exit_state(old_state, new_state):
	pass