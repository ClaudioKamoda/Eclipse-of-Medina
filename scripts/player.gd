extends KinematicBody2D

export (NodePath) var timerPath

onready var timer = get_node(timerPath)
var SPEED = 200
const JUMP_SPEED = 1000
const GRAVITY = 50
const DASH_SPEED = 1000

var movedir = 0
var velocity = Vector2(0,0)

onready var cam = $Camera2D
onready var camHandler = $CameraHandler
onready var camTween = $CameraHandler/CameraTween

func _ready():
	camHandler.connect("area_entered", self, "new_camera_snap")

func _physics_process(delta):
	if camTween.is_active():
		return
	
	# ANIMAÇÕES
	if(Input.is_action_pressed("ui_right")):
		if($AnimatedSprite.flip_h == true):
			$AnimatedSprite.offset.x = 15
			$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Corrida")
		
	elif(Input.is_action_pressed("ui_left")):
		if($AnimatedSprite.flip_h == false):
			$AnimatedSprite.offset.x = -22
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Corrida")
		
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite.play("Pulo")
	
	else:
		if(is_on_floor()):
			$AnimatedSprite.play("Parado")
		
	
	# AÇÕES
	
	movedir = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	
	velocity.x = movedir * SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP_SPEED
		
		
	if Input.is_action_just_pressed("dash"):
		SPEED += 800
		timer.start()

func _on_Timer_timeout():
	SPEED = 200

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