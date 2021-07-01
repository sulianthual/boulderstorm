extends TextureRect

var cr=1# color rgbt
var cg=1# color rgbt
var cb=1# color rgbt
var ct=1# color rgbt
var cfact=0.4# color change intensity (0-1)

################

# init
func _ready():
	applycolor()

################

# update
func _process(delta):
	changecolor()
	applycolor()

# change color based on BeatTimer
func changecolor():
	var bt=get_owner().get_node("BeatTimer").get_time_left()
	var btmax=get_owner().get_node("BeatTimer").get_wait_time()
	cr = bt/btmax*cfact +(1-cfact)
	cg = bt/btmax*cfact +(1-cfact)
#	cb = -bt/btmax*cfact +(1+cfact)

################

# Reset color
func resetcolor():
	cr=1
	cg=1
	cb=1
	ct=1
	applycolor()


# set color
func applycolor():
	modulate=Color(cr,cg,cb,ct)	
