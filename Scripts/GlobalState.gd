# controls state, scene loading/unloading.
extends Node

var fishing_possible := false
var is_fishing	 	 := false
@onready var h = $/root/WorldRoot/AnimatedHero

func begin_fishing() -> void:
	var waitTime = randi_range(5, 20) # 5 and 20 as a guess.
	var f = load("res://Scenes/fishing.tscn").instantiate()
	
	h.set_velocity(Vector3.ZERO)
	
	is_fishing = true
	h.rod.show()
	h.animPlayer.play("CastRod")
	await h.animPlayer.animation_finished
	# We want them to hold their pose, but for now it's fine
	
	await get_tree().create_timer(waitTime).timeout
	$/root/WorldRoot/CanvasLayer.add_child(f)

func end_fishing() -> void:
	# Add obtained fish
	is_fishing = false
	h.rod.hide()
