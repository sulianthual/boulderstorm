extends Node
export (PackedScene) var Boulder
export (PackedScene) var Smoke
export (PackedScene) var Fall
export (PackedScene) var Arrow

################################################################################################################
################################################################################################################
# Variables Initialization
# *VAR

# Main Game Parameters (may edit here)
var hpref: int=7 # starting health for player, and maximum (must be <=7)
#var levelscores=[2, 4, 8, 14, 22, 32, 44, 58, 74]# scores needed to increases each level (+2 each level)
#var levelscores=[3, 6, 12, 21, 33, 48, 66, 87, 111]# (+3 each level)
#var levelscores=[4, 8, 16, 28, 44, 64, 88, 116, 148]#(+4 each level)
var levelscores=[5, 10, 20, 35, 55, 80, 110, 145, 185]# (+5 each level, best one)
#var levelscores=[1,2,3,4,5,6,7,8,9]# (for dev tests, quickest level upgrade)
# jump and beat
var jptimelvlmin: float=0.1# test start at max#0.25#  time between player jumps (at min level)
var jptimelvlmax: float=0.1#0.3*0.6  time between player jumps (at max level) (should follow btlvlmax)
var btlvlmin: float = 1# max beat time in seconds (at min level)
var btlvlmax: float = 0.6# min beat time in seconds (at max level)
var playersafejump= false # player wont jump on a warning spot (but can still receive a boulder on head) (avoid, better to increase dash speed)
# boulder rng
var bminlvlmin: int =1 # min boulder number that can randomly fall each beat (at min level)
var bmaxlvlmin: int =3 # max boulder number that can randomly fall each beat (at max level)
var bminlvlmax: int =1 # min boulder (at max level)
var bmaxlvlmax: int =7 # max boulder (at max level)
var bnonelvlmin: float=0.3# small chance of no new boulder at all during one round (at min level)
var bnonelvlmax: float=0.1# small chance of no new boulder at all during one round (at max level)
var bheartchancelvlmin: float=0.25# change that a boulder turns into a heart (min level)
var bheartchancelvlmax: float=0.1# change that a boulder turns into a heart (max level)


################
# utils
var rng=RandomNumberGenerator.new()
var i: int
var j: int
var k: int

# grid
var xglist=[80,240,400]# x-positions on grid
var yglist=[80,240,400]# y-positions on grid

# beat
var btref: float=1# reference beat time (1 second) at which animations were recorded
var btnow: float =btlvlmin# current beat time in seconds

# score and level
var level: int =1# level index (starts at 1)
var levelmax: int =len(levelscores)+1# max level (game parameters constant after it)
var score: int# player score (>=0), defined at game start
var canchangelevel=true# can change level

# player
var jptime: float=jptimelvlmin# time between player jumps (very important)
var ip: int = 1# player x-position index (0-2)
var jp: int = 1# player y-position index (0-2)
var ipn: int = 1# where player wants to be next turn
var jpn: int = 1# where player wants to be next turn
var sp: int = 0 # player state (0-4 for stand, aiming, hit, hitaiming, dead)
var op: int = 0 # player orientation (0-3 for r,u,l,d)
var hp: int # player health (>=0 and <=hpmax in HUD), defined at start game
var playercanmove=true # player can move or not
var playerhpregen=false# player regens +1hp per turn (for tutorial or dev)
var playercanjump=true# player has reloaded and can jump (on timer)


