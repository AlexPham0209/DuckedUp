extends State
@onready var crosshair = $"../.."
@onready var timer = $"../../Timer"

func enter(param : Dictionary = {}):
	timer.start()

func _on_timer_timeout():
	print("hit")
	Signals.hit.emit()
	timer.start()
	


func _on_hit_area_exited(area):
	if state_machine.state != self:
		return
		
	timer.stop()
	await get_tree().create_timer(crosshair.delay).timeout
	transition_to.emit("Searching", {})
