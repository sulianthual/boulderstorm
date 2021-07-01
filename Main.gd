extends Node

################

var dotutorial=false# play tutorial
var tutorialpart=4# part of tutorial played
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

