extends Area2D
@export var type: PowerUpType = PowerUpType.POWER
@export var amount: int = 1

enum PowerUpType { SPEED, POWER }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.y += 150
	position += velocity * delta

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if type == PowerUpType.SPEED:
			body.set_power(body.power + 1)
		elif type == PowerUpType.POWER:
			print("Power powerup!")
