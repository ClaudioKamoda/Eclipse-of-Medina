extends KinematicBody2D

export (NodePath) var timerPath
export (NodePath) var timerWaitPath
export (NodePath) var timerAttackPath
export (NodePath) var AnimatedSpritePath

onready var anim = get_node(AnimatedSpritePath)
onready var timer_dash = get_node(timerPath)
onready var timer_wait = get_node(timerWaitPath)
onready var timer_attack = get_node(timerAttackPath)


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

onready var cam = $Camera2D
onready var camHandler = $CameraHandler
onready var camTween = $CameraHandler/CameraTween

func _ready():
	camHandler.connect("area_entered", self, "new_camera_snap")

    #Atualiza todo momento
func _physics_process(delta):
	if camTween.is_active():
		return
	
	              #Em qualquer estado, faz o flip do sprite
	if(movedir > 0):              
		if(anim.flip_h == true):
			anim.offset.x = 15
			anim.flip_h = false
	elif(movedir < 0):
		if(anim.flip_h == false):
			anim.offset.x = -22
			anim.flip_h = true

	
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


    #Câmera
func new_camera_snap(snap):
	if snap.is_in_group("camera_snap"):
		var camRect = Rect2(snap.position, Vector2(1024, 600) * snap.scale)
		#cam.limit_left = snap.position.x
		#cam.limit_right = snap.position.x + 1024 * snap.scale.x
		#cam.limit_top = snap.position.y
		#cam.limit_bottom = snap.position.y + 600 * snap.scale.y
		tween_camera(camRect)

func tween_camera(new_position):
	camTween.interpolate_property(cam, "limit_left", cam.limit_left, new_position.position.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	camTween.interpolate_property(cam, "limit_right", cam.limit_right, new_position.end.x, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	camTween.interpolate_property(cam, "limit_top", cam.limit_top, new_position.position.y, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	camTween.interpolate_property(cam, "limit_bottom", cam.limit_bottom, new_position.end.y, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	camTween.start()
	if($AnimatedSprite.flip_h == true):
		position.x -= 64
	else:
		position.x += 64
