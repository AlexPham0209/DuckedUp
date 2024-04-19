class_name Region
extends Area2D

@onready var pivot = $Pivot
@onready var collision = $CollisionShape2D
@export var prev : NodePath

func _on_area_entered(area):
	change_region(collision)

func _on_area_exited(area):
	var prev_node = get_node_or_null(prev) as Region
	if prev_node == null or Global.bird.global_position.y < collision.global_position.y:
		print("return")
		return
	change_region(prev_node.collision)

func change_region(collision):
	var size = collision.shape.size
	var top = collision.global_position.y - size.y/2
	var bottom = collision.global_position.y + size.y/2
	var left = collision.global_position.x - size.x/2
	var right = collision.global_position.x + size.x/2
	Signals.enter_region.emit(top, bottom, left, right)
