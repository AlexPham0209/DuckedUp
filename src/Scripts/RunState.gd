extends State

@onready var bird : Bird = $"../.."

func physics_update(delta):
	move(delta)
	bird.animation.play("Run")
		
	if bird.velocity.x == 0 and bird.is_on_floor():
		transition_to.emit("Idle", {})
		
	if not bird.is_on_floor():
		transition_to.emit("Air", {})	
	
func move(delta):
	var direction = Input.get_axis("Left", "Right")
	if direction:
		bird.velocity.x = direction * bird.SPEED
	else:
		bird.velocity.x = move_toward(bird.velocity.x, 0, bird.SPEED)
	
