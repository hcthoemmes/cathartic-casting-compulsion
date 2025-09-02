extends Node2D

const MAX_Y := 220.0
const PROGRESS_MIN := -2.0

var start_y
var step


@onready var progress_fish: Sprite2D = $ProgressFish
@onready var fish: DartingFish = $"../HookBox/DartingFish"
@onready var fishing: Control = $".."
@onready var min_y := progress_fish.position.y


func _ready() -> void:
	start_y = calc_start_position(fish)
	progress_fish.position.y = start_y
	

## calculates and returns the y-value ProgressFish should start at
## (two failures away from clipping off the bar)
func calc_start_position(fish: DartingFish) -> float:
	var distance := MAX_Y - min_y
	step = distance / (fish.rounds - PROGRESS_MIN)
	return min_y + (step * 2)


## updates ProgressFish's position to show current progress
func update(progress) -> void:
	var new_y = start_y + (progress * step) 
	var tween = create_tween().tween_property(
			progress_fish, "position:y", new_y, 1.5
	)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
