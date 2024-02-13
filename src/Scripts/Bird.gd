extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var coyote_jump = 0.5
@export var jump_buffer = 0.5
@export var flap = 0.5
@export var flap_amount = 1

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var coyote_jump_timer = 0
var jump_buffer_timer = 0
var flap_timer = 0
var flaps = flap_amount
var can_flap = true
var is_gliding = false

#TODO: Refactor.  Possibly use a state machine/system if amount of possible states increases

func _physics_process(delta):
	coyote_jump_timer -= delta
	jump_buffer_timer -= delta
	flap_timer -= delta
	
	if not is_on_floor():
		velocity.y += gravity * delta if !is_gliding and can_flap else gravity/8 * delta
	
	#Reset Coyote Jump Timer
	if is_on_floor():
		coyote_jump_timer = coyote_jump
		flaps = flap_amount
		
	#Reset Jump Buffer Timer
	if Input.is_action_just_pressed("Jump"):
		jump_buffer_timer = jump_buffer
	
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
	if Input.is_action_just_pressed("Jump") and coyote_jump_timer < 0 and flaps > 0:
		can_flap = false
		flaps -= 1
		flap_timer = flap
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = JUMP_VELOCITY * 2.0
	
	#End dash after certain amount of time
	if flap_timer < 0 and not can_flap:
		can_flap = true
		velocity.y = move_toward(velocity.y, 0, -JUMP_VELOCITY * 1.5)

	# Handle Jump.
	if jump_buffer_timer > 0 and coyote_jump_timer > 0 and can_flap:
		jump_buffer_timer = 0
		velocity.y = JUMP_VELOCITY
	
	#If Jump Button is released, decrease velocity and weaken jump
	if Input.is_action_just_released("Jump") and can_flap:
		velocity.y /= 2


func glide():
	if Input.is_action_just_pressed("Glide") and not is_on_floor():
		velocity.y /= 2
		is_gliding = true
	
	if Input.is_action_just_released("Glide") and is_gliding:
		is_gliding = false
