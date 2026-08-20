extends Node2D

@export var heart1 : Texture2D
@export var heart0 : Texture2D

@onready var heart_1: Sprite2D = $Heart1
@onready var heart_2: Sprite2D = $Heart2
@onready var heart_3: Sprite2D = $Heart3
@onready var heart_4: Sprite2D = $Heart4
@onready var heart_5: Sprite2D = $Heart5


func _ready() -> void:
	HealthManager.on_health_changed.connect(on_player_health_changed)
	

func on_player_health_changed(player_current_health : int) -> void:
	heart_1.texture = heart1
	heart_2.texture = heart1
	heart_3.texture = heart1
	heart_4.texture = heart1
	heart_5.texture = heart1
	if player_current_health == 5:
		heart_5.texture = heart1
	elif player_current_health < 5:
		heart_5.texture = heart0
	
	if player_current_health == 4:
		heart_4.texture = heart1
	elif player_current_health < 4:
		heart_4.texture = heart0
	
	if player_current_health == 3:
		heart_3.texture = heart1
	elif player_current_health < 3:
		heart_3.texture = heart0
	
	if player_current_health == 2:
		heart_2.texture = heart1
	elif player_current_health < 2:
		heart_2.texture = heart0
	
	if player_current_health == 1:
		heart_1.texture = heart1
	elif player_current_health < 1:
		heart_1.texture = heart0
	
