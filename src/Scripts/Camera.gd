extends Camera2D

@onready var top_left : Marker2D = $Limits/TopLeft
@onready var bottom_right : Marker2D = $Limits/BottomRight

@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SHAKE_STRENGTH: float = 60.0
@export var SHAKE_DECAY_RATE: float = 3.0
@export var time = 0.25

@onready var noise = FastNoiseLite.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0
var tween : Tween 

func _ready():
	Signals.hit.connect(screen_shake)
	Signals.enter_region.connect(enter_region)
#	self.limit_left = top_left.position.x
#	self.limit_top = top_left.position.y
#
#	self.limit_right = bottom_right.position.x
#	self.limit_bottom = bottom_right.position.y
	
func screen_shake():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "shake_strength", NOISE_SHAKE_STRENGTH, time).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "shake_strength", 0, time).set_ease(Tween.EASE_IN_OUT)

func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	var shake_offset = get_random_offset()
	self.offset = shake_offset


func enter_region(top, bottom, left, right):
	self.limit_left = left
	self.limit_top = top

	self.limit_right = right
	self.limit_bottom = bottom
	
func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