# boulders parameters
var bnone: float=bnonelvlmin# small chance of no new boulder at all during one round
var bmin: int=bminlvlmin# current min boulder number that can randomly fall each beat 
var bmax: int=bmaxlvlmin# current max boulder number that can randomly fall each beat
var bheartchance: float=bheartchancelvlmin# change that a boulder turns into a heart
var sgbnewcyclep# period for cyclic boulders (=0 no boulder, >0 for period)
var sgbnewcyclet# time increment for cyclic boulders
# boulder dictionaries
var sgb# grid boulder state as vector (0-3 for empty, warn, stand, decay), matrix made during init
var sgbnew# grid for new boulders (0-1), make during init
var sgbd={}# dictionary of boulder instances (labelled as "ij")
var sgs# grid smoke state when a boulder has been cracked (0-1)
var sgsd={}# dictionary of smoke instances (labelled as "ij")
var sgf# grid fall state when a boulder has fallen (0-1)
var sgfd={}# dictionary of fall instances (labelled as "ij")
# boulder booleans
var boulderscandecay=true# boulders can decay or not
var dorandomboulders=true# each turn do random boulders (default)
var docyclicboulders=false# each turn do cyclic boulders (not default)
var aboulderisfalling=false# is at least one boulder falling
var aboulderhasdecayed=false
var aboulderisincoming=false

################################################################################################################
################################################################################################################
# Game initialization/ End
# *INIT 

# init function
# Called when the node enters the scene tree for the first time. (like __init__)
func _ready():
	# utils
	rng.randomize()# ensures new executions generate different randoms
	sgb = matrix3x3()# boulders
	sgbnew=matrix3x3()# new boulders
	sgbnewcyclep=matrix3x3()# new boulders (cycle period)
	sgbnewcyclet=matrix3x3()# new boulders (cycle time)
	sgs= matrix3x3()# smoke
	sgf= matrix3x3()# fall
	#
	# game preparation
	if Main.dotutorial:
		start_tutorial()# start new game
	else:
		start()# start new game
			

# start a new game
func start():
	# reset player
	ip=1#rng.randi_range(0,2)
	jp=1#rng.randi_range(0,2)
	ipn=ip
	jpn=jp
	sp=0
	op=0
	$Player.place(ip,jp,sp,op)
	$Player.setspeedscale(btref/btnow)
	# player jump
	$PlayerJumpTimer.wait_time=jptime
	# player hp
	hp=hpref
	$HUD.showhealth(hp)
	# player score
	score=0
	$HUD.showscore(score)
	# start the beat
	$BeatTimer.wait_time=btnow
	$BeatTimer.start()
	# Next level
	$NextLevelText.show()
	# music
	$PlayMusic.play()
	#exit
	$ExitButton.show()

