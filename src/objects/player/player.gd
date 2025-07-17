extends CharacterBody2D
@export var speed = 300.0
@export var jump_speed = -400.0

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var wasInAir = false
var isAttacking = false;
var attackCounter = 2

func run(): 
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	if (direction > 0):
		$view.flip_h = false
	elif (direction < 0):
		$view.flip_h = true
		
	attack()
	animate()
	move_and_slide()
	
func attack():
	if (Input.is_action_just_pressed("attack")):
		isAttacking = true
		wasInAir = false
		$animPlayer.play('attack_' + str(attackCounter))

		var finished_anim = await $animPlayer.animation_finished
		if (finished_anim == 'attack_' + str(attackCounter)):
			attackCounter = 1 if attackCounter == 2 else 2
			isAttacking = false

func animate(): 
	if (isAttacking):
		return
		
	
	if (wasInAir and is_on_floor() and velocity.x == 0):
		$animPlayer.play('land')
		
		var finished_anim = await $animPlayer.animation_finished
		if (finished_anim == 'land'):
			wasInAir = false
	elif (velocity.x == 0 and is_on_floor()):
		$animPlayer.play('idle')
	elif (velocity.x != 0 and is_on_floor()):
		$animPlayer.play('run') 
		wasInAir = false
	elif(is_on_floor() == false and velocity.y < 0):
		$animPlayer.play('jump')
		wasInAir = true

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	run()
	


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemyArea"):
		print("HIT")
