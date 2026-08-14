class_name Enemy_Bullet
extends AnimatedSprite2D
var bullet_impact_effects := preload("res://Scenes/bullet_impact_frame.tscn")

var speed : int = 200
var direction : Vector2
var damage_amount : int = 1


func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print ("bullet area entered")
	bullet_impact()


func _on_hitbox_body_entered(body: Node2D) -> void:
	print ("bullet body entered")
	bullet_impact()

func get_damage_amount() -> int:
	return damage_amount

func bullet_impact() -> void:
	var bullet_impact_effect_instance := bullet_impact_effects.instantiate() as Node2D
	bullet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bullet_impact_effect_instance)
	queue_free()

func fire_bullet(direct : Vector2) -> void:
	direction = direct
