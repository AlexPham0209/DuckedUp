extends State

@onready var bird : Bird = $"../.."
@onready var timer = $"../../GlideTimer"
var arrow = preload("res://src/Scenes/Arrow.tscn")
var arrow_instance
var direction = Vector2()
var gravity = 0.0
var hover = false


func enter(param : Dictionary = {}):
	if param.has("float") and param["float"] == true:
		timer.start()
		
	bird.velocity = Vector2.ZERO
	gravity = bird.gravity * 0.1 if param.has("float") else bird.gravity 
	arrow_instance = arrow.instantiate()
	bird.add_child(arrow_instance)
	
func physics_update(delta):
	bird.velocity.y += gravity * delta
	direction = bird.global_position - get_global_mouse_position()
	bird.sprite.flip_h = direction.x < 0
		
	arrow_instance.rotation = direction.angle()
	arrow_instance.get_node("Icon").scale.x = min(direction.length(), bird.distance)/50
	
func _on_glide_timer_timeout():
	timer.stop()
	transition_to.emit("Air", {})

func input(event):
	if !(event is InputEventMouseButton):
		return
	
	if !event.pressed:
		transition_to.emit("Air", {"angle" : direction.angle(), "magnitude" : min(direction.length(), bird.distance)})

func exit():
	if arrow_instance:
		arrow_instance.queue_free()

