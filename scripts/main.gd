extends Node2D

@onready var node_2d: Node2D = $Node2D
@onready var order_scene: Node2D = $OrderScene
@onready var title_screen: Node2D = $TitleScreen
@onready var end_screen: Node2D = $EndScreen
signal resetAll

func _on_title_screen_start() -> void:
	title_screen.hide()
	order_scene.show()
	node_2d.clearEquations()
	node_2d.show()
	order_scene.startTimers()

func _on_order_scene_game_over(score) -> void:
	node_2d.hide()
	order_scene.hide()
	title_screen.hide()
	end_screen.show()
	end_screen.display(score)


func _on_end_screen_play_again() -> void:
	resetAll.emit()
	end_screen.hide()
	order_scene.show()
	node_2d.show()
