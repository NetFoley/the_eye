extends Camera2D

var pos = position
var selected = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_out"):
		zoom *= 1.3
	if event.is_action_pressed("zoom_in"):
		zoom *= 0.8
	if event.is_action_pressed("select"):
		selected = true
		pos = get_global_mouse_position()
	if event.is_action_released("select"):
		selected = false
	if selected:
		position = pos-get_local_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
