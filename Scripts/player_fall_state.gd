extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Fall State")
@export var fall_horizontal_speed : int = 300
@export var fall_slow_down_speed : int = 50
@export var coyote_time : float = 0.3

var coyote_jump : bool

const GRAVITY : int = 700

func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	var direction : float = GameInputEvents.movement_input()
	
	if !character_body_2d.is_on_floor():
		get_coyote_time()
		character_body_2d.velocity.y += GRAVITY * delta
		character_body_2d.velocity.x = direction * fall_horizontal_speed

	
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, fall_slow_down_speed)
	
	
	
	
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
	
	character_body_2d.move_and_slide()
	
	if GameInputEvents.down_input():
		character_body_2d.set_collision_mask_value(5, false)
	else:
		character_body_2d.set_collision_mask_value(5, true)
	
	#transitioning states
	
	#idle state
	if character_body_2d.is_on_floor():
		transition.emit("Idle")
		character_body_2d.set_collision_mask_value(5, true)
		
	
	#jump state
	if GameInputEvents.jump_input() and coyote_jump:
		character_body_2d.set_collision_mask_value(5, true)
		transition.emit("Jump")


func enter() -> void:
	coyote_jump = true
	animated_sprite_2d.play ("Fall")


func exit() -> void:
	animated_sprite_2d.stop()


func get_coyote_time () -> void:
	await get_tree().create_timer(coyote_time).timeout
	coyote_jump = false
	
