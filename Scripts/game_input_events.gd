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

static func up_input() -> bool:
	var upInput : bool = Input.is_action_pressed("look_up")
	return upInput

static func crouch_input() -> bool:
	var crouchInput : bool = Input.is_action_pressed("Crouch")
	return crouchInput

static func down_input() -> bool:
	var downInput: bool = Input.is_action_pressed("Look_Down")
	return downInput

static func diagonal_input() -> bool:
	var diagonalInput : bool = Input.is_action_just_pressed("Diagonal_Aim")
	return diagonalInput

static func aim_input() -> bool:
	var aimInput : bool = Input.is_action_just_pressed("Aim")
	return aimInput
