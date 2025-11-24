extends RigidBody2D

func play_animation(animation_name: String) -> void:	
	if $AnimatedSprite2D.sprite_frames.has_animation(animation_name):
		$AnimatedSprite2D.animation = animation_name
		$AnimatedSprite2D.play()
