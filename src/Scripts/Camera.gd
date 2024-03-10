extends Camera2D

@onready var top_left : Marker2D = $Limits/TopLeft
@onready var bottom_right : Marker2D = $Limits/BottomRight

func _ready():
	self.limit_left = top_left.position.x
	self.limit_top = top_left.position.y

	self.limit_right = bottom_right.position.x
	self.limit_bottom = bottom_right.position.y

