extends CharacterBody2D


var speed = 10.0
var direction:=Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func fire_to_point(point:Vector2):
	direction = position.direction_to(point)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity = direction 
