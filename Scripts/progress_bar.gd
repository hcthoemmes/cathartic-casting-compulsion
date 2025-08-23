extends Node2D

@onready var progress_fish: Sprite2D = $ProgressFish
@onready var fish: Sprite2D = $"../HookBox/Fish"
@onready var fishing: Node2D = $".."

var escape_y
var start_y
var end_y = 220
var distance
var step

func _ready() -> void:
	escape_y = progress_fish.position.y
	distance = end_y - escape_y
	
	step = distance / (fish.difficulty - fishing.progress_min)
	start_y = escape_y + (step * 2)
	progress_fish.position.y = start_y

func update(progress) -> void:
	var new_y = start_y + (progress * step) 
	create_tween().tween_property(
		progress_fish, "position:y", new_y, 1.5
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
