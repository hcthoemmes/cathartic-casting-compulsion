extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var start_position = Vector2(576.0, 320.0)
var pull_direction: Vector2
var pull_strength := 50
var rounds := 5
var response_time = 1.5
var sprite_direction := Vector2.LEFT
var status = "waiting"
var current_round = 0
var animation

func _physics_process(delta: float) -> void:
	# for number of rounds:
	if status == "pulling" and not pull_direction:
		pull()

func pull():
	# randomly choose 1 of 8 directions to swim in
	pull_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	sprite.rotation = pull_direction.angle() - sprite_direction.angle()
	animation = create_tween().set_loops()
	var start = start_position
	var end = start + pull_direction * pull_strength
	animation.tween_property(sprite, "position", end, 0.5).from(start)
	animation.tween_property(sprite, "position", start, 0.25).from(end)
