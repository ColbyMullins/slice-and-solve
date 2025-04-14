extends Control

@export var pepLabel: String
@export var mushLabel: String
@export var onionLabel: String
@export var greenLabel: String
@export var pineLabel: String
@onready var pepperoni_label: Label = $MarginContainer/VBoxContainer/PepperoniContainer/PepperoniLabel
@onready var pepperoni_sprite: TextureRect = $MarginContainer/VBoxContainer/PepperoniContainer/PepperoniSprite
@onready var mushroom_label: Label = $MarginContainer/VBoxContainer/MushroomContainer/MushroomLabel
@onready var mushroom_sprite: TextureRect = $MarginContainer/VBoxContainer/MushroomContainer/MushroomSprite
@onready var onion_label: Label = $MarginContainer/VBoxContainer/OnionContainer/OnionLabel
@onready var onion_sprite: TextureRect = $MarginContainer/VBoxContainer/OnionContainer/OnionSprite
@onready var green_label: Label = $MarginContainer/VBoxContainer/GreenContainer/GreenLabel
@onready var green_sprite: TextureRect = $MarginContainer/VBoxContainer/GreenContainer/GreenSprite
@onready var pineapple_label: Label = $MarginContainer/VBoxContainer/PineappleContainer/PineappleLabel
@onready var pineapple_sprite: TextureRect = $MarginContainer/VBoxContainer/PineappleContainer/PineappleSprite
@onready var time_remaining_label: Label = $MarginContainer/VBoxContainer/TimeRemainingLabel
@onready var pepperoni_container: HBoxContainer = $MarginContainer/VBoxContainer/PepperoniContainer
@onready var mushroom_container: HBoxContainer = $MarginContainer/VBoxContainer/MushroomContainer
@onready var onion_container: HBoxContainer = $MarginContainer/VBoxContainer/OnionContainer
@onready var green_container: HBoxContainer = $MarginContainer/VBoxContainer/GreenContainer
@onready var pineapple_container: HBoxContainer = $MarginContainer/VBoxContainer/PineappleContainer
@onready var pizzaButton: Button = $MarginContainer/VBoxContainer/OrderButton
@onready var order_button: Button = $MarginContainer/VBoxContainer/OrderButton
@onready var time_remaining_bar: ProgressBar = $MarginContainer/VBoxContainer/TimeRemainingBar
@onready var order_id_label: Label = $MarginContainer/VBoxContainer/OrderIdContainer/OrderIdLabel

var pepNum
var mushNum
var onionNum
var totalTime
var currentTime
@onready var order_rack: HBoxContainer = get_node("/root/Main/OrderScene/Control/OrderRack")
@onready var manager: Node = get_node("/root/Main/Node2D/Manager")
const RED_STYLEBOX = preload("res://resources/redStylebox.tres")

signal orderSignal(pep, mush, onion, green, pine)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pepperoni_label.text = pepLabel
	mushroom_label.text = mushLabel
	onion_label.text = onionLabel
	green_label.text = greenLabel
	pineapple_label.text = pineLabel
	orderSignal.connect(manager.managerSetEquations)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime = float(time_remaining_label.text.split("s")[0])
	time_remaining_bar.value = currentTime / totalTime * 100
	if time_remaining_bar.value < 25:
		time_remaining_bar.add_theme_stylebox_override("fill", RED_STYLEBOX)

func _on_order_button_pressed() -> void:
	orderSignal.emit(pepLabel, mushLabel, onionLabel, greenLabel, pineLabel)
	queue_free()
