extends NodeState


@export var animated_sprite_2d : AnimatedSprite2D
@onready var stunned_timer: Timer = %"Stunned Timer"
@onready var enemy_dino: EnemyDino = $"../.."



func on_process(delta : float) -> void:
	pass


func on_physics_process(delta : float) -> void:
	pass


func enter() -> void:
	stunned_timer.start()
	enemy_dino.enemy_stats.damageable = true


func exit() -> void:
	pass
