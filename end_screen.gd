extends Node2D

signal playAgain
@onready var label: Label = $EndScreen/Label
@onready var end_screen: Control = $EndScreen


func display(score) -> void:
	end_screen.display(score)

func _on_play_again_button_pressed() -> void:
	playAgain.emit()
