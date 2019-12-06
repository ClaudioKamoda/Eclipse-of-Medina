extends KinematicBody2D

signal health_updated(health, amount)
signal killed()

onready var anim = $AnimatedSprite
onready var timer_dash = $timer_dash
onready var timer_wait = $timer_wait
onready var timer_attack = $timer_attack
onready var SwordHit = get_node("AnimatedSprite/SwordHit/SwordHit")
onready var Particles = get_node("AnimatedSprite/SwordHit/Particles2D")
onready var Particles2 = get_node("AnimatedSprite/SwordHit/Particles2D2")
onready var invulnerability_timer = $invulnerability
onready var health_bar = $HealthBar
onready var game_over = $GameOver
onready var black_overlay = $BlackOverlay
onready var pause = $Pause



# Variáveis setadas externamente (são bem importantes)

export (float) var SPEED = 200
export (float) var JUMP_SPEED = 730
export (float) var GRAVITY = 30
export (float) var DASH_SPEED = 1000

#Variáveis globais
var double_jump
var dash

# Variáveis auxiliares

var movedir = 0
var velocity = Vector2(0,0)
var do_dash = false
var wait_dash = false
var attack = false
var attacking = false
var hurt = false
var death = false

func verif_checkpoint():
	if(position.x < -800 && position.y < -400):
		Global.checkpoint = 1
	elif(position.y > -400 && position.y < 2000):
		if !Global.checkpoint == 1:
			Global.checkpoint = 2
	else:
		Global.checkpoint = 3

func _ready():
	print(Global.Position)
	set_position(Global.Position)
	double_jump = Global.Double_Jump
	dash = Global.Dash
	game_over.set_visible_characters(0)


    #Atualiza todo momento
func _physics_process(delta):
	verif_checkpoint()
	
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
	hurt = false
	if death:
		kill()

func _on_SwordHit_area_entered(area):
	if area.is_in_group("hurtbox"):
		if(Particles.is_emitting()):
			print("Damage2")
			Particles2.set_emitting(true)
		else:
			print("Damage")
			Particles.set_emitting(true)

func _on_SwordHit_body_entered(body):
	if body.is_in_group("enemy"):
		if(Particles.is_emitting()):
			Particles2.set_emitting(true)
			body.damage_enemy(1)
		else:
			Particles.set_emitting(true)
			body.damage_enemy(1)

func save():
	var save_dict = {
		pos = {
			x = get_position().x,
			y = get_position().y,
		},
		dash = Global.Dash,
		double_jump = Global.Double_Jump,
		max_health = Global.Max_Health,
		health = Global.Health,
	}
	return save_dict


func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(Global.Health - amount)

func kill():
	var i = 1
	while i <= 8:
		game_over.set_visible_characters(i)
		i += 1
	get_tree().paused = true

func _set_health(value):
	var prev_health = Global.Health
	Global.Health = clamp(value, 0, Global.Max_Health)
	if Global.Health != prev_health:
		hurt = true
		emit_signal("health_updated", Global.Health, prev_health - Global.Health)
		if Global.Health == 0:
			death = true
			emit_signal("killed")
