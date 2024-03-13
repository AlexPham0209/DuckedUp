extends State

@onready var crosshair = $"../.."
var time = 0
var pivot = 0
var top = 0
var bottom = 0
var direction = 1
var current_area : Area2D 

enum Action {
	START, 
	MOVING,
	PATROL
}

var action : Action = Action.START

func _ready():
	Signals.enter_region.connect(enter_region)

func enter(param : Dictionary = {}):
	time = 0


func physics_update(delta):
	match(action):
		Action.PATROL:
			patrol(delta)
			
		Action.MOVING:
			move(delta)
	
	
func move(delta):
	time += delta
	var x = crosshair.amplitude * crosshair.frequency * cos(crosshair.frequency * time)	
	var distance = abs(Global.bird.global_position.y - crosshair.global_position.y)
	
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

func enter_region(top, bottom, pivot, area):
	self.top = top
	self.bottom = bottom
	self.pivot = pivot
	if area != current_area:
		self.action = Action.MOVING
	
	direction = -1 if crosshair.global_position.y > pivot else 1
	
	
func _on_proximity_area_entered(area):
	if state_machine.state != self:
		return
	
	transition_to.emit("Attacking", {})


func _on_region_area_entered(area):
	if state_machine.state != self:
		return
	self.current_area = area
	self.action = Action.PATROL
