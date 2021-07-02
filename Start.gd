extends Node

################

################


# init
func _ready():
	# connect scene to Main (scene tree)
	# wait time to start once press start
	$StartTimer.wait_time=0.5

# update
func _process(delta):
	devcontrols()

# developper controls
func devcontrols():
	pass
#	if Input.is_action_pressed("ui_up"):
#		Main.to_play()
#	elif Input.is_action_pressed("ui_left"):
#		Main.to_tutorial()
#	elif Input.is_action_pressed("ui_down"):
#		Main.to_quit()
		
# Start Game
func _on_StartButton_pressed():
	$StartTimer.start()
	$StartSound.play()
func _on_StartTimer_timeout():
	$StartTimer.stop()
	Main.to_play()# call to global

# to Tutorial
func _on_TutorialButton_pressed():
	Main.to_tutorial()# call to global

	

# Quit Game
func _on_ExitButton_pressed():
	Main.to_quit()# call to global
