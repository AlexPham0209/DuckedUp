extends State

@onready var bird : Bird = $"../.."

func enter(param : Dictionary = {}):
	bird.velocity.x = 0
	
	
func physics_update(deltas):
	bird.animation.play("Idle")
	var direction = Input.get_axis("Left", "Right")
	if direction:
		transition_to.emit("Run", {})
	
	if not bird.is_on_floor():
		transition_to.emit("Air", {})	

func _on_mouse_collision_input_event(viewport, event, shape_idx):
	if state_machine.state != self:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		transition_to.emit("Launch", {})
