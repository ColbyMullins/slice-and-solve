extends Node2D

const CUSTOMER = preload("res://customer.tscn")
var customers = []
var score = 0
var orderNum = 1
signal forceClosePizza
signal gameOver(score: int)
@onready var customer_container: Node = $CustomerContainer
@onready var score_label: Label = $Control/ScoreLabel
@onready var order_rack: HBoxContainer = %OrderRack
@onready var customer_button: Button = $Control/CustomerButton
@onready var time_left_label: Label = $Control/TimeLeftLabel
@onready var game_over_timer: Timer = $GameOverTimer
@onready var customer_num_label: Label = $Control/CustomerNumLabel
@onready var order_timer: Timer = $OrderTimer
@onready var customer_sound: AudioStreamPlayer2D = $CustomerSound
var customerNum: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	time_left_label.text = "Time left: " + str(int(game_over_timer.time_left)) + "s"
	if (game_over_timer.time_left < 30):
		time_left_label.add_theme_color_override("font_color", Color(255, 0, 0))
	else:
		time_left_label.add_theme_color_override("font_color", Color(0, 0, 0))

func _on_customer_button_pressed() -> void:
	if customerNum >= 1:
		var new_customer = CUSTOMER.instantiate()
		#new_customer.hide()
		new_customer.connect("timeout", handleCustomerTimeout)
		new_customer.connect("animationOver", handleAnimationOver)
		customer_container.add_child(new_customer)
		#order_rack.add_child(new_customer.order)
		customer_button.disabled = true
		for child in order_rack.get_children():
			child.order_button.disabled = true
		customerNum -= 1
		updateCustomerLabel()
	
func updateCustomerLabel() -> void:
	customer_num_label.text = "Customers waiting: " + str(customerNum)

func handleCustomerTimeout(customer: Node2D) -> void:
	if (customer.order != null):
		order_rack.remove_child(customer.order)
	customer.queue_free()
	#show()
	#forceClosePizza.emit()
	updateScore(-5)

func handleAnimationOver(customer: Node2D) -> void:
	#print("test")
	customer.showOrder(orderNum)
	var order = customer.order
	customer.remove_child(order)
	order_rack.add_child(order)
	#print(customer.order)
	customer.show()
	customer.sprite.hide()
	customer.speech_bubble.hide()
	customer.showOrder(orderNum)
	orderNum += 1
	customer.timer.start()
	customer_button.disabled = false
	for child in order_rack.get_children():
		child.order_button.disabled = false

func _on_node_2d_pizza_mode() -> void:
	#hide()
	pass

func updateScore(num: int) -> void:
	score += num
	score_label.text = "Score: $" + str(score)

func _on_node_2d_leave_pizza_mode(win: bool) -> void:
	show()
	if (win):
		updateScore(1)

func startTimers():
	game_over_timer.start()
	order_timer.start()

func _on_game_over_timer_timeout() -> void:
	gameOver.emit(score)
	order_timer.stop()

func _on_main_reset_all() -> void:
	game_over_timer.start()
	order_timer.start()
	customerNum = 1
	updateCustomerLabel()
	for child in order_rack.get_children():
		child.queue_free()
	score = 0


func _on_node_2d_score_signal(score) -> void:
	updateScore(score)


func _on_order_timer_timeout() -> void:
	customerNum += 1
	updateCustomerLabel()
	customer_sound.play()
