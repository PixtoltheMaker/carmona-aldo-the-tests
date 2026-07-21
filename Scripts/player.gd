extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const GRAVITY = 650
@export var speed: int = 200
@export var jump: int = -300

enum state {idle, run, jump }

var current_state : state

func _ready() -> void:
	current_state = state.idle


func _physics_process(delta: float) -> void:
	Player_Falling(delta)
	Player_Idle(delta)
	Player_Run(delta)
	Player_Jump(delta)
	
	move_and_slide()
	
	Player_Animations()
	
	print("State: ", state.keys()[current_state])



func Player_Falling(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func Player_Idle(_delta : float) -> void:
	if is_on_floor():
		current_state = state.idle

func Player_Run(_delta : float) -> void:
	if !is_on_floor():
		return
	
	var direction: = Input_Movement()
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	if direction != 0:
		current_state = state.run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func Player_Jump(_delta : float) -> void:
	if Input.is_action_just_pressed("Jump") and !is_on_floor():
		return
	
	
	if Input.is_action_just_pressed("Jump"):
		velocity.y = jump
		current_state = state.jump
	
	
	if !is_on_floor() and current_state == state.jump:
		var direction: = Input_Movement()
		velocity.x = direction * speed
	


func Player_Animations() -> void: 
	if current_state == state.idle:
		animated_sprite_2d.play("Idle")
	elif current_state == state.run:
		animated_sprite_2d.play("Run")
	elif current_state == state.jump:
		animated_sprite_2d.play("Jump")

func Input_Movement() -> float:
	var direction: = Input.get_axis("Move_Left", "Move_Right")
	
	return direction
