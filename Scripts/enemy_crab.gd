extends CharacterBody2D
var enemy_death_effect := preload("res://Scenes/enemy_death_effect.tscn")

@export var patrol_points : Node2D
@export var speed : int = 1500
@export var wait_time : int = 2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@export var health_amount: int = 5


const GRAVITY = 650

enum State { Idle, Walk }
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_position : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool


func _ready() -> void:
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point : Node2D in patrol_points.get_children():
			point_position.append(point.global_position)
		current_point = point_position[current_point_position]
	else:
		print("no patrol points")
	
	timer.wait_time = wait_time
	
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	Enemy_Gravity(delta)
	Enemy_Idle(delta)
	Enemy_Run(delta)
	
	move_and_slide()
	
	Enemy_Animations()

func Enemy_Gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta

func Enemy_Idle(delta : float) -> void:
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		current_state = State.Idle
	

func Enemy_Run(delta : float) -> void:
	if !can_walk:
		return
	
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.Walk
	else:
		current_point_position += 1
		
		if current_point_position >=  number_of_points:
			current_point_position = 0
	
		current_point = point_position[current_point_position]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()
		
	animated_sprite_2d.flip_h = direction.x > 0

func Enemy_Animations() -> void:
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("Idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("Walk")

func _on_timer_timeout() -> void:
	can_walk = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print ("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node := area.get_parent() as Bullet
		health_amount -= node.damage_amount
		print("health amount:", health_amount)
		
		if health_amount <= 0:
			var enemy_death_effect_instant := enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instant.global_position = global_position
			get_parent().add_child(enemy_death_effect_instant)
			queue_free()
