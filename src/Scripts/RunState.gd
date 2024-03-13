extends State

@onready var bird : Bird = $"../.."

func physics_update(delta):
	bird.velocity.y += bird.gravity * delta
	bird.move(delta, bird.SPEED)
	bird.animation.play("Run")
		
	if bird.velocity.x == 0 and bird.is_on_floor():
		transition_to.emit("Idle", {})
		
	

	
