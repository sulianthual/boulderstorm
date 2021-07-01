extends Node2D

################

var xplist=[80,240,400]# player x-positions on grid
var yplist=[80,240,400]# player y-positions on grid
var xpaoff=100# offset for arrow display
var ypaoff=100# offset for arrow display

################
# Called when the node enters the scene tree for the first time.
func _ready():
	scale= Vector2(0.75,0.75)# change player scale
	hide()# hide player by default

################
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


################

# Place player on screen: 
# ip, jp : position on grid (0-2,0-2)
# sp: state = stand, aiming, hit, hitaiming, dead (0-4)
# op : orientation (0-3 for r,u,l,d)
func place(ip,jp,sp,op):
	show()
	position.x=xplist[ip]
	position.y=yplist[jp]
	# Player is standing 
	if sp == 0:
		$ArrowSprite.hide()
		$HurtSprite.hide()
		if op == 0: 
			$AnimatedSprite.animation="right"
		elif op == 1:
			$AnimatedSprite.animation="up"
		elif op == 2:
			$AnimatedSprite.animation="left"
		elif op == 3:
			$AnimatedSprite.animation="down"
	# Player is wanting to move
	elif sp == 1:
		$HurtSprite.hide()
		if op == 0: 
			$AnimatedSprite.animation="right"
			$ArrowSprite.animation="right"
			$ArrowSprite.offset=Vector2(xpaoff,0)
			if ip<2:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 1:
			$AnimatedSprite.animation="up"
			$ArrowSprite.animation="up"
			$ArrowSprite.offset=Vector2(0,-ypaoff)
			if jp>0:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 2:
			$AnimatedSprite.animation="left"
			$ArrowSprite.animation="left"
			$ArrowSprite.offset=Vector2(-xpaoff,0)
			if ip>0:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 3:
			$AnimatedSprite.animation="down"
			$ArrowSprite.animation="down"
			$ArrowSprite.offset=Vector2(0,ypaoff)
			if jp<2:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
	# Player is hurt
	elif sp == 2:
		$ArrowSprite.hide()
		$HurtSprite.show()
		if op == 0: 
			$AnimatedSprite.animation="right"
		elif op == 1:
			$AnimatedSprite.animation="up"
		elif op == 2:
			$AnimatedSprite.animation="left"
		elif op == 3:
			$AnimatedSprite.animation="down"
	# Player is hurst/ wanting to move
	elif sp == 3:
		$HurtSprite.show()
		if op == 0: 
			$AnimatedSprite.animation="right"
			$ArrowSprite.animation="right"
			$ArrowSprite.offset=Vector2(xpaoff,0)
			if ip<2:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 1:
			$AnimatedSprite.animation="up"
			$ArrowSprite.animation="up"
			$ArrowSprite.offset=Vector2(0,-ypaoff)
			if jp>0:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 2:
			$AnimatedSprite.animation="left"
			$ArrowSprite.animation="left"
			$ArrowSprite.offset=Vector2(-xpaoff,0)
			if ip>0:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
		elif op == 3:
			$AnimatedSprite.animation="down"
			$ArrowSprite.animation="down"
			$ArrowSprite.offset=Vector2(0,ypaoff)
			if jp<2:
				$ArrowSprite.show()
			else:
				$ArrowSprite.hide()
	# Player is dead
	elif sp == 4: 
		$ArrowSprite.hide()
		$HurtSprite.hide()
		$AnimatedSprite.animation="dead"
	else:
		hide()

# Change animation speed
func setspeedscale(speedscale):
	$AnimatedSprite.set_speed_scale(speedscale)# speed up animations
	
################

