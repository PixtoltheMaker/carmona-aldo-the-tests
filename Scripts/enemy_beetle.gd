extends CharacterBody2D
var enemy_death_effect := preload("res://Scenes/enemy_death_effect.tscn")
var enemy_bullet := preload("res://Scenes/enemy_bullet.tscn")
var player : Node2D

@export var patrol_points : Node2D
@export var wait_time : int = 2
@export var shoot_count : int = 3
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var enemy_stats: EnemyStats = $"Enemy Stats"
@onready var shoot_timer: Timer = $"Shoot Timer"


enum State { Fly, Shoot, Idle }
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_position : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_fly : bool
var is_shooting : bool = false

func _ready() -> void:
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point : Node2D in patrol_points.get_children():
			point_position.append(point.global_position)
		current_point = point_position[current_point_position]
	else:
		print("no patrol points")
	
	player = get_tree().get_first_node_in_group("Player")
	
	timer.wait_time = wait_time
	
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	#Enemy_Shoot()
	#Enemy_Idle(delta)
	#Enemy_Run(delta)
	
	match current_state:
		State.Idle:
			Enemy_Idle(delta)
		State.Fly:
			Enemy_Fly(delta)
		State.Shoot:
			Enemy_Shoot()
	
	move_and_slide()
	Enemy_Animations()

func Enemy_Idle(delta : float) -> void:
	velocity.x = 0
	if global_position.distance_to(player.global_position) < 200:
		current_state = State.Shoot
	if timer.is_stopped():
		timer.start()

func Enemy_Shoot() -> void:
	timer.stop()
	if !is_shooting:
		velocity.x = 0
		shoot_timer.start()
		is_shooting = true

func Enemy_Fly(delta : float) -> void:
	
	if abs(global_position.x - current_point.x) > 5:
		velocity.x = direction.x * enemy_stats.speed * delta
	else:
		current_point_position += 1
		
		if current_point_position >=  number_of_points:
			current_point_position = 0
			
		current_state = State.Idle
	
		current_point = point_position[current_point_position]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
	animated_sprite_2d.flip_h = direction.x > 0

func Enemy_Bullet_Shoot() -> void:
	print ("shoot bullet")
	var enemy_bullet_instance := enemy_bullet.instantiate() as Enemy_Bullet
	enemy_bullet_instance.position = global_position
	get_parent().add_child(enemy_bullet_instance)
	var shoot_direction : Vector2 = global_position.direction_to(player.global_position)
	enemy_bullet_instance.fire_bullet(shoot_direction)
	

func Enemy_Animations() -> void:
	if current_state == State.Idle && !can_fly:
		animated_sprite_2d.play("Fly")
	elif current_state == State.Fly && can_fly:
		animated_sprite_2d.play("Fly")

func _on_timer_timeout() -> void:
	current_state = State.Fly



func _on_hurtbox_area_entered(area: Area2D) -> void:
	print ("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node := area.get_parent() as Bullet
		enemy_stats.health_amount -= node.damage_amount
		print("health amount:", enemy_stats.health_amount)
		
		if enemy_stats.health_amount <= 0:
			var enemy_death_effect_instant := enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instant.global_position = global_position
			get_parent().add_child(enemy_death_effect_instant)
			queue_free()


func _on_shoot_timer_timeout() -> void:
	print ("shoot timer timeout")
	Enemy_Bullet_Shoot()
	if shoot_count > 0:
		shoot_timer.start()
		shoot_count -= 1
	else:
		is_shooting = false
		current_state = State.Idle
