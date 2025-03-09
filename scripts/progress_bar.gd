extends ProgressBar
@onready var wbc: CharacterBody2D = $".."

func _ready():
	wbc.healthchanged.connect(update)
	update()

func update():
	value=wbc.current_health*100/wbc.max_health
