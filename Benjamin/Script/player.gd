extends CharacterBody3D

@onready var camera = $Camera3D
@onready var animPlayer = $AnimationPlayer
@onready var muzzle_flash = $Camera3D/Pistole/MuzzleFlash
@onready var raycast = $Camera3D/RayCast3D
@onready var health_bar = ProgressBar

var health = 3


const SPEED = 10
const JUMP_VELOCITY = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
	if Input.is_action_just_pressed("Shoot") and animPlayer.current_animation != "fire":
		play_shoot_effect.rpc()
		if raycast.is_colliding():
			var hit_player = raycast.get_collider()
			hit_player.receive_damage()
	
	
	if Input.is_action_just_pressed("ESC"):
		get_tree().quit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if animPlayer.current_animation == "fire":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		animPlayer.play("move")
	else:
		animPlayer.play("idle")

	move_and_slide()
	
@rpc("call_local")
func play_shoot_effect():
	animPlayer.stop()
	animPlayer.play("fire")
	muzzle_flash.restart()
	muzzle_flash.emitting = true
	
func receive_damage():
	health_bar = health
	health -= 1
	if health <= 0:
		queue_free()
	
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fire":
		animPlayer.play("idle")
