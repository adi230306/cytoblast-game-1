extends CharacterBody2D

signal healthchanged

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var enemy_inrange=false
var enemy_inrange2=false
var enemy_cooldown=true
var enemy_cooldown2=true
var max_health=1000
var current_health: int= max_health 
var player_alive=true
var attack_ip=false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Area2D = $Attack
@onready var attackarea: CollisionShape2D = $Attack/attackarea
@onready var timer: Timer = $Timer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	enemy_attack()
	enemy_attack2()
	attacking()
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	if is_on_floor():
		if direction == 0:
			if attack_ip==false:
				animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Walk")
	else:
		animated_sprite_2d.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _on_hit_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inrange=true
	elif body.has_method("2_nd"):
		enemy_inrange2=true

func player():
	pass

func _on_hit_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inrange=false
	elif body.has_method("2_nd"):
		enemy_inrange2=false
		
func enemy_attack():
	if enemy_inrange and enemy_cooldown:
		current_health -= 15
		enemy_cooldown = false
		timer.start()
func enemy_attack2():
	if enemy_inrange2 and enemy_cooldown2:
		current_health -= 15
		enemy_cooldown = false
		timer.start()
	
		
		# Check if player health is zero or below
		if current_health <= 0:
			restart_level()

func restart_level():
	# Reload the current scene (restart level)
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	enemy_cooldown=true
	enemy_cooldown2=true

func attacking():
	if Input.is_action_just_pressed("attack"):
		Global.current_player_attack=true
		attack_ip=true
		animated_sprite_2d.play("attack")
		$"attack timer".start()

func _on_attack_timer_timeout() -> void:
	$"attack timer".stop()
	Global.current_player_attack=false
	attack_ip=false
