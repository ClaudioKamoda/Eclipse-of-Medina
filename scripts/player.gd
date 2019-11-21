extends KinematicBody2D

export (NodePath) var timerPath
export (NodePath) var timerWaitPath
export (NodePath) var timerAttackPath
export (NodePath) var AnimatedSpritePath

onready var anim = get_node(AnimatedSpritePath)
onready var timer_dash = get_node(timerPath)
onready var timer_wait = get_node(timerWaitPath)
onready var timer_attack = get_node(timerAttackPath)
onready var SwordHit = get_node("AnimatedSprite/SwordHit/SwordHit")
onready var Particles = get_node("AnimatedSprite/SwordHit/Particles2D")
onready var Particles2 = get_node("AnimatedSprite/SwordHit/Particles2D2")


# Variáveis setadas externamente (são bem importantes)

export (float) var SPEED = 200
export (float) var JUMP_SPEED = 1000
export (float) var GRAVITY = 50
export (float) var DASH_SPEED = 1000
export (bool) var double_jump = false
export (bool) var dash = false


# Variáveis auxiliares

var movedir = 0
var velocity = Vector2(0,0)
var do_dash = false
var wait_dash = false
var done_double = false
var attack = false
var attacking = false


#Variáveis da câmera

func _ready():
	pass

    #Atualiza todo momento
func _physics_process(delta):
	
	#Em qualquer estado, faz o flip do sprite, collision do ataque e partículas
	if(movedir > 0):              
		if(anim.flip_h == true):
			anim.offset.x = 15
			anim.flip_h = false
			SwordHit.position.x = 22
			Particles.position.x = 25.65
			Particles2.position.x = 25.65
	elif(movedir < 0):
		if(anim.flip_h == false):
			anim.offset.x = -22
			anim.flip_h = true
			SwordHit.position.x = -27.15
			Particles.position.x = -30.8
			Particles2.position.x = -30.8

	
	#Movimento do player
func _apply_movement():
	
	if do_dash == false:
		movedir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))


    #Contadores
func _on_Timer_timeout(): #timer_dash
	SPEED = 200
	do_dash = false
	wait_dash = true
	timer_wait.start()
	
func _on_timer_wait_timeout():  #tempo para dar o dash novamente
	wait_dash = false
	
func _on_timer_attack_timeout():
	if !attacking:
		attack = false

   #Ataque
func _on_AnimatedSprite_animation_finished():
	attack = false
	attacking = false

func _on_SwordHit_area_entered(area):
	if area.is_in_group("hurtbox"):
		if(Particles.is_emitting()):
			print("Damage2")
			Particles2.set_emitting(true)
		else:
			print("Damage")
			Particles.set_emitting(true)
		
	

func save():
	var save_dict = {
		pos = {
			x = get_pos().x,
			y = get_pos().y
		}
	}
	return save_dict