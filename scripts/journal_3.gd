extends Area2D

# Export variables to customize in the Inspector
@export var label_text: String = "Strep throat is a bacterial infection caused by Streptococcus 
bacteria. It leads to a very sore throat, difficulty swallowing, fever, and sometimes 
white patches on the tonsils. It spreads through saliva or nasal secretions. 
A doctor can diagnose it with a test and prescribe antibiotics to treat it. 
Rest and warm liquids can also help ease the symptoms.
"
@export var display_time: float = 8.0
@export var font_size: int = 24
@export var label_offset: Vector2 = Vector2(-50, -100)  # How far above the collision to show the label

# Label node
var label: Label

func _ready():
	# Set up the collision detection
	body_entered.connect(_on_player_collision)
	
	# Create our label
	label = Label.new()
	label.text = label_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Set font size
	label.add_theme_font_size_override("font_size", font_size)
	
	# Set text color to yellow
	label.add_theme_color_override("font_color", Color.YELLOW)
	
	# Add black outline for better visibility against different backgrounds
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	# Add to scene but keep hidden initially
	add_child(label)
	label.visible = false

# Called when any body enters this Area2D
func _on_player_collision(body):
	# Check if colliding body is the player
		# Show the label above the collision area
		label.visible = true
		
		# Position the label above the Area2D
		label.position = label_offset
		
		# Hide label after time expires
		get_tree().create_timer(display_time).timeout.connect(
			func(): label.visible = false
		)
