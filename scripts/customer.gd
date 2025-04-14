extends Node2D

# var timer = get_children()[get_children().rfind(Timer)]
var pepperoniEquation = null
var mushroomEquation = null
var onionEquation = null
var greenEquation = null
var pineappleEquation = null
var animationNum = 1
const ORDER = preload("res://order.tscn")
@onready var timer: Timer = $Timer
@onready var animation_timer: Timer = $AnimationTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var speech_bubble: Sprite2D = $SpeechBubble
signal animationOver(customer: Node2D)

signal timeout(node: Node2D)
var order
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = load("res://pics/customer" + str(randi_range(1, 9)) + ".png")
	pepperoniEquation = generateEquation()
	mushroomEquation = generateEquation()
	onionEquation = generateEquation()
	greenEquation = generateEquation()
	pineappleEquation = generateEquation()
	order = ORDER.instantiate()
	order.pepLabel = pepperoniEquation
	order.mushLabel = mushroomEquation
	order.onionLabel = onionEquation
	order.greenLabel = greenEquation
	order.pineLabel = pineappleEquation
	add_child(order)
	#order.hide()
	order.mushroom_container.hide()
	order.onion_container.hide()
	order.green_container.hide()
	order.pineapple_container.hide()
	order.time_remaining_label.hide()
	order.time_remaining_bar.hide()
	order.pizzaButton.hide()
	order.order_id_label.hide()
	timer.wait_time = randi_range(60, 90)
	order.totalTime = timer.wait_time
	timer.start()
	animation_timer.start()
	order.scale.x = 1.5
	order.scale.y = 1.5
	order.set_position(Vector2(330, 400), false)

func _process(delta: float) -> void:
	if (order != null):
		if (order.is_visible()):
			if (order.time_remaining_label != null):
				order.time_remaining_label.text = str(int(timer.time_left)) + "s"
	

func validateEquation(equation: String) -> bool:
	var expression = Expression.new()
	expression.parse(equation)
	var result = expression.execute()
	#print(result)
	if (not expression.has_execute_failed()):
		if (result <= 0 or typeof(result) != 2 or result > 10):
			return false
	return true

func generateEquation() -> String:
	var parentheses: int = randi_range(0, 2)
	var equation: String = ""
	var length: int = randi_range(1, 2)
	
	for i in length:
		equation += str(randi_range(1, 7)) + generateOperator()
	equation += str(randi_range(1, 7))
	
	while (not validateEquation(equation)):
		equation = ""
		for i in length:
			equation += str(randi_range(1, 9)) + generateOperator()
		equation += str(randi_range(1, 9))
		if (length > 1):
			if (parentheses == 1):
				equation = equation.insert(0, "(")
				equation = equation.insert(4, ")")
			if (parentheses == 2):
				equation = equation.insert(2, "(")
				equation = equation.insert(6, ")")
			#print(equation)
	return equation

func generateOperator() -> String:
	var rand = randi_range(1, 3)
	if (rand == 1):
		return "+"
	if (rand == 2):
		return "-"
	if (rand == 3):
		return "*"
	return "/"

func _on_timer_timeout() -> void:
	timeout.emit(self)

func showOrder(num: int) -> void:
	#print("doing something")
	order.show()
	
	#order.pepperoni_container.show()
	#order.mushroom_container.show()
	#order.onion_container.show()
	#order.green_container.show()
	#order.pineapple_container.show()
	order.pineapple_container.hide()
	order.order_id_label.text = "Order #" + str(num)
	order.order_id_label.show()
	#order.time_remaining_label.show()
	order.time_remaining_bar.show()
	order.pizzaButton.show()

func _on_animation_timer_timeout() -> void:
	if (animationNum == 0):
		order.pepperoni_container.show()
		order.mushroom_container.hide()
		order.onion_container.hide()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 1):
		order.pepperoni_container.hide()
		order.mushroom_container.show()
		order.onion_container.hide()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 2):
		order.pepperoni_container.hide()
		order.mushroom_container.hide()
		order.onion_container.show()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 3):
		order.pepperoni_container.hide()
		order.mushroom_container.hide()
		order.onion_container.hide()
		order.green_container.show()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 4):
		order.pepperoni_container.hide()
		order.mushroom_container.hide()
		order.green_container.hide()
		order.pineapple_container.show()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	else:
		order.hide()
	if (animationNum > 4):
		animationOver.emit(self)
		animation_timer.wait_time = 100
		animation_timer.stop()
		animation_timer.one_shot = true
	animationNum += 1
		
