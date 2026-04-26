extends MarginContainer

@onready var sens_slider: HSlider = %SensSlider
@onready var sens_spin_box: SpinBox = %SensSpinBox
@onready var fov_slider: HSlider = %FOVSlider
@onready var fov_spin_box: SpinBox = %FOVSpinBox

@onready var pairs = {
	&"sensitivity": [sens_slider, sens_spin_box],
	&"fov": [fov_slider, fov_spin_box],
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
