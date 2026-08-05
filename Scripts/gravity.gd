extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var gravity : int = 10

func _physics_process(delta: float) -> void:
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.y += (gravity * 100) * delta
	
	character_body_2d.move_and_slide()
