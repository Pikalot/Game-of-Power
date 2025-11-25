extends Area2D
@export var type: PowerUpType = PowerUpType.POWER
@export var amount: int = 1
@export var operation: Operation = Operation.ADD

enum PowerUpType { BULLET_SPEED, POWER }
enum Operation {MULT, DIV, SUB, ADD}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(operation == Operation.ADD):
		$PowerLabel.text = "Pow +" + str(amount)
	elif(operation == Operation.SUB):
		$PowerLabel.text = "Pow -" + str(amount)
	elif(operation == Operation.MULT):
		$PowerLabel.text = "Pow X" + str(amount)
	elif(operation == Operation.DIV):
		$PowerLabel.text = "Pow /" + str(amount)
	$PowerLabel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.y += 35
	position += velocity * delta

#set the power up type of either power or projectile speed
func set_type(newType : PowerUpType):
	type = newType

#set the amount to increase
func set_amount(amt : int):
	amount = amt
	
func set_operation(op : Operation):
	operation = op

func _on_area_entered(area: Area2D) -> void:
	$DeleteTimer.start()
	$ChestOpen.play()
	$AnimatedSprite2D.play()
	if area.is_in_group("player"):
		if(operation == Operation.ADD):
			area.set_power(area.power + amount)
		elif(operation == Operation.SUB):
			area.set_power(area.power - amount)
		elif(operation == Operation.MULT):
			area.set_power(area.power * amount)
		elif(operation == Operation.DIV):
			area.set_power(area.power / amount)

func _on_delete_timer_timeout() -> void:
	queue_free()
