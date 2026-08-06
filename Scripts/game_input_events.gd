class_name GameInputEvents
extends Node

static func movement_input() -> float:
	var direction : float = Input.get_axis("Move_Left", "Move_Right")
	return direction

static func jump_input() -> bool:
	var jumpInput : bool = Input.is_action_just_pressed("Jump")
	return jumpInput

static func shoot_input() -> bool:
	var shootInput : bool = Input.is_action_just_pressed("Shoot")
	return shootInput

static func shoot_up_input() -> bool:
	var shootInput : bool = Input.is_action_just_pressed("Shoot")
	var upInput : bool = Input.is_action_pressed("look_up")
	return upInput and shootInput

static func crouch_input() -> bool:
	var crouchInput : bool = Input.is_action_pressed("Crouch")
	return crouchInput

static func fall_input() -> bool:
	var crouchInput : bool = Input.is_action_pressed("Crouch")
	var downInput: bool = Input.is_action_pressed("Look_Down")
	return crouchInput and downInput
