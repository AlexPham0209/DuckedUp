extends CharacterBody2D
class_name Bird

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var FLAP_VELOCITY = -600.0
@export var coyote_jump = 0.5
@export var jump_buffer = 0.5
@export var flap = 0.5
@export var flap_amount = 1

@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var jump_buffer_timer = $JumpBuffer
@onready var flap_timer = $FlapTimer
@onready var state_machine = $StateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var flaps = flap_amount
var can_flap = true
var is_gliding = false

#TODO: Refactor.  Possibly use a state machine/system if amount of possible states increases
func _ready():
	coyote_jump_timer.wait_time = coyote_jump
	jump_buffer_timer.wait_time = jump_buffer
	flap_timer.wait_time = flap
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta if !is_gliding and can_flap else gravity/8 * delta
	
	#Reset Coyote Jump Timer
	if is_on_floor():
		coyote_jump_timer.start()
		flaps = flap_amount
		
	#Reset Jump Buffer Timer
	if Input.is_action_just_pressed("Jump"):
		jump_buffer_timer.start()
	
	
	move_and_slide()


#End of flap
func _on_flap_timer_timeout():
	can_flap = true
	velocity.y = move_toward(velocity.y, 0, -JUMP_VELOCITY * 1.5)

