extends Node2D

var xblist=[80,240,400]# boulder x-positions on grid
var yblist=[80,240,400]# boulder y-positions on grid
var dxb=80
var dyb=80

# init
func _ready():
	scale= Vector2(0.75,0.75)# change boulder scale
	hide()# hide by default



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Place smoke on screen: 
# ib, jb : position on grid (0-2,0-2)
# op = orientation
# sb: state = hide, show, (0-1)
func place(ib,jb,op,sb):
	position.x=xblist[ib]
	position.y=yblist[jb]
	if sb == 0:
		hide()
	elif sb == 1:
		show()
		if op == 0: 
			$AnimatedSprite.animation="right"
			position.x += dxb
		elif op == 1:
			$AnimatedSprite.animation="up"
			position.y -= dyb
		elif op == 2:
			$AnimatedSprite.animation="left"
			position.x -= dxb
		elif op == 3:
			$AnimatedSprite.animation="down"
			position.y += dyb
		$HideTimer.start()

		
# kill self after timer
func _on_HideTimer_timeout():
	$AnimatedSprite.hide()
	$HideTimer.stop()
	kill()

# Change animation speed
func setspeedscale(speedscale):
	$AnimatedSprite.set_speed_scale(speedscale)# speed up animations
	
# kill  (and all its potential childrens)
func kill():
	for child in get_children():
		child.queue_free()
	queue_free()


