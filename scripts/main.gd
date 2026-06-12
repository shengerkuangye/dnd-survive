extends Control

@onready var cover = $Cover
@onready var game_root: Control = $GameRoot


func _ready() -> void:
	game_root.visible = false
	cover.start_requested.connect(_on_cover_start_requested)
	game_root.return_to_main_menu_requested.connect(_on_game_return_to_main_menu_requested)


func _on_cover_start_requested() -> void:
	cover.visible = false
	game_root.visible = true


func _on_game_return_to_main_menu_requested() -> void:
	game_root.visible = false
	cover.visible = true
	cover.show_main_menu()
