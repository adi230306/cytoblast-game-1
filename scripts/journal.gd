extends Control

# Nodes
@onready var book_sprite = $AnimatedSprite
@onready var info_label = $Label

# Messages for each level
var level_messages = {
	1: "Level 1 Complete!\n\nYou've taken your first step on this journey.",
	2: "Level 2 Complete!\n\nYour skills are improving, keep going!",
	3: "Level 3 Complete!\n\nImpressive progress, you're becoming stronger.",
	4: "Level 4 Complete!\n\nYou've overcome a significant challenge!",
	5: "Level 5 Complete!\n\nYou've mastered these trials. What awaits next?"
}

# The current level
var current_level = 1

# Function to show the end screen with level-specific message
func show_end_screen():
	# Play the book animation
	book_sprite.play("turning")  # Replace "turning" with your actual animation name
	
	# Get message for current level or use a default if level doesn't exist in dictionary
	var message = level_messages.get(current_level, "Level Complete!\n\nCongratulations on your achievement.")
	
	# Set the text to display
	info_label.text = message
	
	# Wait for the animation to finish
	await book_sprite.animation_finished
	
	# Show the label after the animation finishes
	info_label.visible = true
	info_label.show()

# Example of how to trigger this at the end of a level
func on_level_complete():
	show_end_screen()
	# Increment to the next level
	current_level += 1
