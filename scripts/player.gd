extends KinematicBody2D

export (NodePath) var timerPath

onready var timer = get_node(timerPath)
var SPEED = 200
const JUMP_SPEED = 1000
const GRAVITY = 50
const DASH_SPEED = 1000

var movedir = 0
var velocity = Vector2(0,0)

func _physics_process(delta):
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
