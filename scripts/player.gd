extends KinematicBody2D

export var gravity = 150
export var acc = 250
export var de_acc = 150
export var max_move_speed = 50
export var jump_height = 90

var vspeed : float = 0
var hspeed : float = 0
var move_speed : float = 0

var touching_ground : bool = false
var coy_time : bool = false # this will let us do coytoee time

var motion : Vector2 = Vector2.ZERO
var up : Vector2 = Vector2.UP

onready var coy_timer = $coyote_timer

func _physics_process(delta: float) -> void:
	quick_move(delta)
	apply_physics(delta)

func apply_physics(delta : float) -> void:

	if(is_on_ceiling()):
		motion.y = 10
		vspeed = 10
	
	if(touching_ground == true and !is_on_floor()): # just left the ground
		coy_time = true
		coy_timer.start(0.2)
		
	if(is_on_floor()):
		touching_ground = true
		coy_timer.stop()
		coy_time = false
	else:
		touching_ground = false

	if(!is_on_floor()):
		vspeed += (gravity * delta)
	else:
		vspeed = 0
		if(Input.is_action_just_pressed("jump")):
			coy_time = false
			coy_timer.stop()
			vspeed = -jump_height
			
	if(coy_time and Input.is_action_just_pressed("jump")):
		coy_time = false
		coy_timer.stop()
		vspeed = -jump_height

	motion.y = vspeed
	motion.x = hspeed

	motion = move_and_slide(motion,up)


func quick_move(var delta : float) -> void:

	if(is_on_wall()):
		move_speed = 0

	if(Input.is_action_pressed("right")):
		move_speed += acc * delta
	elif(Input.is_action_pressed("left")):
		move_speed -= acc * delta
	else:
		move_speed = lerp(move_speed,0,0.5)
		
	move_speed = clamp(move_speed,-max_move_speed,max_move_speed)
	
	hspeed = move_speed


func _on_coyatoe_timer_timeout() -> void:
	coy_time = false
