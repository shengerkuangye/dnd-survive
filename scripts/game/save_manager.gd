extends Node

const SAVE_SLOT_NAMES := ["存档 1", "存档 2", "存档 3"]


func get_slot_name(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= SAVE_SLOT_NAMES.size():
		return ""
	return SAVE_SLOT_NAMES[slot_index]
