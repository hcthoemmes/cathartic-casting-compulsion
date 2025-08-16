extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# There's some stuff I added that could/should be handled in a singleton (fishing state, scene loading)
# I'll fix it later ÷P
var fishing_possible := false
var is_fishing		 := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): velocity += get_gravity() * delta

	# If outside fishing minigame, get input
	if !is_fishing:

		if fishing_possible:
			if Input.is_action_just_pressed("use"):
				is_fishing = true
				var f = load("res://Scenes/fishing.tscn").instantiate()
				get_node("../CanvasLayer").add_child(f)
			
		var input_dir := Input.get_vector("west", "east", "north", "south")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# Little hack, not actually what we wanna do cause it won't work for interaction and stuff but fine for a test :]
			$joint0.rotation.y = atan2(velocity.x,velocity.z) + deg_to_rad(135)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_fishin_hole_body_entered(body: Node3D) -> void: fishing_possible = true
func _on_fishin_hole_body_exited(body: Node3D) -> void: fishing_possible = false