# start a tutorial
func start_tutorial():
	# Select Sound
	$SelectSound.play()
	# reset player
	ip=1#rng.randi_range(0,2)
	jp=1#rng.randi_range(0,2)
	ipn=ip
	jpn=jp
	sp=0
	op=0
	$Player.place(ip,jp,sp,op)
	# player jump
	$PlayerJumpTimer.wait_time=jptime
	# player hp
	hp=hpref
	$HUD.showhealth(hp)
	# player score
	score=0
	canchangelevel=false
	$NextLevelText.hide()
	$HUD.showscore(score)
	# start the beat
	$BeatTimer.wait_time=btnow
	$BeatTimer.start()
	# music
	$PlayMusic.stop()
	# exit
	$ExitButton.hide()
	# messages
	$HUD/HeadHUD.hide()
	$HUD/DeadText.hide()
	$HUD/TutorialText.show()
	# heart chance
	bheartchance=0
	if Main.tutorialpart == 1: 
		Main.tutorialdone=false
		$HUD/TutorialText.text="Welcome to Boulder Storm! Music from PlayonLoop.com (CC-BY 4), all sounds CC-0..."
		dorandomboulders=false
	elif Main.tutorialpart == 2: 
		Main.tutorialdone=false
		$HUD/TutorialText.text="... a game by Sulian Thual (2021). Move around with the arrows or by swiping. "
		dorandomboulders=false
	elif Main.tutorialpart == 3:
		$HUD/TutorialText.text="Smash boulders to earn points and pass levels."
		canchangelevel=true
		$NextLevelText.show()
		$HUD/LevelCount.show()
		$HUD/TutorialText.rect_position.y -= 15
		playercanmove=true
		ip=0
		jp=1
		$Player.place(ip,jp,sp,op)
		dorandomboulders=false
		boulderscandecay=false
		addboulder(1,1)
		setboulder(1,1,2)
		addboulder(0,0)
		setboulder(0,0,2)
		addboulder(2,0)
		setboulder(2,0,2)
		addboulder(0,2)
		setboulder(0,2,2)
		addboulder(2,2)
		setboulder(2,2,2)
		$HUD/BoulderHUD.show()
		$HUD/BoulderCount.show()
	elif Main.tutorialpart == 4:
		bheartchance=1
		hp=2
		$HUD.hpshow=true
		$HUD.showhealth(hp)
		$HUD/HeadHUD.show()
		$HUD/TutorialText.text="Some boulders have hearts that regenerate health."
		$HUD/TutorialText.rect_position.y += 55
		playercanmove=true
		ip=0
		jp=1
		$Player.place(ip,jp,sp,op)
		dorandomboulders=false
		boulderscandecay=false
		addboulder(1,1)
		setboulder(1,1,2)
		
	elif Main.tutorialpart == 5:
		$HUD/TutorialText.text="Boulders fall, then stand and eventually decay and disappear."
		playercanmove=false
		ip=0
		jp=1
		$Player.place(ip,jp,sp,op)
		$Player.hide()
		dorandomboulders=false
		docyclicboulders=true
		sgbnewcyclep[1][1]=2
		sgbnewcyclet[1][1]=2
		addboulder(1,1)
	else:
		Main.tutorialdone=true# tutorial done
		$HUD/TutorialText.text="Falling boulders hurt the player. Decaying boulders can be stepped on. "
		playercanmove=true
		playerhpregen=true
		ip=1
		jp=1
		$Player.place(ip,jp,sp,op)
		$Player.show()
		dorandomboulders=false
		docyclicboulders=true
		sgbnewcyclep[1][1]=2
		sgbnewcyclep[0][0]=2
		sgbnewcyclep[0][2]=2
		sgbnewcyclep[2][0]=2
		sgbnewcyclep[2][2]=2
		sgbnewcyclet[1][1]=2
		sgbnewcyclet[0][0]=2
		sgbnewcyclet[0][2]=2
		sgbnewcyclet[2][0]=2
		sgbnewcyclet[2][2]=2
		addboulder(1,1)
		addboulder(0,0)
		addboulder(0,2)
		addboulder(2,0)
		addboulder(2,2)
		$HUD/TutorialContinueButton.text='Back'

###############
# Game finish
# *EXIT *FINISH *END 

# exit scene if dead + end button pressed 
func _on_HUD_custom_on_EndButton_pressed():
	if sp==4:# if is dead
		endgame()

# end of game (dead)
func endgame():
	Main.to_start()# to titlescreen

# Press exit button
func _on_ExitButton_pressed():
	Main.to_start()# to titlescreen

# next step of tutorial
func _on_HUD_custom_on_TutorialContinueButton_pressed():
	if Main.tutorialdone == true:
		Main.to_start()
	else:
		Main.to_tutorial()

################################################################################################################
################################################################################################################
# Main Game loop
#*LOOP	*MAIN

# update (every step)
func _process(delta):
	moveplayer() 
	getheart()
	checklevel()
	devcontrols()

# input detector
func _input(event):
	keyboardcontrols() 

# Game update when BeatTimer rings
# *BEAT
func beatrings():
	makenewboulders()# propose new boulders
	updateboulders()# update new/old boulders
	correctboulders()# correct boulders (preserve escape route)
	updatefalls()# update new/old falls
	hitplayer()# hit player if on boulder spot
	bouldersounds()# play boulder sounds


# developper controls
# *DEV
func devcontrols():
	pass
#	print(Main.doaudio)
	#
	#  test beat changes
#	var temp1=round(jptime*100)/100
#	var temp2=round(btnow*100)/100 
#	var temp3=round(jptime/btnow*100)/100
#	var temp0=str(level)
#	if level >= levelmax:
#		temp0='levelmax'
#	print('level=',temp0,', jump=',temp1,', beat=',temp2,', ratio=',temp3)



	
	
	
	
	
################################################################################################################
################################################################################################################
# Player controls
#*PLAYER

