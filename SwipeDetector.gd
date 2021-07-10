extends Node
signal swiped(direction)
signal swiped_canceled(start_position)
# used to detect if diagonal swipe (that doesnt count)
export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3
# timer object
onready var timer = $SwipeTimer
var swipe_start_position= Vector2()


###############

###############
# init


# reset(externally)
func reset():
	timer.stop()
#	swipe_start_position=Vector2()

# function whenever any input is pressed
func _input(event):
	# omit anything not a ScreenTouch
	if not event is InputEventScreenTouch:
		return
	# pressed: user starts swipe
	if event.pressed:
		_start_detection(event.position)
#		print('swipe detector start')
	# not pressed and still timer: user ends swipe
	elif not timer.is_stopped():
		_end_detection(event.position)
#		print('swipe detector end')
	
# start a swipe
func _start_detection(position):
	swipe_start_position = position
	timer.start()

# end a swipe
func _end_detection(position):
	timer.stop()
	# compute swipe direction
	var direction = (position - swipe_start_position).normalized()
	# if swipe was diagonal: do nothing
	if abs(direction.x) + abs(direction.y)>= MAX_DIAGONAL_SLOPE:
		return
	# check swipe direction
	if abs(direction.x)>abs(direction.y):
		# horizontal
#		emit_signal( 'swiped', Vector2(-sign(direction.x),0.0) )
		if sign(direction.x)>0:
			emit_signal( 'swiped', 'right' )
		else:
			emit_signal( 'swiped', 'left' )
	else:
		# vertical
#		emit_signal( 'swiped', Vector2(0.0,-sign(direction.y)) )
		if sign(direction.y)>0:
			emit_signal( 'swiped', 'down' )
		else:
			emit_signal( 'swiped', 'up' )
	

# stay pressed: swipe canceled (dont really need this)
func _on_SwipeTimer_timeout():
	emit_signal('swiped_canceled', swipe_start_position)

# If Pause, cancel the swipes
func _on_PauseButton_toggled(button_pressed):
	pass
#	reset()
#	print('pause button signal: too late to cancel swipe')

