extends Line2D

onready var timer = $Timer
export var nb_points = 0 setget set_nb
var nb_branch = 0
export var b_lengh = 15
export var animated = true
export var start_angle = 0.0
export var stop_light = true

func set_nb(val):
	if val < nb_points:
		clear_points()
		var children = get_children()
		for c in children:
			if !c is Timer:
				c.queue_free()
			
	nb_points = val
	nb_branch = 0
	
#	for _i in range(nb_points):
#		expand_branch()

func _ready() -> void:
	var __ = timer.connect("timeout", self, "_on_timeout")
	if animated:
		$AnimationPlayer.play("New Anim", -1, 0.01+randf()*0.1)

func _on_timeout():
	if points.size() < nb_points:
		expand_branch()

func expand_branch():
	var last_point_pos = get_point_pos(points.size())
	var randoffset = (randf()-0.5)*0.8
	if points.size() > 0:
		last_point_pos += Vector2(0.0,-b_lengh*2).rotated(get_point_angle(points.size())+randoffset).linear_interpolate(Vector2.UP*b_lengh, 0.05)
	add_point(last_point_pos)
	set_width(1+points.size()*b_lengh/10)
	
	if stop_light and points.size() > 2:
		var new_array = points
		var poly = OccluderPolygon2D.new()
		poly.set_polygon(new_array)
		$LightOccluder2D.set_occluder_polygon(poly)
		
	if randi()%(4*(nb_branch)+12) == 0:
		var b_size = (nb_points-points.size())
		if b_size > 1:
			add_branch(points.size(), b_size*(randf()*0.6+0.3))

func add_branch(point= 0, l = 0):
	if l < 1:
		return
	nb_branch += 1
	var b_inst = GAME.b_scene.instance()
	b_inst.position = get_point_pos(point)
	b_inst.b_lengh = b_lengh
	b_inst.nb_points = l
	b_inst.stop_light = stop_light
	b_inst.start_angle = start_angle
	b_inst.animated = animated
	add_child(b_inst)
#	b_inst.set_width(width - point)

func get_point_pos(pos = 0):
	if points.size() > 0:
	 return points[pos-1]
	return Vector2.ZERO

func get_point_angle(pos):
	if points.size() > 1:
	 return (points[pos-1]-points[pos-2]).angle()+PI/2
	return start_angle
	
