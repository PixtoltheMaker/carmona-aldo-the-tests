extends NodeState

@onready var enemy_dino: EnemyDino = $"../.."

@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int
@export var max_speed : int

var direction : int 

var player : CharacterBody2D

func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	
	animated_sprite_2d.play("Attack")
	
	enemy_dino.velocity.x += direction * speed
	enemy_dino.velocity.x = clamp(enemy_dino.velocity.x, -max_speed, max_speed)
	enemy_dino.move_and_slide()
	
	


func enter() -> void:
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	print("enter attack")
	enemy_dino.enemy_stats.damageable = false
	if player:
		if enemy_dino.global_position.x > player.global_position.x:
			animated_sprite_2d.flip_h = false
			direction = -1
		elif enemy_dino.global_position.x < player.global_position.x:
			animated_sprite_2d.flip_h = true
			direction = 1


func exit() -> void:
	pass
