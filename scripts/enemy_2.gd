extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attackcol: CollisionShape2D = $attackcol

var speed = 50
var player_chase = false
var player: Node2D = null
var has_spawned = false
var health = 100
var player_inrange = false
var can_damage = true

func _physics_process(delta):
	deal_with_damage()

	if player_chase and player:
		var move_direction = (player.global_position - global_position).normalized()
		
		# Handle wall avoidance
		if ray_cast_2d.is_colliding():
			move_direction.x = 0  # Stop moving if colliding with a wall
		elif ray_cast_2d_2.is_colliding():
			move_direction.x = 0  # Stop moving if colliding with a wall

		velocity = move_direction * speed

		# Flip sprite towards the player
		animated_sprite_2d.flip_h = move_direction.x < 0

		# Play walking animation
		if has_spawned:
			animated_sprite_2d.play("walk")

	else:
		velocity = Vector2.ZERO  # Stop moving if the player is not in range

	move_and_slide()

func _on_detect_body_entered(body: Node2D) -> void:
	if not has_spawned:
		animated_sprite_2d.play("idle")
		await animated_sprite_2d.animation_finished
		has_spawned = true

	player = body
	player_chase = true

func _on_detect_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemyhit_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_inrange = true

func _on_enemyhit_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_inrange = false

func deal_with_damage():
	if player_inrange and Global.current_player_attack:
		if can_damage:
			health -= 25
			$cooldown.start()
			can_damage = false

			if health <= 0:
				await animated_sprite_2d.animation_finished
				queue_free()

func _on_cooldown_timeout() -> void:
	can_damage = true
