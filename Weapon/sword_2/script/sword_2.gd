# =====================================================
# Part 2：Sword2.gd
# 飞出去的箭矢剑
# 自动追踪最近敌人方向
# 数秒后销毁
# =====================================================

class_name Sword2
extends Node2D

@export var move_speed: float = 700.0
@export var life_time: float = 3.0
@export var rotate_speed: float = 20.0

var direction: Vector2 = Vector2.RIGHT
var target: Node2D


func _ready():

	# 到时间自动销毁
	await get_tree().create_timer(life_time).timeout

	if is_instance_valid(self):
		queue_free()


func _process(delta):

	# 飞行
	global_position += direction * move_speed * delta

	# 自转
	#rotation += rotate_speed * delta


# -----------------------------------------
# 玩家发射时调用
# -----------------------------------------
func setup_target(enemy):

	target = enemy

	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)

	# 设置朝向
	rotation = direction.angle()
