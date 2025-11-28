extends "res://scripts/utils/animation.gd"

@export var power = 5
@export var speed = 100
@export var acceleration = 25
@export var max_speed = 450
@export var powerup_scene: PackedScene

var screen_half_y = 0  # will be set from Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("walk")
	power = int(ceil(power * randf_range(0.6, 1.4)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PowerLabel.text = "x" + str(power)


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
	power_up.set_amount(2)
	power_up.set_operation(power_up.Operation.MULT)
	power_up.set_type(power_up.PowerUpType.BULLET_SPEED)
	get_parent().add_child(power_up)
	power_up.global_position = global_position
	# Play death sound
	var death_sound = $DeadSound.duplicate()
	get_parent().add_child(death_sound)
	death_sound.play()

	queue_free()

func take_hit(damage: int) -> void:
	power -= damage
	if power <= 0:
		die()