# orient the player 
func keyboardcontrols():
	if Input.is_action_pressed("ui_right"):
		setmoveplayer("right")
	elif Input.is_action_pressed("ui_up"):
		setmoveplayer("up")
	elif Input.is_action_pressed("ui_left"):
		setmoveplayer("left")
	elif Input.is_action_pressed("ui_down"):
		setmoveplayer("down")
#
# control player with swipes (on touchscreen)
func _on_SwipeDetector_swiped(direction):
	setmoveplayer(direction)

# set a player move
func setmoveplayer(direction):
	# if stand, aim, hit or hitaiming
	if sp in [0,1] and playercanmove and playercanjump:
		if direction=='right':
			if ip<2: 
				if sp == 0:# stand
					sp=1# to aim
				ipn=ip+1
				jpn=jp
			op=0
			$Player.place(ip,jp,sp,op)
		elif direction=='up':
			if jp>0: 
				if sp == 0:# stand
					sp=1# to aim
				ipn=ip
				jpn=jp-1
			op=1
			$Player.place(ip,jp,sp,op)
		elif direction=='left':
			if ip>0: 
				if sp == 0:# stand
					sp=1# to aim
				ipn=ip-1
				jpn=jp
			op=2
			$Player.place(ip,jp,sp,op)
		elif direction=='down':
			if jp<2: 
				if sp == 0:# stand
					sp=1# to aim
				ipn=ip
				jpn=jp+1
			op=3
			$Player.place(ip,jp,sp,op)


# move the player (reload afterward)
func moveplayer():
	# Player wants to move
	if sp ==1 and playercanjump:
		# boulder blocks the way (break it)
		if sgb[ipn][jpn] == 2:
			playerjumpreload()
			if sp == 1:
				sp=0
			$Player.place(ip,jp,sp,op)
			if rng.randf()<bheartchance:# small chance of creating heart
				setboulder(ipn,jpn,4)# to heart
			else:
				removeboulder(ipn,jpn)# remove boulder
				
			addsmoke(ipn,jpn)# add smoke
			addarrow(ip,jp,op)# add arrow
			$Player/CrackSound.play()
			$Player/CoinSound.play()
			# increase score
			score += 1
			$HUD.showscore(score)
		# otherwise move to spot
		else:
			# there is a warning boulder at spot (player will be hurt)
			if sgb[ipn][jpn] == 1 and playersafejump == true:# avoid jump with safe jump
				$Player.place(ip,jp,sp,op)
			else:
				playerjumpreload()
				ip=ipn
				jp=jpn
				sp=0
				$Player.place(ip,jp,sp,op)
				$Player/DashSound.play()
		# update for next step
		ipn=ip
		jpn=jp
		jpn=jp


# player starts reloading jump
func playerjumpreload():
	playercanjump=false
	$PlayerJumpTimer.start()
	 
func _on_PlayerJumpTimer_timeout():
	playercanjump=true
	$PlayerJumpTimer.stop()

# player gets heart if stepping on one
func getheart():
	if sgb[ip][jp] == 4:# if step on heart
		if hp<hpref:
			hp += 1
		else:
			score += 1
		$HUD.showhealth(hp)
		$Player/HealSound.play()
		removeboulder(ip,jp)# remove boulder

# hit player if is on falling boulder spot
func hitplayer():
	# if player on a boulder or decaying spot (has fallen on him)
	if sgb[ip][jp] in [2,3]:
		if playerhpregen == false:# player regenerates health (for tutorial)
			hp -= 1# player health
		$HUD.showhealth(hp)
		# player is hit
		if hp>0:
			$Blood.place(ip,jp,1)
			$PlayerHurtTimer.start()
			$Player.place(ip,jp,sp,op)
			$Player/HurtSound.play()
			$Player/HitSound.play()
			removeboulder(ip,jp)
			removefall(ip,jp)# to remove fall
			# cleanup the board
			removeallboulders()
			removeallfalls()
		# player dies
		else:
			die()	

