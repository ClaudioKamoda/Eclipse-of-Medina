extends "res://scripts/state_machine.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("parado")
	add_state("run")
	add_state("jump")
	add_state("dash")
	call_deferred("set_state", states.parado)

func _input(event):
	if [states.parado, states.run].has(state):
		if event.is_action_pressed("ui_up"):
			parent.velocity.y = -parent.JUMP_SPEED

func _state_logic(delta):
	parent._apply_movement()

func _get_transition(delta):
	print(state)
	match state:
		states.parado:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
			elif parent.velocity.x == 0:
				return states.parado
		states.jump:
			if parent.is_on_floor():
				return states.parado
				
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.parado:
			parent.anim.play("Parado")
			
		states.run:
			if(parent.anim.flip_h == true):
				parent.anim.offset.x = 15
				parent.anim.flip_h = false
			else:
				parent.anim.offset.x = -22
				parent.anim.flip_h = true
			
			parent.anim.play("Corrida")
			
		states.jump:
			parent.anim.play("Pulo")
			

func _exit_state(old_state, new_state):
	pass