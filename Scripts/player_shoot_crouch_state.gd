extends NodeState

var bullet := preload("res://Scenes/bullet.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var muzzle : Marker2D

var muzzle_position : Vector2


func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	
	gun_muzzle_position()
	
	if GameInputEvents.shoot_input():
		gun_shooting()
	
	if GameInputEvents.down_input():
		character_body_2d.set_collision_mask_value(5, false)
	else:
		character_body_2d.set_collision_mask_value(5, true)
	
	#trasitioning states
	
	#run state
	var direction : float = GameInputEvents.movement_input()
	
	if direction and character_body_2d.is_on_floor():
		transition.emit("Run")
	
	#jump state
	if GameInputEvents.jump_input():
		transition.emit("Jump")
	
	#fall state
	if GameInputEvents.down_input():
		transition.emit("Fall")
	#shoot crouch up
	if GameInputEvents.up_input():
		transition.emit("ShootCrouchUp")
	
	#shoot crouch up diag
	if GameInputEvents.diagonal_input():
		transition.emit("ShootCrouchUpDiag")


func enter() -> void:
	muzzle.position = Vector2(15, -15)
	muzzle_position = muzzle.position
	animated_sprite_2d.play("Shoot_Crouch")


func exit() -> void:
	animated_sprite_2d.stop()


func gun_muzzle_position() -> void:
	if !animated_sprite_2d.flip_h:
		muzzle.position.x = muzzle_position.x
	elif animated_sprite_2d.flip_h:
		muzzle.position.x = -muzzle_position.x


func gun_shooting() -> void:
	
	var bullet_instance := bullet.instantiate() as Bullet
	bullet_instance.move_x_direction = clamp(muzzle.position.x, -1, 1)
	bullet_instance.move_y_direction = 0
	bullet_instance.global_position = muzzle.global_position
	get_parent().add_child(bullet_instance)
	
