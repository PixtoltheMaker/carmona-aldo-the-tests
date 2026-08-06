
extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle


var bullet := preload("res://Scenes/bullet.tscn")




func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var stats := body.find_child("Enemy Stats") as EnemyStats
		print("Enemy entered", stats.damage_amount )
		
		var tween := get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		
		HealthManager.decrease_health(stats.damage_amount)
