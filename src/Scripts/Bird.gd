extends CharacterBody2D
class_name Bird

@export var SPEED = 300.0
@export var GLIDE_SPEED = 10.0
@export var JUMP_VELOCITY = -400.0
@export var BOUNCE_STRENGTH = 1.0
@export var distance = 500
@export var flap_amount = 1
@export var flap_time = 1.0
@export var amplitude = 10
@export var frequency = 10
@export var range : Vector2


@onready var state_machine = $StateMachine
@onready var animation = $AnimationPlayer
@onready var sprite = $Duck
@onready var glide_timer = $GlideTimer

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var flaps = 0
var current_region

func _ready():
	Global.bird = self
	glide_timer.wait_time = flap_time
	Signals.hit.connect(on_hit)

	
func _physics_process(delta):
	if is_on_floor():
		flaps = 0
	
	var direction = Input.get_axis("Left", "Right") # see Vector2D.get_axis() if you only need left/right
	if direction != 0:
		sprite.flip_h = direction < 0
	
	#Bounce off walls
	var temp = velocity
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null and not is_on_floor():
			velocity = temp.bounce(collision.get_normal()) * BOUNCE_STRENGTH

func move(delta, speed):
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func on_hit():
	state_machine.transition_to("Air", {"angle" : randf_range(range.x, range.y), "magnitude" : 200})
		
		
func _on_region_collision_area_entered(area):
	print("new region")
	current_region = area.get_parent()
