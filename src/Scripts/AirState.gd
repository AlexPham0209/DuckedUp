extends State
@onready var bird = $"../.."

func enter():
	bird.velocity.y = bird.JUMP_VELOCITY
	
	if Input.is_action_just_released("Jump") and bird.velocity.y < 0:
		bird.velocity.y /= 2;
		
	bird.flaps += 1

func physics_update(delta):
	move(delta)
	handle_jump(delta)
	
func handle_jump(delta):
	var can_flap = Input.is_action_just_pressed("Jump") \
		and bird.flaps < bird.flap_amount
		
	if Input.is_action_just_released("Jump") and bird.velocity.y < 0:
		bird.velocity.y /= 2;
		
	if bird.is_on_floor():
		if bird.velocity.x == 0:
			transition_to.emit("Idle")
		else:
			transition_to.emit("Run")
	
	

func move(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		bird.velocity.x = direction * bird.SPEED
	else:
		bird.velocity.x = move_toward(bird.velocity.x, 0, bird.SPEED)
