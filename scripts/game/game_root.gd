extends Control

signal return_to_main_menu_requested

@onready var camp_screen: Control = $RootContainer/Content/CampScreen
@onready var map_screen: Control = $RootContainer/Content/MapScreen
@onready var camp_button: Button = $RootContainer/TopBar/TopBarContent/CampButton
@onready var map_button: Button = $RootContainer/TopBar/TopBarContent/MapButton
@onready var title_label: Label = $RootContainer/TopBar/TopBarContent/TitleLabel
@onready var pause_menu = $PauseMenu


func _ready() -> void:
	camp_button.pressed.connect(_show_camp)
	map_button.pressed.connect(_show_map)
	pause_menu.resume_requested.connect(_hide_pause_menu)
	pause_menu.save_requested.connect(_on_save_requested)
	pause_menu.load_requested.connect(_on_load_requested)
	pause_menu.save_and_return_requested.connect(_on_save_and_return_requested)
	_show_camp()


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_toggle_pause_menu()
		get_viewport().set_input_as_handled()


func _show_camp() -> void:
	camp_screen.visible = true
	map_screen.visible = false
	title_label.text = "营地"


func _show_map() -> void:
	camp_screen.visible = false
	map_screen.visible = true
	title_label.text = "地图"


func _toggle_pause_menu() -> void:
	pause_menu.visible = not pause_menu.visible
	if pause_menu.visible:
		pause_menu.grab_default_focus()


func _hide_pause_menu() -> void:
	pause_menu.visible = false


func _on_save_requested() -> void:
	pause_menu.set_status_text("保存占位：之后会接入存档系统。")


func _on_load_requested() -> void:
	pause_menu.set_status_text("加载占位：之后会接入存档系统。")


func _on_save_and_return_requested() -> void:
	pause_menu.set_status_text("保存并返回主界面占位。")
	pause_menu.visible = false
	return_to_main_menu_requested.emit()
