extends Spatial

export var interaction_distance_limit = int()
# var timer

#func _ready():
#	timer = get_node("../../UI/Timer")
#	timer.start()
	
func _process(delta):
#	var part = timer.wait_time - timer.time_left
#	var whole = timer.wait_time
#
#	var percent = (part * 100) / whole
#
#	if percent >= 99:
#		timer.stop()
#		timer.wait_time = 3
#
#	get_node("../../UI/TextureProgress").value = percent
	pass
	
var debug_object

func _ready():
	debug_object = preload("res://Models/sphere.tscn")
	debug_object = debug_object.instance()
	add_child(debug_object)
	
func _input(event):
	
	# idfk why this refuses to work. It doesnt detect the object the player is looking
	# then again the fuck did I expect when 
	# I decided to use some weird ass method to get the object the player is looking at
	
	# I will try to unfuck the code when I manage to get to get around to it
	# for the record this was said on 2021-03-22 2:22 AM
	
	if Input.is_key_pressed(KEY_F):
		# raycast from camera to get what the player is looking at
		var camera = get_node("../Camera")
		
		#var cast_from = camera.transform.origin
		
		var from = camera.project_ray_origin(event.postion)
		var to = from + camera.project_ray_normal(event.position) * interaction_distance_limit
		
		#var cast_to = camera.global_transform.basis.z * -1 * interaction_distance_limit
		var space_state = camera.get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [self, get_parent()])
		
		if not result.empty():
			var object_name = result.collider.get_parent().name
			var cleaned_name = object_name.replace("@", "")
			print(cleaned_name)
			
			get_node("../../UI/Interact").text = cleaned_name
			debug_object.transform.origin = result.collider.get_parent().transform.origin
