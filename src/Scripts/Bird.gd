extends CharacterBody2D

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
	
	glide()
	move(delta)
	jump(delta)
	move_and_slide()

func move(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#If currently in flap, then reduce the velocity of horizontal movement so that there is only a little movement
	if not can_flap:
		velocity.x /= 3
	
func jump(delta):
	#If pressed jump in the air and flaps is above 0, then flap/double jump.
	if Input.is_action_just_pressed("Jump") and coyote_jump_timer.is_stopped() and flaps > 0:
		flap_timer.start()
		can_flap = false
		flaps -= 1
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = FLAP_VELOCITY
	
	# Handle Jump.
	if !jump_buffer_timer.is_stopped() and !coyote_jump_timer.is_stopped() and can_flap:
		jump_buffer_timer.stop()
		coyote_jump_timer.stop()
		velocity.y = JUMP_VELOCITY
	
	#If Jump Button is released, decrease velocity and weaken jump
	if Input.is_action_just_released("Jump") and can_flap and velocity.y < 0:
		velocity.y /= 2


func glide():
	if Input.is_action_just_pressed("Glide") and not is_on_floor():
		velocity.y /= 2
		is_gliding = true
	
	if Input.is_action_just_released("Glide") and is_gliding:
		is_gliding = false

#End of flap
func _on_flap_timer_timeout():
	can_flap = true
	velocity.y = move_toward(velocity.y, 0, -JUMP_VELOCITY * 1.5)

