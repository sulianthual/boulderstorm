extends CanvasLayer
export (PackedScene) var HeartHUD
signal custom_on_EndButton_pressed
signal custom_on_TutorialContinueButton_pressed
################

var hpmax=7# max health
var dxhp=56
var xhp0=240+dxhp/2#110# grid for placing hearts
var ihp0=3# increment offset
var yhp0=520
var dyhp=0
var hpd={}# dictionary of heart instances (labelled as "i")
var hdshow=true# show the hp head
var hpshow=true# show the hp hearts (can be toggled)


################

# init
func _ready():
	# head
	$HeadHUD.animation="base"
	$HeadHUD.scale= Vector2(0.7,0.7)# change scale
	$HeadHUD.position.x= (-1-ihp0)*dxhp+xhp0
	$HeadHUD.position.y= yhp0-2
	# hearts
	hpshow=true
	for k in range(hpmax):
		addheart(k)
		setheart(k,0)#hide by default
	# score (boulder count)
	$BoulderHUD.animation="base"
	$BoulderHUD.scale= Vector2(0.7,0.7)# change scale
	$BoulderCount.text="0"
	# Level
	$LevelCount.text='Lvl 1'
	#
	if Main.dotutorial:
		start_tutorial()# start new game
	else:
		start()# start new game

# regular start
func start():
	$HeadHUD.show()
	# hearts
	hpshow=true
	# others
	$BoulderHUD.show()
	$BoulderCount.show()
	$LevelCount.show()
	$DeadText.hide()
	$EndButton.hide()
	# Tutorial
	$TutorialText.hide()
	$TutorialContinueButton.hide()

# tutorial start
func start_tutorial():
	$HeadHUD.hide()
	# hearts
	hpshow=false# put hearts but hide them
	# others
	$BoulderHUD.hide()
	$BoulderCount.hide()
	$LevelCount.hide()
	$DeadText.hide()
	$EndButton.hide()
	# Tutorial 
	$TutorialContinueButton.hide()
	$TutorialContinueTimer.start()
	$TutorialText.hide()
	$TutorialText.align=Label.ALIGN_FILL


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
	if hpshow == true: 
		for k in range(hpmax):
			if k<hp:
				setheart(k,1)#show
			else:
				setheart(k,0)#hide

# update boulder count display
func showscore(score):
	$BoulderCount.text=str(score)

func showdeadmessage(score):
	$DeadText.show()
	$DeadText.align=Label.ALIGN_CENTER
	$DeadText.text='You Died  \nScore: '+str(score)
	$EndButton.show()
	# hide the rest
	$BoulderCount.hide()
	$BoulderHUD.hide()
	$HeadHUD.hide()

################

# make one new boulder at given index (ib>=0)
func addheart(kb):
	var heart=HeartHUD.instance()
	add_child(heart)# add to scene
	hpd[str(kb)]=heart# add to instances dictionary

# (re)set boulder position and state (0-1 for hide,show)
func setheart(kb,sp):
	if str(kb) in hpd.keys():
		hpd[str(kb)].place( (kb-ihp0)*dxhp+xhp0,kb*dyhp+yhp0,sp)
			

# remove heart from scene (shouldnt be used, hide the heart instead)
func removeheart(kb):
	if hpd[str(kb)]:
		hpd[str(kb)].kill()# kill heart









