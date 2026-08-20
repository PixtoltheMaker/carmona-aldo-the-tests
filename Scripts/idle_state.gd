extends NodeState

@onready var enemy_dino: EnemyDino = $"../.."
@export var animated_sprite_2d : AnimatedSprite2D
@export var slow_down_speed : int = 50


func on_process(delta : float) -> void:
	pass

func on_physics_process(delta : float) -> void:
	enemy_dino.velocity.x =  move_toward(enemy_dino.velocity.x, 0, slow_down_speed * delta )
	animated_sprite_2d.play("Idle")
	enemy_dino.move_and_slide()
	enemy_dino.enemy_stats.damageable = false


func enter() -> void:
	pass


func exit() -> void:
	pass