# stop hurt animation
func _on_PlayerHurtTimer_timeout():
	$PlayerHurtTimer.stop()
	$Blood.place(ip,jp,0)

# die 
func die():
	# stop the beat
	$BeatTimer.stop()
	# player
	sp=4
	$Player.place(ip,jp,sp,op)
	# remove boulder/smoke/fall in place of player
	removeboulder(ip,jp)
	removefall(ip,jp)
	# remove all new boulders (that are warnings)
	for i in range(3):
		for j in range(3):
			if sgb[i][j] == 1:#
				removeboulder(i,j)
			elif sgb[i][j] == 3:#
				setboulder(i,j,2)
	removeallfalls()
	# Dead Message
	$HUD.showdeadmessage(score)
	$HUD/LevelCount.hide()
	# Stop Play Music
	$PlayMusic.stop()
	$Player/DeathSound.play()
	#exit
	$ExitButton.hide()

################################################################################################################
################################################################################################################
# Game level 
#*LEVEL

# check if new level
func checklevel():
	if canchangelevel and level<levelmax:
		if score>=levelscores[level-1]:
			changelevel()

# apply level changes
func changelevel():
	# increase level
	level += 1
	if level<levelmax:
		$HUD/LevelCount.text='Lvl '+str(level)
		$NextLevelText/NextLevelTextLabel.text='Level '+str(level)
		$NextLevelSound.play()
	else:
		$HUD/LevelCount.text='Lvl Max'
		$NextLevelText/NextLevelTextLabel.text='Level Max'
		if score<=levelscores[-1]:
			$NextLevelSound.play()
	$NextLevelText.show()
	$NextLevelTextTimer.start()# start timer to end next level text label display
	# cleanup the board
	removeallboulders()
	removeallfalls()
#	removeallsmokes()
	# change game parameters depending on settings
	if level<levelmax:
		# background color (linear)
		var tempo=float(level)/float(levelmax)
		$GridColor.color = Color(1, 1-tempo*0.9, 1-tempo*0.9, tempo*0.9) # to red
		# jump reload speed (power law)
		jptime = jptimelvlmin*pow(jptimelvlmax/jptimelvlmin,float(level-1)/float(levelmax-1))
		# beat speed (power law)
		btnow=btlvlmin*pow(btlvlmax/btlvlmin,float(level-1)/float(levelmax-1))
		$BeatTimer.wait_time= btnow
		# randomized boulders (linear)
		bnone=bnonelvlmin+float(level)/float(levelmax)*(bnonelvlmax-bnonelvlmin) 
		bmin = int(round( bminlvlmin+float(level)/float(levelmax)*(bminlvlmax-bminlvlmin) ))
		bmax = int(round( bmaxlvlmin+float(level)/float(levelmax)*(bmaxlvlmax-bmaxlvlmin) ))
		# heart drop chance
		bheartchance = bheartchancelvlmin+float(level)/float(levelmax)*(bheartchancelvlmax-bheartchancelvlmin) 
	else:
		# background color
		$GridColor.color = Color(1, 1-0.9, 1-0.9, 0.9) # almost red
		#jump reload speed
		jptime=jptimelvlmax
		# beat speed
		btnow=btlvlmax
		$BeatTimer.wait_time=btnow
		# randomized boulders
		bnone=bnonelvlmax
		bmin=bminlvlmax
		bmax=bmaxlvlmax
		# heart drop chance
		bheartchance=bheartchancelvlmax
	# Adjustments from new parameters
	$PlayerJumpTimer.wait_time=jptime
	$Player.setspeedscale(btref/btnow)

# next level message
func _on_NextLevelTextTimer_timeout():
	$NextLevelText.hide()
	$NextLevelTextTimer.stop()


################################################################################################################
################################################################################################################
# Boulders management
#*BOULDER
	
