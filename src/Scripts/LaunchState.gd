extends State

@onready var bird : Bird = $"../.."
var arrow = preload("res://src/Scenes/Arrow.tscn")
var arrow_instance
var magnitude
var angle
var glide = false

func enter(param : Dictionary = {}):
	if param.has("glide"):
		glide = true
		
	bird.velocity.x = 0
	arrow_instance = arrow.instantiate()
	bird.add_child(arrow_instance)
	
func physics_update(delta):
	bird.velocity.y += bird.gravity * delta if !glide else bird.gravity * 0.1 * delta
	var x = bird.global_position.x - get_global_mouse_position().x
	var y = bird.global_position.y - get_global_mouse_position().y
	
	if x != 0:
		bird.sprite.flip_h = x < 0
		
	magnitude = min(sqrt(pow(x, 2) + pow(y, 2)), bird.distance)
	angle = atan2(y, x)
	arrow_instance.rotation = angle
	arrow_instance.get_node("Icon").scale.x = magnitude/50
	
func _on_glide_timer_timeout():
	glide = false

func input(event):
	if !(event is InputEventMouseButton):
		return
	
	if !event.pressed:
		transition_to.emit("Air", {"angle" : angle, "magnitude" : magnitude})

func exit():
	if arrow_instance:
		arrow_instance.queue_free()

