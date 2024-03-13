extends State
@onready var crosshair = $"../.."
var noise = FastNoiseLite.new()
var noise_i: float = 0.0
var strength = 0.75


func physics_update(delta):
	var direction : Vector2 = Global.bird.position - crosshair.position
	if direction.length() >= 2:
		crosshair.position += direction.normalized() * crosshair.attacking_speed * delta
		

func _on_hit_area_entered(area):
	if state_machine.state != self:
		return
		
	transition_to.emit("Targeting", {})


