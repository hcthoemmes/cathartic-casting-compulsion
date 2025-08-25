extends Control

@onready var fish = $HookBox/DartingFish
@onready var result: Sprite2D = $HookBox/Result
@onready var progress_bar: Sprite2D = $ProgressBar

var results = []
var failures = 0
var reel_direction: Vector2
var progress := 0.0
var progress_min = -2
var failure_step := 1.0
var success_step := 0.5


func _ready() -> void:
	next_round()

func _physics_process(_delta: float) -> void:
	# if fish is pulling, player can attempt to reel it in
	if fish.status == "pulling":
		# Snap to nearest unit vector for controller input 
		reel_direction = Input.get_vector("west", "east", "north", "south")\
			.snapped(Vector2(1, 1)).normalized()

func next_round() -> void:
	fish.status = "waiting"
	await get_tree().create_timer(1.5).timeout
	fish.pull()
	# if not successfully reeled by end of response time, fail round
	await get_tree().create_timer(fish.response_time).timeout
	fish.tween.kill()
	if reel_success():
		round_won()
	else:
		round_lost()
	if fish.status != "caught" and fish.status != "escaped":
		fish.reset()
		next_round()

func reel_success() -> bool:
	return reel_direction == -fish.pull_direction if reel_direction else false
	
func round_won():
	result.show_symbol("check")
	progress += success_step
	progress_bar.update(progress)
	if progress >= fish.difficulty:
		fish_caught()

func round_lost():
	result.show_symbol("cross")
	progress -= failure_step
	progress_bar.update(progress)
	if progress <= progress_min:
		fish_escaped()

func fish_caught() -> void:
	fish.status = "caught"
	fish.reset()

func fish_escaped() -> void:
	fish.status = "escaped"
	fish.reset()
	create_tween().tween_property(fish, "modulate:a", 0, 1)
