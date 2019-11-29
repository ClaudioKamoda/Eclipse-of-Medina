extends KinematicBody2D


onready var anim = $AnimatedSprite
onready var SwordHit = get_node("AnimatedSprite/SwordHit/Sword")
onready var turn = $Turn
onready var wait_attack = $Attack
onready var sleep = $Sleep


# Variáveis setadas externamente (são bem importantes)

export (float) var SPEED = 100
export (float) var JUMP_SPEED = 730
export (float) var GRAVITY = 30
export (float) var pos_x = -869.058  #posições de restart
export (float) var pos_y = 1893.475
export (int) var damage = 10


# Variáveis auxiliares

var movedir = 1
var velocity = Vector2(0,0)
var touro = false
var alvo = PhysicsBody2D
var virar = true
var repeatAtk = false
var repeat = false
var direction = Vector2()
var animationF = false
var sleepTime = false
var auxSleep = false
var distance = 0

func _ready():
	pass

    #Atualiza todo momento
func _physics_process(delta):
	if(alvo != PhysicsBody2D):
		distance = (alvo.global_position - global_position).length()
	
	#Em qualquer estado, faz o flip do sprite, collision do ataque e partículas
	if(movedir > 0):              
		if(anim.flip_h == true):
			anim.flip_h = false
			SwordHit.position.x = 275.35

	elif(movedir < 0):
		if(anim.flip_h == false):
			anim.flip_h = true
			SwordHit.position.x = -275.35

	
	#Movimento do player
func _apply_movement():  #estado de vigia
	
	if virar:
		turn.start()
		virar = false
	
	if turn.time_left < 0.1:
		movedir *= -1
		virar = true
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _apply_touro():  #estado de touro
	direction = (alvo.global_position - global_position).normalized()
	movedir = direction.x
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
func _apply_attack():  #estado de ataque
	if !repeatAtk:
		SwordHit.set_disabled(true)
		wait_attack.start()
		repeatAtk = true

	if wait_attack.time_left < 0.05:
		animationF = false
		anim.play("Attack")
		repeatAtk = false
		repeat = true
		
	if(animationF == true):
		anim.play("Idle")


func _apply_stop():  #estado de idle
	movedir = 0
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))


func _sleep_time():   #faz o inimigo parar por um tempo
	if(auxSleep):
		sleep.start()
		auxSleep = false
	if sleep.time_left < 0.05:
		sleepTime = false


func _on_SwordHit_body_entered(body):
	if body.is_in_group("player"):
		body.damage(damage) #dano no player


func _on_Detecta_body_entered(body):
	if body.is_in_group("player"):
		touro = true
		alvo = body


func _on_Detecta_body_exited(body):
	if body.is_in_group("player"):
		touro = false


func _on_AnimatedSprite_animation_finished():
	animationF = true
