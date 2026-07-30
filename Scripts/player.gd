extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle


var bullet := preload("res://Scenes/bullet.tscn")

const GRAVITY = 650
@export var speed: int = 9
@export var jump: int = -300

enum state {idle, run, jump, shoot }

var current_state : state
var muzzle_position : Vector2

func _ready() -> void:
	current_state = state.idle
	muzzle_position = muzzle.position


func _physics_process(delta: float) -> void:
	Player_Falling(delta)
	Player_Idle(delta)
	Player_Run(delta)
	Player_Jump(delta)
	Player_Muzzle_Position(delta)
	Player_Shooting(delta)
	
	move_and_slide()
	
	Player_Animations()
	
	#print("State: ", state.keys()[current_state])



func Player_Falling(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func Player_Idle(delta : float) -> void:
	if is_on_floor():
		current_state = state.idle

func Player_Run(delta : float) -> void:
	if !is_on_floor():
		return
	
	var direction: = Input_Movement()
	
	if direction:
		velocity.x = direction * (speed * 1000) * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	
	if direction != 0:
		current_state = state.run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func Player_Shooting(delta : float) -> void:
	var direction: = Input_Movement()
	
	if direction != 0 and Input.is_action_just_pressed("Shoot"):
		var bullet_instance := bullet.instantiate() as Bullet
		if direction > 0:
			bullet_instance.direction = ceil(direction)
		elif direction < 0:
			bullet_instance.direction = floor(direction)
		else:
			return
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = state.shoot

func Player_Muzzle_Position(delta : float) -> void:
	var direction: = Input_Movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x


func Player_Jump(delta : float) -> void:
	if Input.is_action_just_pressed("Jump") and !is_on_floor():
		return
	
	var direction: = Input_Movement()
	
	if Input.is_action_just_pressed("Jump"):
		velocity.y = jump
		current_state = state.jump
	
	
	if !is_on_floor() and current_state == state.jump:
		
		velocity.x = direction * (speed * 1000) * delta
	
	
	if direction != 0 and !is_on_floor():
		current_state = state.jump
		animated_sprite_2d.flip_h = false if direction > 0 else true


func Player_Animations() -> void: 
	if current_state == state.idle:
		animated_sprite_2d.play("Idle")
	elif current_state == state.run and animated_sprite_2d.animation != "Run_Shoot":
		animated_sprite_2d.play("Run")
	elif current_state == state.jump:
		animated_sprite_2d.play("Jump")
	elif current_state == state.shoot:
		animated_sprite_2d.play("Run_Shoot")

func Input_Movement() -> float:
	var direction: = Input.get_axis("Move_Left", "Move_Right")
	
	return direction
