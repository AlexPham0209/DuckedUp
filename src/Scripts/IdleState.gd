extends State

@onready var bird : Bird = $"../.."

func enter(param : Dictionary = {}):
	bird.velocity.x = 0
	
	
func physics_update(deltas):
	bird.animation.play("Idle")
	var direction = Input.get_axis("Left", "Right")
	if direction:
		transition_to.emit("Run", {})
		

func _on_mouse_collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and state_machine.state_name == "Idle":
		transition_to.emit("Launch", {})
