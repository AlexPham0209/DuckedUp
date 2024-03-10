extends CharacterBody2D
class_name Bird

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var BOUNCE_STRENGTH = 1.0
@export var distance = 500
@export var flap_amount = 1

@onready var state_machine = $StateMachine
@onready var animation = $AnimationPlayer
@onready var sprite = $Duck

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var flaps = flap_amount
var can_flap = true
var is_gliding = false

	
func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right") # see Vector2D.get_axis() if you only need left/right
	if direction != 0:
		sprite.flip_h = direction < 0
	
	if not is_on_floor():
		velocity.y += gravity * delta	
	
	#Bounce off walls
	var temp = velocity
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null and not is_on_floor():
			velocity = temp.bounce(collision.get_normal()) * BOUNCE_STRENGTH


		
