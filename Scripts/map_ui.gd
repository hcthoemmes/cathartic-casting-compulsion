extends Control

@onready var startpos = $MapMarker.position
@onready var tween = get_tree().create_tween()

func _ready() -> void:
	tween.set_loops()
	tween.tween_property($MapMarker, 'position', $BouncePoint.position, 1)
	tween.tween_property($MapMarker, 'position', startpos, 1)
