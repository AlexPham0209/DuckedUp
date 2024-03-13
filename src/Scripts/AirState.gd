extends State
@onready var bird = $"../.."

func enter(param : Dictionary = {}):	
	if param.has("angle") and param.has("magnitude"):
		bird.velocity.x = cos(param["angle"]) * param["magnitude"] * bird.JUMP_VELOCITY
		bird.velocity.y = sin(param["angle"]) * param["magnitude"] * bird.JUMP_VELOCITY
	
func physics_update(delta):
	bird.velocity.y += bird.gravity * delta	
	
#	if Input.is_action_just_pressed("Glide") and bird.flaps < bird.flap_amount:
#		transition_to.emit("Float", {})
	
	if bird.is_on_floor():
		if bird.velocity.x == 0:
			transition_to.emit("Idle", {})
		else:
			transition_to.emit("Run", {})
	

func _on_mouse_collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and  bird.flaps < bird.flap_amount:
		transition_to.emit("Launch", {"float" : true})
