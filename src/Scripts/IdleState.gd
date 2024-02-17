extends State

@onready var bird : Bird = $"../.."

func enter():
	bird.velocity.x = 0
	
	
func physics_update(deltas):
	var direction = Input.get_axis("Left", "Right")
	if direction:
		transition_to.emit("Run")
		
	if !bird.jump_buffer_timer.is_stopped() and !bird.coyote_jump_timer.is_stopped():
		transition_to.emit("Run")
