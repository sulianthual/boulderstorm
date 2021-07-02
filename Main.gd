extends Node

################

var domusic= true # do audio

var dotutorial=false# play tutorial
var tutorialpart=0# part of tutorial played (starts at 0)
var tutorialdone=false# ended tutorial
################
# Main script (entry point for code)
# -entry point for code
# -holds global variables (from Project Settings/Autoload, added Main.gd)
# -return here to switch between scenes

# Start of Code
func _ready():
	# to scene Start (titlescreen)
	get_tree().change_scene("res://Start.tscn")

func to_start():
	dotutorial=false# global
	tutorialpart= 0# reset tutorial part	
	get_tree().change_scene("res://Start.tscn")


func to_play():
	dotutorial=false# global
	get_tree().change_scene("res://Play.tscn")

func to_tutorial():
	dotutorial=true# global
	tutorialpart += 1# update tutorial part
	get_tree().change_scene("res://Play.tscn")

func to_quit():
	get_tree().quit()
	
# update
#func _process(delta):
#	pass

