# Grass_Land_03.gd
# UFO敌人（类幸存者游戏）
# 玩家已加入 "Player" 组

class_name Grass_Land_01
extends Node2D

# ========= 基础属性 =========
@export var move_speed: float = 100.0
@export var max_hp: int = 5
@export var attack_damage: int = 1
@export var attack_interval: float = 1.0
@export var detect_range: float = 99999.0
@export var exp_value: int = 1

# ========= 击退 =========
@export var knockback_power: float = 220.0
var knockback_velocity: Vector2 = Vector2.ZERO

# ========= 内部变量 =========
var hp: int
var player: Node2D
var can_attack: bool = true
var dead: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox
@onready var collision: CollisionShape2D = $HitBox/CollisionShape2D

func _ready() -> void:
	
	$AnimatedSprite2D.play("idle")
	add_to_group("Enemy");
	hp = max_hp
	#find_player()

	# 监听碰撞玩家
	#if hitbox:
	#	hitbox.body_entered.connect(_on_body_entered)
		
	$HitBox.Damaged.connect( take_damage )

func _physics_process(delta: float) -> void:
	if dead:
		return

	if !is_instance_valid(player):
		#find_player()
		return

	# 朝玩家移动  
	var dir =  global_position.direction_to(player.global_position)

	# 击退衰减
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)

	# 最终移动
	global_position += (dir * move_speed + knockback_velocity) * delta

	# 面向方向（左右翻转）  
	if sprite:
		sprite.flip_h = - dir.x < 0


# ==================================================
# 找玩家
# ==================================================
func find_player() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	
	if players.size() > 0:
		player = players[0]


# ==================================================
# 受到伤害（子弹 / 技能调用）
# ==================================================
func take_damage( _hurt_box : HurtBox) -> void:
	if dead:
		return

	$AudioStreamPlayer2D.play()
	hp -= _hurt_box.damage

	# 受击闪白
	hit_flash()

	# 击退
	if _hurt_box.global_position != Vector2.ZERO:
		var dir = _hurt_box.global_position.direction_to(global_position)
		knockback_velocity = dir * knockback_power

	if hp <= 0:
		die()


# ==================================================
# 死亡
# ==================================================
func die() -> void:
	if dead:
		return

	dead = true

	# 可在这里掉经验球
	# drop_exp()

	queue_free()


# ==================================================
# 攻击玩家
# ==================================================
func attack_player(target):
	if !can_attack:
		return

	can_attack = false

	if target.has_method("take_damage"):
		target.take_damage(attack_damage)

	# 攻击冷却
	await get_tree().create_timer(attack_interval).timeout
	can_attack = true


# ==================================================
# 碰到玩家
# ==================================================
func _on_body_entered(body):
	if body.is_in_group("Player"):
		attack_player(body)


# ==================================================
# 受击闪烁
# ==================================================
func hit_flash():
	if !sprite:
		return

	sprite.modulate = Color(2, 2, 2, 1)
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(sprite):
		sprite.modulate = Color(1, 1, 1, 1)
