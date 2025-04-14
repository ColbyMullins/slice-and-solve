extends Control

signal playAgain
@onready var label: Label = $Label

func display(score) -> void:
	label.text = "Final score: $" + str(score)
	
	
func _on_play_again_button_pressed() -> void:
	playAgain.emit()
