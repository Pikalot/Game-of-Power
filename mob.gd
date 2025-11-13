extends RigidBody2D
var speed = 75
var acceleration = 25
var max_speed = 450
var screen_half_y = 0  # will be set from Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation(animation_name: String) -> void:
	if $AnimatedSprite2D.sprite_frames.has_animation(animation_name):
		$AnimatedSprite2D.animation = animation_name
		$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _integrate_forces(state):
	# accelerate only after crossing half the screen
	if position.y > screen_half_y:
		speed += acceleration * state.step
		speed = min(speed, max_speed)

	linear_velocity = Vector2(0, speed)
