class_name EnemyDino
extends CharacterBody2D
var enemy_death_effect := preload("res://Scenes/enemy_death_effect.tscn")


@onready var enemy_stats: EnemyStats = $"Enemy Stats"

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print ("Hurtbox area entered")
	if enemy_stats.damageable: 
		if area.get_parent().has_method("get_damage_amount"):
			var node := area.get_parent() as Bullet
			enemy_stats.health_amount -= node.damage_amount
			print("health amount:", enemy_stats.health_amount)
			
			if enemy_stats.health_amount <= 0:
				var enemy_death_effect_instant := enemy_death_effect.instantiate() as Node2D
				enemy_death_effect_instant.global_position = global_position
				get_parent().add_child(enemy_death_effect_instant)
				queue_free()
