extends Node2D
class_name StateMachine

# Called when the node enters the scene tree for the first time.
signal transition(state_name : String)

@onready var initial_state : String
var state : State

func _ready():
	for state in get_children().filter(func(state): return state is State):
		state.transition_to.connect(transition_to)
		state.state_machine = self
	self.state = get_node(initial_state)
	state.enter()

func _physics_process(delta):
	state.physic_update(delta)
	
func _process(delta):
	state.update(delta)
	
func _input(event):
	state.input(event)
	
func transition_to(state_name : String):
	if not has_node(state_name):
		return
		
	state.exit()
	state = get_node(state_name)
	state.enter()
