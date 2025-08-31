# controls state, scene loading/unloading.
extends Node

enum PLAYER_STATE { WALKING, FISHING, IN_TEXT, IN_UI }

var timesFished := 0
# If we can implement a text box, I want to utilize this
# if player attempts to exit screen, the text changes depending on how much they've fished
# You consider going to town, → [but you think there's more here] → [but you want to fish some more] → [but the river calls to you]
@export var state = PLAYER_STATE.WALKING
var fishing_possible := false
var is_fishing	 	 := false
var is_in_text		 := false
@onready var h = $/root/WorldRoot/AnimatedHero
@onready var t = $/root/WorldRoot/CanvasLayer/TextBox

# Pass in data, index of replacement text in mut_contents if required
func show_text(textdata: TextBoxData, changeto = null) -> void:
	#@export var s
	var name = t.get_node("Name")
	var content = t.get_node("Contents")
	state = PLAYER_STATE.IN_TEXT
	
	name.text = textdata.name
	content.text = textdata.contents[0]
	t.show()
	for i in textdata.contents.size():
		if textdata.mutable and i == textdata.mut_index:
			textdata.contents[i] = textdata.mut_contents[changeto]
		content = textdata.contents
		print(textdata.contents[i])
		await h.usebutton

		
	print("We outie")
	# Show text box item
	# Change name and internal text
	pass

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
	timesFished += 1
	state = PLAYER_STATE.WALKING
	h.rod.hide()
