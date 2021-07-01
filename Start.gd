extends Node

################

################


# init
func _ready():
	# connect scene to Main (scene tree)
	# wait time to start once press start
	$StartTimer.wait_time=0.5

# update
#func _process(delta):
#	pass

# Start Game
func _on_StartButton_pressed():
	$StartTimer.start()
	$StartSound.play()
func _on_StartTimer_timeout():
	$StartTimer.stop()
	Main.to_play()# call to global

# to Tutorial
func _on_TutorialButton_pressed():
	$TutorialTimer.start()
	$StartSound.play()
func _on_TutorialTimer_timeout():
	$StartTimer.stop()
	Main.to_tutorial()# call to global

# Quit Game
func _on_ExitButton_pressed():
	Main.to_quit()# call to global
