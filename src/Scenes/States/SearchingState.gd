extends State

@onready var crosshair = $"../.."
var time = 0
var pivot = 0
var top = 0
var bottom = 0
var direction = 1
var current_region 

enum Action {
	START, 
	MOVING,
	PATROL
}

var action : Action = Action.START

func enter(param : Dictionary = {}):
	time = 0

func physics_update(delta):
	if Global.bird.current_region != self.current_region:
		move(delta)
	else:
		patrol(delta)
	
	
func move(delta):
	time += delta
	var x = crosshair.amplitude * crosshair.frequency * cos(crosshair.frequency * time)	
	var distance = abs(Global.bird.global_position.y - crosshair.global_position.y)
	direction = -1 if crosshair.global_position.y < pivot else 1
	if distance > 2: 
		crosshair.position.y += direction * crosshair.searching_speed * delta
	crosshair.position.x += x * delta

func patrol(delta):
	time += delta
	var x = crosshair.amplitude * crosshair.frequency * cos(crosshair.frequency * time)
	if crosshair.global_position.y < top:
		direction = 1
	elif crosshair.global_position.y > bottom:
		direction = -1
	
	crosshair.position.y += direction * crosshair.searching_speed * delta
	crosshair.position.x += x * delta


func _on_proximity_area_entered(area):
	if state_machine.state != self:
		return
	
	transition_to.emit("Attacking", {})

func _on_region_area_entered(area):
	self.current_region = area.get_parent()
	self.pivot = current_region.pivot.get_global_position().y
	self.top = current_region.top_left.get_global_position().y
	self.bottom = current_region.bottom_right.get_global_position().y
