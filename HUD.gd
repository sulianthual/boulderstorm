extends CanvasLayer
export (PackedScene) var Heart
signal custom_on_EndButton_pressed
signal custom_on_TutorialContinueButton_pressed
################

var hpmax=5# max health
var xhp0=110# grid for placing hearts
var dxhp=50
var yhp0=530
var dyhp=0
var hpd={}# dictionary of heart instances (labelled as "i")

################

# init
func _ready():
	if Main.dotutorial:
		start_tutorial()# start new game
	else:
		start()# start new game

# regular start
func start():
	# head
	$HeadHUD.animation="base"
	$HeadHUD.scale= Vector2(0.75,0.75)# change scale
	$HeadHUD.position.x= 50
	$HeadHUD.position.y= yhp0
	$HeadHUD.show()
	# hearts
	for k in range(hpmax):
		addheart(k)
		setheart(k,0)#hide
	# score (boulder count)
	$BoulderHUD.animation="base"
	$BoulderHUD.scale= Vector2(0.6,0.6)# change scale
	$BoulderHUD.position.x= 50
	$BoulderHUD.position.y= 610
	$BoulderCount.text="0"
	$BoulderCount.rect_position.x=100
	$BoulderCount.rect_position.y=585
	# Dead message
	$Text.hide()
	$EndButton.hide()
	# Continue 
	$TutorialContinueButton.hide()

# tutorial start
func start_tutorial():
	# head
	$HeadHUD.hide()
	# hearts
#	for k in range(hpmax):
#		addheart(k)
#		setheart(k,0)#hide
	# score (boulder count)
	$BoulderHUD.hide()
	$BoulderCount.hide()
	$EndButton.hide()
	# Continue 
	$TutorialContinueButton.hide()
	$TutorialContinueTimer.start()
	# Text
	$Text.show()
	$Text.align=Label.ALIGN_FILL

# Continue tutorial button appears
func _on_TutorialContinueTimer_timeout():
	$TutorialContinueButton.show()
	$TutorialContinueTimer.stop()

# update
#func _process(delta):
#	pass

################
# signals

# emit signal to higher
func _on_EndButton_pressed():
	emit_signal('custom_on_EndButton_pressed')

func _on_TutorialContinueButton_pressed():
	emit_signal('custom_on_TutorialContinueButton_pressed')

################

# update health display
func showhealth(hp):
	for k in range(hpmax):
		if k<hp:
			setheart(k,1)#show
		else:
			setheart(k,0)#hide

# update boulder count display
func showscore(score):
	$BoulderCount.text=str(score)

func showdeadmessage(score):
	$Text.show()
	$Text.align=Label.ALIGN_CENTER
	$Text.text='You Died  \nScore: '+str(score)
	$EndButton.show()
	# hide the rest
	$BoulderCount.hide()
	$BoulderHUD.hide()
	$HeadHUD.hide()

################

# make one new boulder at given index (ib>=0)
func addheart(kb):
	var heart=Heart.instance()
	add_child(heart)# add to scene
	hpd[str(kb)]=heart# add to instances dictionary
	setheart(kb,1)

# (re)set boulder position and state (0-1 for hide,show)
func setheart(kb,sp):
	if str(kb) in hpd.keys():
		hpd[str(kb)].place( kb*dxhp+xhp0,kb*dyhp+yhp0,sp)

# remove heart from scene (shouldnt be used, hide the heart instead)
func removeheart(kb):
	if str(kb) in hpd.keys():
		hpd[str(kb)].kill()# kill heart









