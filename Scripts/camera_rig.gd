extends Node3D
# With thanks to u/MirusCast for the concept!
@onready var cam = $Camera3D

func _ready() -> void:
	cam.look_at_from_position((Vector3.UP + Vector3.BACK + Vector3.LEFT) * cam.size, global_position, Vector3.UP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