# make new round of boulders at beat ring
func makenewboulders():
	# empty sgbnew to zero
	sgbnew=matrix3x3fill(sgbnew,0)
	# method: random boulders each turn
	if dorandomboulders: 
		if rng.randf()>bnone:# small odds of no new boulders
			var newb=rng.randi_range(bmin,bmax)
			for n in range(newb):
				var newi=rng.randi_range(0,2)
				var newj=rng.randi_range(0,2)
				sgbnew[newi][newj]=1
	if docyclicboulders:
		for i in range(3):
			for j in range(3):
				if sgbnewcyclep[i][j]>0: 
					sgbnewcyclet[i][j] += 1
					if sgbnewcyclet[i][j]>sgbnewcyclep[i][j]:
						sgbnewcyclet[i][j]=0
						sgbnew[i][j]=1

# update boulders
# sgb: grid boulder state as vector (0-3 for empty, warn, stand, decay)
func updateboulders():
	for i in range(3):
		for j in range(3):
			# boulder empty (or heart)
			if sgb[i][j] in [0,4]:
				if sgbnew[i][j]==1:# new boulder
					if sgb[i][j]==0:
						addboulder(i,j)# add boulder
					setboulder(i,j,1)# to boulder warn
			# boulder warn
			elif sgb[i][j] == 1:
				if sgbnew[i][j]==1:# new boulder on top
					if boulderscandecay: 
						setboulder(i,j,3)# to boulder decay
					addfall(i,j)# add fall
				else:
					setboulder(i,j,2)# to boulder
					addfall(i,j)# add fall
			# boulder 
			elif sgb[i][j] == 2:
				if sgbnew[i][j]==1:# new boulder on top
					if boulderscandecay: 
						setboulder(i,j,3)# to boulder decay
				else:
					setboulder(i,j,2)# to boulder
			# boulder decays
			elif sgb[i][j] == 3:
				removeboulder(i,j)# to remove boulder

# correct boulders (ensure always an escape boulder for the player)
func correctboulders():
	if sgb[ip][jp] == 1:# if warning falling on player
		# determine if player can escape
		var canescape = false
		var neighbors=getneighbors(ijtok(ip,jp))
		# find at least one neighbor with escape possible
		for k in neighbors:
			var tempo=ktoij(k)
			i=tempo[0]
			j=tempo[1]
			if sgb[i][j] in [0,3]:# empty or decaying spot
				canescape=true
		# if cannot escape, open escape route
		if canescape == false:
			k=rng.randi_range(0,neighbors.size()-1)
			var tempo=ktoij(neighbors[k])
			i=tempo[0]
			j=tempo[1]
			# open escape route on desired neighbor
			if sgb[i][j] == 1:# is a warning spot
				removeboulder(i,j)# to boulder empty
			elif sgb[i][j] == 2:# is a boulder spot
				setboulder(i,j,3)# to boulder decay

# update falls
func updatefalls():
	for i in range(3):
		for j in range(3):
			# empty spot
			if sgf[i][j] == 0:
				pass
			# standing fall
			elif sgf[i][j] == 1:
				setfall(i,j,2)# to decaying fall
			# decaying fall
			elif sgf[i][j] == 2:
				removefall(i,j)# to remove fall

	
# play boulder sounds during one round
func bouldersounds():
	# environment sounds
	if aboulderisincoming==true:
		$WarnSound.play()
	if aboulderisfalling == true:
		$FallSound.play()
	if aboulderhasdecayed==true:
		$DecaySound.play()
	# reset triggers
	aboulderisfalling=false
	aboulderhasdecayed=false
	aboulderisincoming=false

################################################################################################################
################################################################################################################
# Game modules/elements

###############
# boulders functions
# *BOULDER

# make one new boulder at given location
func addboulder(ib,jb):
	var boulder=Boulder.instance()
	add_child(boulder)# add to scene
	boulder.setspeedscale(btref/btnow)
	sgbd[str(ib)+str(jb)]=boulder# add to boulder instances dictionary
	setboulder(ib,jb,0)# empty by default

	
