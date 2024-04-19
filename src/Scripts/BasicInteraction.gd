extends Interaction

func receive_interaction():
	StoryManager.load_story(dialogue_file)
	StoryManager.start_story()
	
