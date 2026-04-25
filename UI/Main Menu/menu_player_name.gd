extends HBoxContainer

var text:
	set(new_val):
		text = new_val
		$Label.text = text

var selected:
	set(new_val):
		selected = new_val
		$CheckBox.button_pressed = new_val
