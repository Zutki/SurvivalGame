extends AudioStreamPlayer


func _ready():
	AudioServer.set_device(AudioServer.get_device_list()[0])
