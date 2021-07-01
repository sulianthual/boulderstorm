extends Node2D

var xblist=[80,240,400]# boulder x-positions on grid
var yblist=[80,240,400]# boulder y-positions on grid

# init
func _ready():
	scale= Vector2(0.75,0.75)# change boulder scale
	#hide()# hide by default


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Place fall on screen: 
# ib, jb : position on grid (0-2,0-2)
# sb: state = empty,stand,decay (0-2)
func place(ib,jb,sb):
	position.x=xblist[ib]
	position.y=yblist[jb]
	if sb == 0:
		hide()
	elif sb == 1:
		show()
		$AnimatedSprite.animation="fall"
	elif sb == 2:
		show()
		$AnimatedSprite.animation="fall"

# kill fall (and all its potential childrens)
func kill():
	for child in get_children():
		child.queue_free()
	queue_free()
