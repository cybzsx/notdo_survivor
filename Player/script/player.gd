class_name Player extends CharacterBody2D




	#	signal
	
signal Direction_Changed( new_direction : Vector2)






	#	child node
	
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D





	# var
	
var _player_speed : float = 250;





	# dir part

var _dir : Vector2 = Vector2.ZERO

var cardinal_direction : Vector2 = Vector2.LEFT

var direction : Vector2 = Vector2.ZERO

const DIR_4 =	[ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP] 






	
	# 

func _ready() -> void:
	
	add_to_group("PLayer");
	
	animated_sprite_2d.play("walk")
	
	
	
	
	
	#
	
func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")	





	#
	
func _physics_process(delta: float) -> void:
	
	velocity = direction * _player_speed 
	
	move_and_slide()
	
	
	
	#
	
func _unhandled_input(event: InputEvent) -> void:
	
	return
