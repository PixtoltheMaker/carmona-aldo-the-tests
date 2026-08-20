extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Jump State")
@export var jump_height : float = -350
@export var jump_horizontal_speed : int = 300
@export var jump_slow_down_speed : int = 50
@export var max_jump_count : int = 1

var current_jump_count : int

const GRAVITY : int = 800

func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	
	character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, jump_slow_down_speed)
	
	if character_body_2d.is_on_floor():
		current_jump_count = 0
		character_body_2d.velocity.y = jump_height
		current_jump_count += 1
		
	if !character_body_2d.is_on_floor() and GameInputEvents.jump_input() and current_jump_count != max_jump_count:
		character_body_2d.velocity.y = jump_height
		current_jump_count += 1
	
	var direction : float = GameInputEvents.movement_input()
	
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.x = direction * jump_horizontal_speed
	
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
	
	if character_body_2d.velocity.y > 100:
		animated_sprite_2d.play("Fall")
	
	character_body_2d.move_and_slide()
	
	#transition states
	
	#idle state
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
	


func enter() -> void:
	animated_sprite_2d.play("Jump")


func exit() -> void:
	animated_sprite_2d.stop()
