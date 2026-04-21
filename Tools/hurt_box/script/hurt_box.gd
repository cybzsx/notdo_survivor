class_name HurtBox extends Area2D





	# hurt 
	
@export var damage : int = 1

signal _hurt 





	#
	
func _ready() -> void:
	
	area_entered.connect( AreaEntred )
	
	
	
	
	
	# hurt connect
	
func AreaEntred( _h : Area2D):
	
	if _h is HitBox:
		
		_h.TakeDamage( self )
		
		_hurt.emit()
