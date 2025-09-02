class_name DartingFish
extends Sprite2D

@export var max_response_time: float = 1.5
@export var min_response_time: float = 0.7

const sprite_direction := Vector2.LEFT

var data: FishData: set = _set_data
var rounds: int
var image: Texture2D

var pull_distance: int
var pull_direction: Vector2
var response_time: float
var status := "waiting"
var tween
var revealed := false

@onready var start_position: Vector2 = position
@onready var encyclopedia: Control = $"../../../TabContainer/Encyclopedia"

func _ready() -> void:
	data = encyclopedia.get_random_fish()

func _physics_process(_delta: float) -> void:
	if status == "waiting" and not (tween and tween.is_running):
		idle()
	elif status == "caught" and not revealed:
		reveal()


func _set_data(value) -> void:
	data = value
	image = data.image
	
	var size = data.size
	# Somehow the below equation evaluates to 0 if size 1
	if size > 1:
		scale.x *= float(size) / 2.5
		scale.y *= float(size) / 2.5
	pull_distance = size * 10
	
	rounds = data.difficulty
	response_time = max_response_time - (
			((max_response_time - min_response_time) / 4)
			* data.difficulty
	)


func idle() -> void:
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	var top := position.y
	var bottom := position.y + 10
	tween.tween_property(self, "position:y", top, 0.4)
	tween.tween_property(self, "position:y", bottom, 0.4)


func pull() -> void:
	status = "pulling"

	# randomly choose 1 of 8 directions to swim in, then rotate to
	# face that direction
	var pull_x := 0
	var pull_y := 0
	while pull_x == 0 and pull_y == 0: # can't choose (0, 0)
		pull_x = randi_range(-1, 1)
		pull_y = randi_range(-1, 1)
	pull_direction = Vector2(pull_x, pull_y) \
			.normalized() # make all vectors same length
	rotation = pull_direction.angle() - sprite_direction.angle()
	
	# swimming animation
	tween = create_tween().set_loops()
	var start := start_position
	var end := start + pull_direction * (pull_distance + 20)
	tween.tween_property(self, "position", end, 0.5)
	tween.tween_property(self, "position", start, 0.25)


## changes sprite texture to specific fish image
func reveal() -> void:
	revealed = true
	tween = create_tween().tween_property(self, "modulate:a", 0, 0.5)
	await(tween.finished)
	texture = image
	tween = create_tween().tween_property(self, "modulate:a", 1, 0.5)


## reset's fish's position and rotation back to starting values
func reset() -> void:
	position = start_position
	rotation = 0
