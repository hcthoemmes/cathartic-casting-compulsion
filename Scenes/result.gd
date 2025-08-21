extends Sprite2D

func _ready() -> void:
	visible = false

func show_symbol(result) -> void:
	texture = load("res://box%s.png" % result)
	show()
	scale = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.1)
	await get_tree().create_timer(0.5).timeout
	hide()
