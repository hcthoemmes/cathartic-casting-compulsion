extends Control

@onready var fish = $HookBox/DartingFish
@onready var result: Node2D = $HookBox/Result
@onready var progress_bar: Sprite2D = $ProgressBar
@onready var m : AudioStreamPlayer = get_node("../../MusicPlayer")

@export var fishing_log_data: FishingLogData

var results = []
var failures = 0
var reel_direction: Vector2
var progress := 0.0
var progress_min = -2
var failure_step := 1.0
var success_step := 0.5
var music_pause_point := 0.0


func _ready() -> void:
	# debugging purposes ------------------------------------------------------
	fishing_log_data.load_entries()
	var entries = fishing_log_data.entries
	for entry in entries:
		print(entry.name)
	# end debug ---------------------------------------------------------------
	
	music_pause_point = m.get_playback_position()
	m.set_stream(load("res://Sound/Just A Nibble [LOOPED].wav"))
	m.play()
	
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
	fish.data.caught += 1
	fish.reset()
	unload(true)

func fish_escaped() -> void:
	fish.status = "escaped"
	fish.reset()
	var tween = create_tween().tween_property(fish, "modulate:a", 0, 1)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	unload(false)

func unload(success: bool) -> void:
	m.set_stream(load("res://Sound/Hyperfishation.wav"))
	m.play(music_pause_point)
	if success:
		await $/root/WorldRoot/AnimatedHero.usebutton
	GS.end_fishing()
	queue_free()
