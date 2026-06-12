extends Control

signal start_requested

@onready var press_hint_label: Label = $CoverContent/CenterContainer/CoverBox/PressHintLabel
@onready var menu_box: VBoxContainer = $CoverContent/CenterContainer/CoverBox/MenuBox
@onready var continue_button: Button = $CoverContent/CenterContainer/CoverBox/MenuBox/ContinueButton
@onready var settings_button: Button = $CoverContent/CenterContainer/CoverBox/MenuBox/SettingsButton
@onready var exit_button: Button = $CoverContent/CenterContainer/CoverBox/MenuBox/ExitButton
@onready var settings_panel: PanelContainer = $CoverContent/SettingsPanel
@onready var volume_slider: HSlider = $CoverContent/SettingsPanel/SettingsBox/VolumeSlider
@onready var size_1280_button: Button = $CoverContent/SettingsPanel/SettingsBox/Size1280Button
@onready var size_1600_button: Button = $CoverContent/SettingsPanel/SettingsBox/Size1600Button
@onready var size_1920_button: Button = $CoverContent/SettingsPanel/SettingsBox/Size1920Button
@onready var back_button: Button = $CoverContent/SettingsPanel/SettingsBox/BackButton

var menu_revealed := false


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	volume_slider.value_changed.connect(_on_volume_slider_value_changed)
	size_1280_button.pressed.connect(_on_size_1280_button_pressed)
	size_1600_button.pressed.connect(_on_size_1600_button_pressed)
	size_1920_button.pressed.connect(_on_size_1920_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	get_window().unresizable = true


func _input(event: InputEvent) -> void:
	if menu_revealed:
		return

	if event is InputEventKey and event.pressed:
		_show_main_menu()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed:
		_show_main_menu()
		get_viewport().set_input_as_handled()


func _show_main_menu() -> void:
	menu_revealed = true
	press_hint_label.visible = false
	menu_box.visible = true
	continue_button.grab_focus()


func show_main_menu() -> void:
	settings_panel.visible = false
	_show_main_menu()


func _on_continue_button_pressed() -> void:
	start_requested.emit()


func _on_settings_button_pressed() -> void:
	settings_panel.visible = true
	volume_slider.grab_focus()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_volume_slider_value_changed(value: float) -> void:
	if value <= 0.0:
		AudioServer.set_bus_volume_db(0, -80.0)
	else:
		AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))


func _on_size_1280_button_pressed() -> void:
	_apply_window_size(Vector2i(1280, 720))


func _on_size_1600_button_pressed() -> void:
	_apply_window_size(Vector2i(1600, 900))


func _on_size_1920_button_pressed() -> void:
	_apply_window_size(Vector2i(1920, 1080))


func _apply_window_size(size: Vector2i) -> void:
	var window := get_window()
	window.unresizable = true
	window.size = size
	window.move_to_center()


func _on_back_button_pressed() -> void:
	settings_panel.visible = false
	settings_button.grab_focus()
