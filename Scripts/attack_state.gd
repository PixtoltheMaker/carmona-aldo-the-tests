extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int
@export var max_speed : int

var player : CharacterBody2D

func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	var direction : int
	
	if player:
		if character_body_2d.global_position.x > player.global_position.x:
			animated_sprite_2d.flip_h = false
			direction = -1
		elif character_body_2d.global_position.x < player.global_position.x:
			animated_sprite_2d.flip_h = true
			direction = 1
	
	animated_sprite_2d.play("Attack")
	
	character_body_2d.velocity.x += direction * speed
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_speed, max_speed)
	character_body_2d.move_and_slide()
	
	


func enter() -> void:
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D
	print("enter attack")


func exit() -> void:
	pass
