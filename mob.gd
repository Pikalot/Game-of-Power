extends RigidBody2D

@export var power = 5
@export var speed = 100
@export var acceleration = 25
@export var max_speed = 450
@export var powerup_scene: PackedScene

var screen_half_y = 0  # will be set from Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PowerLabel.text = "x" + str(power)

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

func die() -> void:
	var power_up = powerup_scene.instantiate()
	power_up.set_amount(1)
	power_up.set_operation(power_up.Operation.ADD)
	get_parent().add_child(power_up)
	power_up.global_position = global_position
	queue_free()

func take_hit(damage: int) -> void:
	power -= damage
	if power <= 0:
		die()
