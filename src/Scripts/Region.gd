extends Area2D

@onready var pivot = $Pivot
@onready var collision = $CollisionShape2D

func _on_area_entered(area):
	print("entered")
	var size = collision.shape.size
	var top = collision.global_position.y - size.y/2
	var bottom = collision.global_position.y + size.y/2
	var left = collision.global_position.x - size.x/2
	var right = collision.global_position.x + size.x/2
	Signals.enter_region.emit(top, bottom, left, right)
