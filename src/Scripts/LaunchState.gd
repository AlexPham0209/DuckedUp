extends State

@onready var bird : Bird = $"../.."
var arrow = preload("res://src/Scenes/Arrow.tscn")
var arrow_instance
var direction = Vector2()
var glide = false

func enter(param : Dictionary = {}):
	if param.has("glide"):
		glide = true
		
	bird.velocity.x = 0
	arrow_instance = arrow.instantiate()
	bird.add_child(arrow_instance)
	
func physics_update(delta):
	bird.velocity.y += bird.gravity * delta if !glide else bird.gravity * 0.1 * delta
	direction = bird.global_position - get_global_mouse_position()
	bird.sprite.flip_h = direction.x < 0
		
	arrow_instance.rotation = direction.angle()
	arrow_instance.get_node("Icon").scale.x = min(direction.length(), bird.distance)/50
	
func _on_glide_timer_timeout():
	glide = false

func input(event):
	if !(event is InputEventMouseButton):
		return
	
	if !event.pressed:
		transition_to.emit("Air", {"angle" : direction.angle(), "magnitude" : min(direction.length(), bird.distance)})

func exit():
	if arrow_instance:
		arrow_instance.queue_free()

