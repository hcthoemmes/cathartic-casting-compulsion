extends Node2D

var start_position: Vector2
var pull_direction: Vector2
var max_response_time: float = 1.8
var min_response_time: float = 0.7

var pull_strength := 50
#var rounds := 1

# resource vars
var size: int
var difficulty: int = 2 # between 0 and 4
@export var image: Texture2D
#@export var image: Texture2D

var max_difficulty: int = 4 
var response_time: float
var sprite_direction := Vector2.LEFT
var status = "waiting"

var tween 
var revealed = false

func _ready() -> void:
	start_position = position
	response_time = max_response_time - (
		((max_response_time - min_response_time) / max_difficulty) \
		* difficulty
	)
	# TO-DO: scale sprite based on size

func _physics_process(_delta: float) -> void:
	if status == "waiting" and not (tween and tween.is_running):
		idle()
	elif status == "caught" and not revealed:
		reveal()
		
func idle() -> void:
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	var top = position.y
	var bottom = position.y + 10
	tween.tween_property(self, "position:y", top, 0.4)
	tween.tween_property(self, "position:y", bottom, 0.4)

func pull() -> void:
	status = "pulling"
	# randomly choose 1 of 8 directions to swim in
	var pull_x = 0
	var pull_y = 0
	while pull_x == 0 and pull_y == 0: # can't choose (0, 0)
		pull_x = randi_range(-1, 1)
		pull_y = randi_range(-1, 1)
	pull_direction = Vector2(pull_x, pull_y) \
		.normalized() # make all vectors same length
	rotation = pull_direction.angle() - sprite_direction.angle()
	tween = create_tween().set_loops()
	var start = start_position
	var end = start + pull_direction * pull_strength
	tween.tween_property(self, "position", end, 0.5)
	tween.tween_property(self, "position", start, 0.25)
	
func reveal() -> void:
	revealed = true
	tween = create_tween().tween_property(self, "modulate:a", 0, 0.5)
	await(tween.finished)
	self.texture = image
	tween = create_tween().tween_property(self, "modulate:a", 1, 0.5)
	
func reset() -> void:
	position = start_position
	rotation = 0
