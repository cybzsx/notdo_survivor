# FlySword.gd
# 围绕玩家旋转的飞剑（类幸存者武器）

class_name FlySword
extends Node2D

# ==================================================
# 基础参数
# ==================================================
@export var rotate_radius: float = 110.0        # 离玩家距离
@export var rotate_speed: float = 3.2           # 公转速度（弧度）
@export var sword_spin_speed: float = 12.0      # 自转速度
@export var bob_strength: float = 8.0           # 上下浮动幅度
@export var bob_speed: float = 4.0             # 浮动速度

# 剑图片（拖入多张即可切换）
@export var sword_textures: Array[Texture2D]

# 动画切换间隔
@export var texture_interval: float = 0.12

# ==================================================
# 节点引用
# ==================================================
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $HurtBox

# ==================================================
# 内部变量
# ==================================================
var player: Node2D
var angle: float = 0.0
var texture_index: int = 0
var texture_timer: float = 0.0
var bob_timer: float = 0.0

# ==================================================
# 初始化
# ==================================================
func _ready() -> void:
	find_player()

	if sword_textures.size() > 0:
		sprite.texture = sword_textures[0]

	# 初始随机角度（多个剑时很好用）
	angle = randf() * TAU


# ==================================================
# 主循环
# ==================================================
func _process(delta: float) -> void:

	if !is_instance_valid(player):
		find_player()
		return

	# ----------------------------------------
	# 1. 围绕玩家旋转（公转）
	# ----------------------------------------
	angle += rotate_speed * delta

	var offset = Vector2(cos(angle), sin(angle)) * rotate_radius

	# ----------------------------------------
	# 2. 剑轨迹浮动（更灵动）
	# ----------------------------------------
	bob_timer += delta * bob_speed
	offset.y += sin(bob_timer) * bob_strength

	global_position = player.global_position + offset

	# ----------------------------------------
	# 3. 剑自身旋转（自转）
	# ----------------------------------------
	rotation += sword_spin_speed * delta

	# ----------------------------------------
	# 4. 图片切换（挥动动画）
	# ----------------------------------------
	texture_timer += delta

	if texture_timer >= texture_interval:
		texture_timer = 0.0
		switch_texture()


# ==================================================
# 找玩家
# ==================================================
func find_player() -> void:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]


# ==================================================
# 图片切换
# ==================================================
func switch_texture() -> void:
	if sword_textures.is_empty():
		return

	texture_index += 1

	if texture_index >= sword_textures.size():
		texture_index = 0

	sprite.texture = sword_textures[texture_index]
