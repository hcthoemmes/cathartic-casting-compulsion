extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var animPlayer = $fighterhero_walk/AnimationPlayer
@onready var rod		= $fighterhero_walk/rig/Skeleton3D/Rod
signal usebutton()

# There's some stuff I added that could/should be handled in a singleton (fishing state, scene loading)
# I'll fix it later ÷P


func _ready() -> void:
	rod.hide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): velocity += get_gravity() * delta
	
	# If outside fishing minigame, get input
	if !GS.is_fishing:
		if GS.fishing_possible:
			if Input.is_action_just_pressed("use"):
				await GS.begin_fishing()
				# Lerp to some Fishin Point? Later feature
			
		var input_dir := Input.get_vector("west", "east", "north", "south")
		var direction := Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		)
		
		if input_dir:
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
	# For awaiting input to close the minigame. Also for the Big Pull mechanic
	if Input.is_action_just_pressed("use"):
		usebutton.emit()
		print("Emitting")

func _on_fishin_hole_body_entered(body: Node3D) -> void: 
	if body == self: GS.fishing_possible = true
func _on_fishin_hole_body_exited(body: Node3D) -> void: 
	if body == self: GS.fishing_possible = false
