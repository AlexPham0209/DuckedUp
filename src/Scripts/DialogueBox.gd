extends CanvasLayer

@onready var label = $Label

func _ready():
	StoryManager.display_text.connect(display_text)


func display_text(text):
	print(text)
	label.text = text


func _on_button_pressed():
	StoryManager.continue_story()
