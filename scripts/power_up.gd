extends Area2D
@export var type: PowerUpType = PowerUpType.POWER
@export var amount: float = 1
@export var operation: Operation = Operation.ADD

enum PowerUpType { FIRE_RATE, POWER }
enum Operation {MULT, DIV, SUB, ADD}
var stop_moving = false
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(type == PowerUpType.POWER):
		$PowerLabel.text = "Pow "
		if(operation == Operation.ADD):
			$PowerLabel.text += "+" + str(int(amount))
		elif(operation == Operation.SUB):
			$PowerLabel.text += "-" + str(int(amount))
		elif(operation == Operation.MULT):
			$PowerLabel.text += "x" + str(int(amount))
		elif(operation == Operation.DIV):
			$PowerLabel.text += "/" + str(int(amount))
	elif(type == PowerUpType.FIRE_RATE):
		$PowerLabel.text = "Fr "
		if(operation == Operation.ADD):
			$PowerLabel.text += "-" + str(int(amount * 100)) + "%"
		elif(operation == Operation.SUB):
			$PowerLabel.text += "+" + str(int(amount * 100)) + "%"
		elif(operation == Operation.MULT):
			$PowerLabel.text += "x" + str(1 / amount - 1) + "%"
		elif(operation == Operation.DIV):
			$PowerLabel.text += "/" + str(1 / amount - 1) + "%"
		
		$PowerLabel.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stop_moving:
		return
		
	var velocity = Vector2.ZERO
	velocity.y += 35
	position += velocity * delta

#set the power up type of either power or projectile speed
func set_type(newType : String):
	if(newType == "POWER"):
		type = PowerUpType.POWER
	elif(newType == "FIRE_RATE"):
		type = PowerUpType.FIRE_RATE

#set the amount to increase
func set_amount(amt : int):
	amount = amt

#Set operation
func set_operation(op : String):
	if(op == "+"):
		operation = Operation.ADD
	elif(op == "-"):
		operation = Operation.SUB
	elif(op == "/"):
		operation = Operation.DIV
	elif(op == "*"):
		operation = Operation.MULT

func _on_area_entered(area: Area2D) -> void:
	if opened:
		return
	
	opened = true
	$DeleteTimer.start()
	$ChestOpen.play()
	$AnimatedSprite2D.play()
	if area.is_in_group("player"):
		if(type == PowerUpType.POWER):
			if(operation == Operation.ADD):
				area.set_power(area.power + amount)
			elif(operation == Operation.SUB):
				area.set_power(area.power - amount)
			elif(operation == Operation.MULT):
				area.set_power(area.power * amount)
			elif(operation == Operation.DIV):
				area.set_power(area.power / amount)
		elif(type == PowerUpType.FIRE_RATE):
			if(operation == Operation.ADD):
				area.set_fire_rate(area.shoot_cooldown + amount)
			elif(operation == Operation.SUB):
				area.set_fire_rate(area.shoot_cooldown - amount)
			elif(operation == Operation.MULT):
				area.set_fire_rate(area.shoot_cooldown * amount)
			elif(operation == Operation.DIV):
				area.set_fire_rate(area.shoot_cooldown / amount)


func _on_delete_timer_timeout() -> void:
	queue_free()
