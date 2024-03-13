extends Node2D

@onready var bottom_right = $BottomRight
@onready var top_left = $TopLeft
@onready var pivot = $Pivot
@onready var trigger = $Trigger


func _on_trigger_area_entered(area):
	Signals.enter_region.emit(top_left.global_position.y, bottom_right.global_position.y, pivot.global_position.y, trigger)
