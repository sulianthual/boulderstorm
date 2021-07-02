extends Node

var dowindowed=not OS.window_fullscreen

func _ready():
	if dowindowed==true:
		$FullScreenIconButton.set_pressed(false)
	else:
		$FullScreenIconButton.set_pressed(true)

# toggle fullscreen from icon
func _on_FullScreenIconButton_toggled(button_pressed):
	$FullScreenIconSound.play()
	if button_pressed==true:
		dowindowed=false
	else:
		dowindowed=true
	if dowindowed ==false:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


