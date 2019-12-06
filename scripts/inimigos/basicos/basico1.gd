extends KinematicBody2D

signal health_enemy_updated(health, amount)
signal enemy_killed(number)

onready var anim = $AnimatedSprite
onready var SwordHit = get_node("AnimatedSprite/SwordHit/Sword")
onready var turn = $Turn
onready var wait_attack = $Attack
onready var sleep = $Sleep
onready var collision = $CollisionShape2D
onready var delay_timer = $Delay


# Variáveis setadas externamente (são bem importantes)

export (float) var SPEED = 100
export (float) var JUMP_SPEED = 730
export (float) var GRAVITY = 30
export (float) var pos_x = -869.058  #posições de restart
export (float) var pos_y = 1893.475
export (int) var damage = 10
export (int) var max_health = 3
export (int) var number_enemy

onready var health = max_health setget _set_health


# Variáveis auxiliares

var movedir = 1
var velocity = Vector2(0,0)
var touro = false
var alvo = PhysicsBody2D
var virar = true
var direction = Vector2()
var animationF = false
var distance = 0
var hurt = false
var death = false
var respawn = false
var delay = false


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
	
	if direction.x > 0 && movedir < 0 && !delay || direction.x < 0 && movedir > 0 && !delay:
		anim.play("Idle")
		delay = true
		delay_timer.start()

	if delay_timer.is_stopped():
		anim.play("Run")
		movedir = direction.x
		velocity.x = movedir * SPEED
		velocity.y += GRAVITY
		
		delay = false

		velocity = move_and_slide(velocity, Vector2(0,-1))



func _apply_attack():  #estado de ataque
	direction = (alvo.global_position - global_position).normalized()
	movedir = direction.x
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))


func _apply_stop():  #estado de idle
	movedir = 0
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _apply_death():  #estado de idle
	velocity.x = 0
	velocity.y = 0
	
	velocity = move_and_slide(velocity, Vector2(0,-1))


func _sleep_time():   #faz o inimigo parar por um tempo
	if(sleep.is_stopped()):
		sleep.start()


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
	hurt = false
	if death:
		kill()
	
func damage_enemy(amount):
	_set_health(health - amount)

func kill():
	emit_signal("enemy_killed", number_enemy)
	collision.set_disabled(true)
	visible = false

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		hurt = true
		emit_signal("health_enemy_updated", health, prev_health - health)
		if health == 0:
			death = true


func _on_Respawn_respawnded(player_position):
	if (player_position - global_position).length() > 1500:
		respawn = true

