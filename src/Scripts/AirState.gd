extends State
@onready var bird = $"../.."

func enter(param : Dictionary = {}):	
	bird.velocity.x = cos(param["angle"]) * param["magnitude"] * bird.JUMP_VELOCITY
	bird.velocity.y = sin(param["angle"]) * param["magnitude"] * bird.JUMP_VELOCITY
	
	bird.flaps += 1

func physics_update(delta):
	
	if bird.is_on_floor():
		if bird.velocity.x == 0:
			transition_to.emit("Idle", {})
		else:
			transition_to.emit("Run", {})
	

	
func move(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		bird.velocity.x = direction * bird.SPEED
	else:
		bird.velocity.x = move_toward(bird.velocity.x, 0, bird.SPEED)
