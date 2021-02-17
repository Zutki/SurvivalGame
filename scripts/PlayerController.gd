extends KinematicBody

var speed = 500 # Player Speed
var jumpingForce = 1200

var speedH = 0.1 # Camera movement speed
var speedV = 0.1 # Camera movement speed

var gravity = 475 # gravity speed, def 900
var noClip = true # Is player in noclip mode?
var outOfBoundsLimit = -25 # Limit before the player teleported back to the map

var yaw = 0.0
var pitch = 0.0

var allowJumping
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	allowJumping = true
	
func _input(event):
	if Input.is_key_pressed(KEY_N):
		noClip = true
		print("Entering noclip mode")
	if Input.is_key_pressed(KEY_M):
		noClip = false
		print("Entering normal mode")
	
	if event is InputEventMouseMotion:
		# Camera movement

		yaw -= speedH * event.relative.x
		pitch -= speedV * event.relative.y
	
	
func _physics_process(delta):
	# noclip stuff
	$CollisionShape.disabled = noClip
	
	# Checking if player is allowed to jump
	var space_state = get_world().direct_space_state
	var cast_from = self.transform.origin + Vector3(0, 3, 0)
	var cast_to = Vector3(self.transform.origin.x, -100, self.transform.origin.z)
	var result = space_state.intersect_ray(cast_from, cast_to, [self])
	
	# if the player is above 2.92 then they cant jump
	#allowJumping = (self.transform.origin.y - result.position.y) <= 2.92
	#print(allowJumping)
	
	# debug stuff, just shows some info on the hud
	get_node("../UI/Noti").text = "CURRENT POSITION: " + String(self.transform.origin)
	
	
	
	# make sure that the player didn't fall of the map
	#if transform.origin.y < outOfBoundsLimit:
		#transform.origin = Vector3(0, 0, 0)
	
	
	# Gravity
	
	var forwards_backwards
	var sideways
	
	if !noClip:
		# warning-ignore:return_value_discarded
		move_and_slide(Vector3.DOWN * delta * gravity)
	
	
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if !noClip:
		forwards_backwards = Vector3($Camera.global_transform.basis.z.x, 0, $Camera.global_transform.basis.z.z) * -1
		sideways = Vector3($Camera.global_transform.basis.x.x, 0, $Camera.global_transform.basis.x.z) * -1
	else:
		forwards_backwards = $Camera.global_transform.basis.z * -1
		sideways = $Camera.global_transform.basis.x * -1
	
	
	# Movement using keyboard
	if Input.is_key_pressed(KEY_W):
		# warning-ignore:return_value_discarded
		move_and_slide(forwards_backwards * speed * delta)
	
	if Input.is_key_pressed(KEY_S):
		# warning-ignore:return_value_discarded
		move_and_slide(forwards_backwards * -1 * speed * delta)
		
	if Input.is_key_pressed(KEY_A):
		# warning-ignore:return_value_discarded
		move_and_slide(sideways * speed * delta)
		
	if Input.is_key_pressed(KEY_D):
		# warning-ignore:return_value_discarded
		move_and_slide(sideways * -1 * speed * delta)
		
	# jumping
	if Input.is_key_pressed(KEY_SPACE) and allowJumping == true:
		allowJumping = false
		# warning-ignore:return_value_discarded
		move_and_slide(Vector3.UP * jumpingForce * delta)
		
	# Camera movement
	if pitch >= 90:
		pitch = 90
	if pitch <= -90:
		pitch = -90
		
	# TODO: input smoothing
	$Camera.rotation_degrees = Vector3(pitch, yaw, 0)
