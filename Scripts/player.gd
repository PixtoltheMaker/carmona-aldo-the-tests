
extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var respawn_point: Marker2D = %"Respawn Point"


var bullet := preload("res://Scenes/bullet.tscn")

func _ready() -> void:
	HealthManager.on_death.connect(handle_death)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var stats := body.find_child("Enemy Stats") as EnemyStats
		print("Enemy entered", stats.damage_amount )
		
		var tween := get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		
		HealthManager.decrease_health(stats.damage_amount)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		#var stats := area.find_child("Enemy Stats") as EnemyStats
		#print("Enemy entered", stats.damage_amount )
	
		var tween := get_tree().create_tween()
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", true, 0)
		tween.tween_property(animated_sprite_2d, "material:shader_parameter/enabled", false, 0.2)
		
		
		HealthManager.decrease_health(1)

func handle_death() -> void:
	global_position = respawn_point.global_position
