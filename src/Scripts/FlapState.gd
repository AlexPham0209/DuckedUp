extends State
@onready var flap_timer : Timer = $"../../FlapTimer"
@onready var bird : Bird = $"../.." 


func enter(param : Dictionary = {}):
	flap_timer.start()
	bird.can_flap = false
	bird.flaps -= 1
	bird.velocity.x = 0
	bird.velocity.y = bird.FLAP_VELOCITY

func physics_update(delta):
	move(delta)
	
func move(delta):
	var direction = Input.get_axis("Left", "Right")
	if direction:
		bird.velocity.x = direction * bird.SPEED/3
	else:
		bird.velocity.x = move_toward(bird.velocity.x, 0, bird.SPEED)

func _on_flap_timer_timeout():
	bird.velocity.y = 0
	bird.can_flap = true
	transition_to.emit("Run", {})
