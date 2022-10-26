extends Node2D

onready var trunc = get_node("Trunc")
onready var length = 10 setget set_length
var speed = 2

# Called when the node enters the scene tree for the first time.
func set_length(val):
	length = val
	trunc.set_nb(length)
	
func _ready() -> void:
#	$AnimationPlayer.play("New Anim", -1, randf()*0.1)
	pass

func _physics_process(delta: float) -> void:
	position += Vector2(-speed, 0)
	if position.x < 0:
		queue_free()
