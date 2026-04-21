class_name Player extends CharacterBody2D




	#region	signal & child
	
signal Direction_Changed( new_direction : Vector2)

signal player_damaged

signal player_destroy






	#	child node
	
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var camera_2d: Camera2D = $Camera2D

@onready var hit_box: HitBox = $physics/HitBox

@onready var healthy: Node2D = $healthy   # simple healthy ui container three heart




	#endregion






	#region var & dir
	
var move_speed : float = 260

@export var hp = 3

@export var max_hp = 6





	# dir part

var _dir : Vector2 = Vector2.ZERO

var cardinal_direction : Vector2 = Vector2.LEFT

var direction : Vector2 = Vector2.ZERO

const DIR_4 =	[ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP] 





	#endregion





	#region simple ui
	
@onready var heart_one: Sprite2D = $healthy/Sprite2D

@onready var heart_two: Sprite2D = $healthy/Sprite2D2

@onready var heart_three: Sprite2D = $healthy/Sprite2D3

	
	
	
	
	#endregion











	
	#region ori func

func _ready() -> void:
	
	hit_box.Damaged.connect( player_hurt )
	
	player_destroy.connect( _player_destroy )
	
	add_to_group("Player");
	
	sprite.play("walk")
	
	
	
	
	
	#
	
func _process(delta: float) -> void:
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")	





	#
	
func _physics_process(delta: float) -> void:
	
	
	
	
		# add player direction for animated2D
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	#print(input_dir)
	#velocity = direction * _player_speed
	
	velocity = input_dir * move_speed 

	
	move_and_slide()
	
	
		# update direction when get input
	if input_dir != Vector2.ZERO:
		update_facing(input_dir)
		
		
		
	#endregion
	
	
	
	
	
	#region	dir & input
	
func update_facing(dir: Vector2) -> void:
	# slip

	if dir.x > 0:
		# 向右移动
		sprite.flip_h = true
	elif dir.x < 0:
		# 向左移动
		sprite.flip_h = false
	
	
	
	
	#
	
func _unhandled_input(event: InputEvent) -> void:
	
	return
	
	
	
	
	#endregion





	#region hurt part
	
func player_hurt( _hurt_box : HurtBox):
	
	update_hp( _hurt_box.damage )
	
	if hp > 0:
		#player_damaged.emit( _hurt_box)
		return
	else:
		player_destroy.emit()
		
		
		
		
func update_hp( _delta : int):
	
	hp = clampi( hp - _delta , 0 , max_hp)
	
	update_heart_ui()
	
	hit_flash()
	
	#print( hp )
	
	
	
func _player_destroy():
	
	sprite.play("die")
	
	await sprite.animation_finished
	
	self.queue_free()
	
	
func hit_flash():
	if !sprite:
		return

	sprite.modulate = Color(2, 2, 2, 1)
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(sprite):
		sprite.modulate = Color(1, 1, 1, 1)
		
		
		
func update_heart_ui():
	
	if hp >= 3:
		heart_one.visible  = true
		heart_two.visible = true
		heart_three.visible = true
	if hp == 2:
		heart_one.visible  = true
		heart_two.visible = true
		heart_three.visible = false
	if hp == 1:
		heart_one.visible  = true
		heart_two.visible = false
		heart_three.visible = false
	if hp == 0:
		heart_one.visible  = false
		heart_two.visible = false
		heart_three.visible = false			
	
	#endregion
