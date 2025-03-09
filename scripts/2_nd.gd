extends CharacterBody2D

@onready var ani: AnimatedSprite2D = $ani
@onready var attackco: CollisionShape2D = $attackco
@onready var ray_cast_2d_1: RayCast2D = $RayCast2D1
@onready var ray_cast_2d_3: RayCast2D = $RayCast2D3





var speed1 = 50
var player_chase1 = false
var player1 = null
var has_spawned1 = false
var health1 = 100
var player_inrange1 = false
var can_damage1 = true

func _ready():
	print("Enemy Script Loaded")

func _physics_process(delta):
	deal_with_damage()
	if player_chase1 and player1:
		var move_direction1 = (player1.position - position).normalized()
		velocity = move_direction1 * speed1
		ani.flip_h = move_direction1.x < 0
		ani.play("walk1")

		if ray_cast_2d_1.is_colliding():
			velocity.x = -speed1
		if ray_cast_2d_3.is_colliding():
			velocity.x = speed1
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_detect_body_entered(body: Node2D) -> void:
	if not has_spawned1:
		ani.play("idle1")
		await ani.animation_finished
		has_spawned1 = true
	
	player1 = body
	player_chase1 = true

func _on_detect_body_exited(body: Node2D) -> void:
	player1 = null
	player_chase1 = false

func _on_enemyhit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inrange1 = true
		print("Player entered attack range")

func _on_enemyhit_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inrange1 = false
		print("Player exited attack range")

func deal_with_damage():
	if player_inrange1 and Global.current_player_attack and can_damage1:
		print("Player attacked enemy")
		health1 -= 25
		can_damage1 = false
		$cooldown2.start()

		if health1 <= 0:
			print("Enemy destroyed")
			self.queue_free()

func _on_cooldown_timeout() -> void:
	can_damage1 = true
