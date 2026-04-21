class_name HitBox extends Area2D





	# signal
	
signal Damaged( hurt_box : HurtBox)





	# hurt part
	
func TakeDamage( hurt_box : HurtBox ):

	Damaged.emit ( hurt_box )
