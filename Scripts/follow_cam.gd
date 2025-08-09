extends Camera3D

var camera_distance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	look_at_from_position((Vector3.UP + Vector3.BACK) * camera_distance,        
					   get_parent().translation, Vector3.UP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform.origin = $/root/WorldRoot/angelo.transform.origin
	pass
