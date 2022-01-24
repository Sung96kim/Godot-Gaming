extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

enum {
	IDLE, 
	WANDER,
	CHASE
}

var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state: 
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		WANDER: 
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null: 
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
	velocity = move_and_slide(velocity)

func seek_player(): 
	if playerDetectionZone.can_see_player(): 
		state = CHASE

func _on_HurtBox_area_entered(area):
	queue_free() # Replace with function body.
