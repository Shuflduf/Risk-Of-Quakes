extends MarginContainer

@onready var sens_slider: HSlider = %SensSlider
@onready var sens_spin_box: SpinBox = %SensSpinBox
@onready var fov_slider: HSlider = %FOVSlider
@onready var fov_spin_box: SpinBox = %FOVSpinBox
@onready var window_mode_option: OptionButton = %WindowModeOption
@onready var vsync_check: CheckBox = %VSyncCheck

@onready var pairs = {
	&"sensitivity": [sens_slider, sens_spin_box],
	&"fov": [fov_slider, fov_spin_box],
}
@onready var options = {
	&"window_mode": window_mode_option,
}
@onready var toggles = {
	&"vsync": vsync_check,
}

#func _process(delta: float) -> void:
#if visible:


func _ready() -> void:
	for setting in pairs:
		var setting_controllers = pairs[setting]
		setting_controllers[0].value = Settings.get(setting)
		setting_controllers[1].value = Settings.get(setting)
		setting_controllers[0].value_changed.connect(
			func(value: float):
				setting_controllers[1].value = value
				Settings.set(setting, value)
		)
		setting_controllers[1].value_changed.connect(
			func(value: float):
				setting_controllers[0].value = value
				Settings.set(setting, value)
		)
	for setting in options:
		var setting_controller = options[setting]
		setting_controller.selected = Settings.get(setting)
		setting_controller.item_selected.connect(func(index: int): Settings.set(setting, index))
	for setting in toggles:
		var setting_controller = toggles[setting]
		setting_controller.button_pressed = Settings.get(setting)
		setting_controller.toggled.connect(
			func(toggled_on: bool): Settings.set(setting, toggled_on)
		)