# (re)set boulder position and state
func setboulder(ib,jb,sb):
	sgb[ib][jb]=sb
	sgbd[str(ib)+str(jb)].place(ib,jb,sb)
	if sb == 3:
		aboulderhasdecayed=true
	elif sb== 1:
		aboulderisincoming=true

# remove boulder from scene at given location
func removeboulder(ib,jb):
	sgb[ib][jb]=0
	if sgbd[str(ib)+str(jb)]:
		sgbd[str(ib)+str(jb)].kill()# kill

# remove all boulders
func removeallboulders():
	for i in range(3):
		for j in range(3):
			if sgb[i][j] in [1,2,3]:# exclude 0 and 4
				removeboulder(i,j)

###############
# arrow functions (punch glove from player)
# *ARROW

# make one new arrow at given location (with x,y)
# arrow disappears on its own on a timer
func addarrow(ib,jb,op):
	var arrow=Arrow.instance()
	add_child(arrow)# add to scene
	arrow.setspeedscale(btref/btnow)
	arrow.set_z_index(2)# put in front/ front
	arrow.place(ib,jb,op,1)

	
###############
# smoke functions (when a rock is destroyed)
#*SMOKE

# make one new smoke at given location
# smoke disappears on its own on a timer
func addsmoke(ib,jb):
	var smoke=Smoke.instance()
	add_child(smoke)# add to scene
	smoke.setspeedscale(btref/btnow)
	smoke.set_z_index(2)# put in front/ front
	sgsd[str(ib)+str(jb)]=smoke# add to smoke instances dictionary
	setsmoke(ib,jb,1)

# (re)set smoke position and state
func setsmoke(ib,jb,sb):
	sgs[ib][jb]=sb
	sgsd[str(ib)+str(jb)].place(ib,jb,sb)


###############
# fall functions (when a rock hits the floor)
#*FALL

# make one new fall at given location
func addfall(ib,jb):
	var fall=Fall.instance()
	add_child(fall)# add to scene
	fall.setspeedscale(btref/btnow)
	fall.set_z_index(1)# put in front
	sgfd[str(ib)+str(jb)]=fall# add to fall instances dictionary
	setfall(ib,jb,1)	
	aboulderisfalling=true
	
# (re)set fall position and state
func setfall(ib,jb,sb):
	sgf[ib][jb]=sb
	sgfd[str(ib)+str(jb)].place(ib,jb,sb)


# remove fall from scene at given location
func removefall(ib,jb):
	sgf[ib][jb]=0
	if sgfd[str(ib)+str(jb)]:
		sgfd[str(ib)+str(jb)].kill()# kill 

# remove all falls
func removeallfalls():
	for i in range(3):
		for j in range(3):
			if sgf[i][j]>0:
				removefall(i,j)
###############
# utilities
# *UTILS

# return list of neighbor spots for a given position (uses array instead of matrix)
func getneighbors(index):
	if index == 0: return [1,3] # top left
	if index == 1: return [0,2,4] # top
	if index == 2: return [1,5] # top right
	if index == 3: return [0,4,6] # middle left
	if index == 4: return [1,3,5,7] # middle
	if index == 5: return [2,4,8] # middle right
	if index == 6: return [3,7] # bottom left
	if index == 7: return [4,6,8]  # bottom
	if index == 8: return [5,7] # bottom right

# make matrix 3x3 filled with zeros (manually because type doesnt exist in godot)
func matrix3x3():
	var matrix=[]
	for i in range(3):
		matrix.append([])
		for j in range(3):
			matrix[i].append([])
	matrix=matrix3x3fill(matrix,0)
	return matrix

# fill matrix with uniform  value
func matrix3x3fill(matrix,value):
	for i in range(3):
		for j in range(3):
			matrix[i][j]=value
	return matrix

# Convert matrix 3x3 indices i,j (0-2,0-2) to array index k (0-8)
func ijtok(i,j):
	return i+j*3

# Convert back
func ktoij(k):
	return Vector2(k%3,int(k/3))
	
################################################################################################################
################################################################################################################

###############




















