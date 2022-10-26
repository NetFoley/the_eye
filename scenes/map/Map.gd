extends Node2D

export var noise_map : Texture 
onready var spr = $Sprite
onready var text = spr.texture.get_data()
onready var s = load("res://scenes/tree/tree.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var __ = $Timer.connect("timeout", self, "_timeout")
	yield(spr.texture, "changed")
	text = spr.texture.get_data()
	spawn_trees()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("full_screen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

func _timeout() -> void:
	spawn_trees_at()
	

func spawn_trees():
	for i in range(text.get_height()):
		for j in range(text.get_width()):
			spawn_tree_at_noise_pos(Vector2(j,i))
	
func spawn_trees_at():
	$Sprite.texture.set_noise_offset($Sprite.texture.noise_offset - Vector2(1,0))
	for i in range(text.get_height()):
		spawn_tree_at_noise_pos(Vector2(text.get_width()-1, i))
	
func spawn_tree_at_noise_pos(pos):
	text =spr.texture.get_data()
	text.lock()
	var pixel = text.get_pixel(pos.x, pos.y)
	var val = 1.0 - pixel.r
	if val > 0.7:
		var inst = s.instance()
		$YSort.add_child(inst)
		var layer = (pos.y+5)*0.05
		inst.length = pow(val, 4.0)*300.0
		inst.position = Vector2(pos.x*450+randi()%450, pos.y*5)
		inst.scale = Vector2(0.1+pos.y/text.get_height(), 0.1+pos.y/text.get_height())
		inst.speed = layer
		var inta = 1.15-pos.y*0.7/text.get_height()
		inst.set_modulate(Color(inta,inta,inta))
	text.unlock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
