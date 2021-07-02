extends Node2D

# init
func _ready():
	scale= Vector2(0.5,0.5)# change scale
	#hide()# hide by default

# update
#func _process(delta):
#	pass

# Place on screen: 
# xb, yb : position on screen
# sb: state = hide, show
func place(xb,yb,sb):
	position.x=xb
	position.y=yb
	if sb == 0:
		hide()
	elif sb == 1:
		show()
		$AnimatedSprite.animation="heart"

# Change animation speed
func setspeedscale(speedscale):
	$AnimatedSprite.set_speed_scale(speedscale)# speed up animations
	
# kill smoke (and all its potential childrens)
func kill():
	for child in get_children():
		child.queue_free()
	queue_free()
