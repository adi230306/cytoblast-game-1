extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Ensure this node exists
@onready var attackcol: CollisionShape2D = $attackcol

var speed = 50
var player_chase = false
var player = null
var has_spawned = false  # Track if spawn animation has played
var health=100
var player_inrange=false
var can_damage=true
@export var journal_id: String = "enemy_name"  # Unique ID for journal
@export var journal_description: String = "Description of this enemy type."



func _ready():
	print("Enemy Script Loaded")

func _physics_process(delta):
	deal_with_damage()
	if player_chase and player:
		# Get direction towards player
		var move_direction = (player.position - position).normalized()
		velocity = move_direction * speed

		# Flip sprite towards player
		animated_sprite_2d.flip_h = move_direction.x < 0

		# Play walk animation after spawning
		animated_sprite_2d.play("walk")

		# Wall avoidance logic using RayCasts
		if ray_cast_2d.is_colliding():
			velocity.x = -speed  # Move away from wall
		if ray_cast_2d_2.is_colliding():
			velocity.x = speed  # Move away from wall

	else:
		velocity = Vector2.ZERO  # Stop movement when player exits

	move_and_slide()

func _on_detect_body_entered(body: Node2D) -> void:
	if not has_spawned:
		animated_sprite_2d.play("idle")  # Play spawn animation once
		await animated_sprite_2d.animation_finished  # Wait until idle animation ends
		has_spawned = true  # Mark spawn as completed
	
	player = body
	player_chase = true

func _on_detect_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy2():
	pass

func _on_enemyhit_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_inrange=true

func _on_enemyhit_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_inrange=false
func deal_with_damage():
	if player_inrange and Global.current_player_attack==true:
		if can_damage==true:
			health=health-25
			$cooldown.start()
			can_damage=false
			if health<=0:
				self.queue_free()
				


func _on_cooldown_timeout() -> void:
	can_damage=true
