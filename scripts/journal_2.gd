extends Area2D

# Export variables to customize in the Inspector
@export var label_text2: String = "Influenza, or the flu, is a more severe viral
 infection than the common cold. Symptoms include high fever, 
body aches, fatigue, cough, and sore throat. It spreads 
through the air when an infected person coughs or sneezes. 
Getting a flu vaccine each year is the best way to prevent it. 
If you catch the flu, rest, stay hydrated, and take medicine to reduce fever and aches."
@export var display_time2: float = 8.0
@export var font_size2: int = 24
@export var label_offset2: Vector2 = Vector2(-50, -100)  # How far above the collision to show the label

# Label node
var label2: Label

func _ready():
	# Set up the collision detection
	body_entered.connect(_on_player_collision)
	
	# Create our label
	label2 = Label.new()
	label2.text= label_text2
	label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label2.vertical_alignment2 = VERTICAL_ALIGNMENT_CENTER
	
	# Set font size
	label2.add_theme_font_size_override("font_size", font_size2)
	
	# Set text color to yellow
	label2.add_theme_color_override("font_color", Color.YELLOW)
	
	# Add black outline for better visibility against different backgrounds
	label2.add_theme_constant_override("outline_size", 2)
	label2.add_theme_color_override("font_outline_color", Color.BLACK)
	
	# Add to scene but keep hidden initially
	add_child(label2)
	label2.visible = false

# Called when any body enters this Area2D
func _on_player_collision(body):
	# Check if colliding body is the player
		# Show the label above the collision area
		label2.visible = true
		
		# Position the label above the Area2D
		label2.position = label_offset2
		
		# Hide label after time expires
		get_tree().create_timer(display_time2).timeout.connect(
			func(): label2.visible = false
		)
