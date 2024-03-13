extends State
@onready var bird = $"../.."
var slide = 10
@onready var timer = $"../../GlideTimer"

func enter(param : Dictionary = {}):	
	timer.start()
	bird.velocity.y = 0
	bird.flaps += 1

func physics_update(delta):
	bird.move(delta, bird.GLIDE_SPEED)
	bird.velocity.y += bird.gravity * 0.1 * delta
	
func _on_glide_timer_timeout():
	if state_machine.state != self:
		return
	transition_to.emit("Air", {})
	

func _on_mouse_collision_input_event(viewport, event, shape_idx):
	if state_machine.state != self:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		transition_to.emit("Launch", {"float" : true})

	
