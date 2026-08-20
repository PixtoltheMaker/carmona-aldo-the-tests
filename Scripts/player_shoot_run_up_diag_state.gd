extends NodeState

var bullet := preload("res://Scenes/bullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D

@export_category("Run State")
@export var speed : int = 1000
@export var max_horizontal_speed : int = 300

var muzzle_position : Vector2


func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	var direction : float = GameInputEvents.movement_input()
	
	gun_muzzle_position(direction)
	
	if direction:
		character_body_2d.velocity.x += direction * speed
		character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_horizontal_speed, max_horizontal_speed)
	
	if GameInputEvents.shoot_input():
		gun_shooting(direction)
	
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
	
	character_body_2d.move_and_slide()
	
	#trasitioning states
	
	#idle state
	if direction == 0:
		transition.emit("Idle")
	
	#jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	
	#fall state
	if !character_body_2d.is_on_floor():
		transition.emit("Fall")
	
	#shoot run
	if direction != 0 and GameInputEvents.diagonal_input():
		transition.emit("ShootRun")


func enter() -> void:
	var shoot_direction : float = GameInputEvents.movement_input()
	muzzle.position = Vector2(9, -38)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("Shoot_Run_Up_Diag")
	gun_muzzle_position(shoot_direction)


func exit() -> void:
	animated_sprite_2d.stop()


func gun_muzzle_position(direction : float) -> void:
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x


func gun_shooting(direction : float) -> void:
	var bullet_instance := bullet.instantiate() as Bullet
	
	
	bullet_instance.move_x_direction = clamp(muzzle.position.x, -1, 1)
	bullet_instance.move_y_direction = -1
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
