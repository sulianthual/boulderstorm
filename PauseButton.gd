extends Button

# Note: in inspector, we have changed pause mode:
# Inherit (get from parent)->Process (still processed during pause)


# When pause button pressed, pauses entire tree
func _on_PauseButton_toggled(button_pressed):
	if button_pressed:
		get_tree().paused  = true
		text= 'resume'
	else:
		get_tree().paused  = false
		text='pause'
#	
