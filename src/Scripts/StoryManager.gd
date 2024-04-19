extends Node

signal display_text(text : String)
var resource
var current_dialogue
var choices_dict  : Dictionary
var dialogue_box = preload("res://src/Scenes/DialogueBox.tscn")

#Loads in the story
func load_story(file : String):
	resource = load(file)	
	
func start_story():
	current_dialogue = await DialogueManager.get_next_dialogue_line(resource, "this_is_a_node_title")
	display_text.emit(current_dialogue.text)
	
	var box_instance = dialogue_box.instantiate()
	get_tree().get_root().add_child(box_instance)
	display_text.emit(current_dialogue.text)
	

func continue_story(id := str(current_dialogue.next_id)):
	current_dialogue = await DialogueManager.get_next_dialogue_line(resource, id)
	
	if (current_dialogue == null):
		end_story()
		return
	
	var choices = current_dialogue.responses
	
	#Add all choices to a dictionary and clears if its empty
	if choices.size() > 0: 
		for choice in choices:
			choices_dict[choice.text.to_lower()] = choice.next_id
	else:
		choices_dict.clear()
	
	display_text.emit(current_dialogue.text)
	
		
func end_story():
	print("end")
	
func select_choice(index):
	pass
	#index(index)
