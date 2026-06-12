extends Control

signal resume_requested
signal save_requested
signal load_requested
signal save_and_return_requested

@onready var save_button: Button = $CenterContainer/Panel/MenuBox/SaveButton
@onready var load_button: Button = $CenterContainer/Panel/MenuBox/LoadButton
@onready var save_and_return_button: Button = $CenterContainer/Panel/MenuBox/SaveAndReturnButton
@onready var resume_button: Button = $CenterContainer/Panel/MenuBox/ResumeButton
@onready var status_label: Label = $CenterContainer/Panel/MenuBox/StatusLabel


func _ready() -> void:
	save_button.pressed.connect(_on_save_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	save_and_return_button.pressed.connect(_on_save_and_return_button_pressed)
	resume_button.pressed.connect(_on_resume_button_pressed)


func grab_default_focus() -> void:
	save_button.grab_focus()


func set_status_text(text: String) -> void:
	status_label.text = text


func _on_save_button_pressed() -> void:
	save_requested.emit()


func _on_load_button_pressed() -> void:
	load_requested.emit()


func _on_save_and_return_button_pressed() -> void:
	save_and_return_requested.emit()


func _on_resume_button_pressed() -> void:
	resume_requested.emit()
