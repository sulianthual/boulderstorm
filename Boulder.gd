extends Node2D

var xblist=[80,240,400]# boulder x-positions on grid
var yblist=[80,240,400]# boulder y-positions on grid

################


# init
func _ready():
	scale= Vector2(0.75,0.75)# change boulder scale
	#hide()# hide by default


# Place boulder on screen: 
# ib, jb : position on grid (0-2,0-2)
# sb: state = empty, warn, stand, decay (0-3)
func place(ib,jb,sb):
	position.x=xblist[ib]
	position.y=yblist[jb]
	if sb == 0:
		hide()
	elif sb == 1:
		show()
		$AnimatedSprite.animation="warn"
	elif sb == 2:
		show()
		$AnimatedSprite.animation="stand"
	elif sb == 3:
		show()
		$AnimatedSprite.animation="decay"
	else:
		hide()

# kill boulder (and all its potential childrens)
func kill():
	for child in get_children():
		child.queue_free()
	queue_free()


