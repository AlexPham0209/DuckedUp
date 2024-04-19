extends Area2D
class_name Interaction

@export_file("*.dialogue") var dialogue_file : String #
@export var reveal_speed: int
var current_index = 0

#references interaction collided with
var current_interaction: Interaction 

#runs when it receives an interaction
func initiate_interaction() -> void:
	if current_interaction != null:
		current_interaction.receive_interaction()  #runs receive interaction function of the collided

#abstract function.  Override it to receive dialogue functions
func receive_interaction() -> void:
	print("override this")

#when another interaction object enters current instance interaction object
#the current interaction object saves the collided interaction object as a variable/reference
func _on_Interaction_area_entered(area):
	print("entered")
	current_interaction = area

#if current interaction is equal to the area left, it makes the current_interaction equal to nothing
func _on_Interaction_area_exited(area):
	if current_interaction == area:
		current_interaction = null
