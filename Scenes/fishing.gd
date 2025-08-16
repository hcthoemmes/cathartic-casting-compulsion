extends Node2D

@onready var fish = $DartingFish
var current_round = 1
var results = []
var failures = 0
var reel_direction: Vector2

func _physics_process(delta: float) -> void:
	# if fish is pulling, player can attempt to reel it in
	if fish.status == "pulling":
		# Snap to nearest unit vector for controller input 
		reel_direction = Input.get_vector("west", "east", "north", "south").snapped(Vector2(1,1)).normalized()
	elif fish.status == "waiting":
		start_round()

func reel_success() -> bool:
	return reel_direction == -fish.pull_direction if reel_direction else false

func start_round() -> void:
	fish.status = "pulling"
	fish.pull_direction = Vector2(0, 0)
	# if not successfully reeled by end of response time, fail round
	await get_tree().create_timer(fish.response_time).timeout
	fish.animation.kill()
	if reel_success():
		round_won()
	else:
		round_lost()
	if fish.status != "caught" and fish.status != "escaped":
		fish.status = "waiting"
	
func round_won():
	# TO-DO: show check mark
	print("round won")
	# fish is caught if you make it through all the rounds
	if current_round == fish.rounds:
		fish_caught()
	else:
		current_round += 1

func round_lost():
	# TO-DO: show X
	print("round lost")
	failures += 1
	# fish escapes if this is your third failure
	if failures == 3: 
		fish_escaped()

func fish_caught() -> void:
	print("FISH CAUGHT!")
	fish.status = "caught"
	# TO-DO: replace silhouette with actual fish image

func fish_escaped() -> void:
	print("FISH ESCAPED!")
	fish.status = "escaped"
