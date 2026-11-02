@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("SpriteFontLabel", "Control", preload("SpriteFontLabel.gd"), null)

func _exit_tree() -> void:
	remove_custom_type("SpriteFontLabel")
