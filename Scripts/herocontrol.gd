extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var animPlayer = $fighterhero_walk/AnimationPlayer

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
				await begin_fishing()
				# Lerp to some Fishin Point? Later feature
			
		var input_dir := Input.get_vector("west", "east", "north", "south")
		var direction := (transform.basis * \
			Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			# Little hack, not actually what we wanna do cause it won't work for interaction and stuff but fine for a test :]
			$fighterhero_walk.rotation.y = atan2(velocity.x,velocity.z) # - deg_to_rad(45)
			animPlayer.play("WalkAction")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			animPlayer.play("IdleStand")

	move_and_slide()

func begin_fishing() -> void:
	# 5 and 20 as a guess.
	var waitTime = randi_range(5, 20)
	
	set_velocity(Vector3.ZERO)
	move_and_slide()
	
	is_fishing = true
	animPlayer.play("CastRod")
	await animPlayer.animation_finished
	# We want them to hold their pose, but for now it's fine
	
	await get_tree().create_timer(waitTime).timeout
	var f = load("res://Scenes/fishing.tscn").instantiate()
	get_node("../CanvasLayer").add_child(f)

func _on_fishin_hole_body_entered(body: Node3D) -> void: 
	if body == self: fishing_possible = true
func _on_fishin_hole_body_exited(body: Node3D) -> void: 
	if body == self: fishing_possible = false
