extends KinematicBody

var speed = 500 # Player Speed
var jumpingForce = 1200

var runSpeed = 1000 # running speed

var speedH = 0.1 # Camera movement speed
var speedV = 0.1 # Camera movement speed

var gravity = 475 # gravity speed, def 900

var jumpHeight = 4

var noClip = false # Is player in noclip mode?
var outOfBoundsLimit = -25 # Limit before the player teleported back to the map

# internal variables
var yaw = 0.0
var pitch = 0.0

var isJumping
var allowJumping
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	isJumping = false
	allowJumping = true
	
#####################
#   Generic Input   #
#####################

func _input(event):
	if Input.is_key_pressed(KEY_N):
		noClip = true
		print("Entering noclip mode")
	if Input.is_key_pressed(KEY_M):
		noClip = false
		print("Entering normal mode")
		
	# exit the game
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		# Camera movement relative
		yaw -= speedH * event.relative.x
		pitch -= speedV * event.relative.y
	

var elapsed
var starting_height

var height_to_jump_to

func _physics_process(delta):
	# noclip stuff
	$CollisionShape.disabled = noClip
	
	# Checking if player is allowed to jump
	var space_state = get_world().direct_space_state
	var cast_from = self.transform.origin + Vector3(0, 3, 0)
	var cast_to = Vector3(self.transform.origin.x, -100, self.transform.origin.z)
	var result = space_state.intersect_ray(cast_from, cast_to, [self])
	 
	var dbText = get_node("../UI/DebugText")
	
	dbText.text = "Player Position: " + String(self.transform.origin)
	if result.size() != 0:
		dbText.text += "\nGround Distance: " + String(self.transform.origin.y - result.position.y)
	dbText.text += "\nJumping Enabled: " + String(isJumping)
	dbText.text += "\nJumping Allowed: " + String(allowJumping)
	
	####################
	#   Jumping Code   #
	####################
	
	if Input.is_key_pressed(KEY_SPACE) and isJumping == false and allowJumping == true:
		isJumping = true
		allowJumping = false
		starting_height = self.transform.origin.y
		height_to_jump_to = starting_height + jumpHeight
		elapsed = 0.0
	
	if isJumping == true:
		self.transform.origin.y = lerp(starting_height, height_to_jump_to, elapsed)
		elapsed += delta * 2
		if (self.transform.origin.y >= height_to_jump_to):
			isJumping = false
	
	if result.size() != 0:
		allowJumping = self.transform.origin.y - result.position.y < 0.5
	
	###############
	#   Gravity   #
	###############
	
	if !noClip:
		# warning-ignore:return_value_discarded
		#move_and_slide(Vector3.DOWN * delta * gravity)
		if result.size() != 0 and isJumping == false:
			if self.transform.origin.y - result.position.y < 0.5:
				self.transform.origin.y = result.position.y
			else:
				# warning-ignore:return_value_discarded
				move_and_slide(Vector3.DOWN * delta * gravity)
	
	var forwards_backwards
	var sideways
	
	# noclip stuff
	if !noClip:
		# if the player is not in no clip mode, then the player will not move up or down based on where the camera is looking
		forwards_backwards = Vector3($Camera.global_transform.basis.z.x, 0, $Camera.global_transform.basis.z.z) * -1
		sideways = Vector3($Camera.global_transform.basis.x.x, 0, $Camera.global_transform.basis.x.z) * -1
	else:
		forwards_backwards = $Camera.global_transform.basis.z * -1
		sideways = $Camera.global_transform.basis.x * -1
	
	keyboard_movement(delta, forwards_backwards, sideways)

	# Camera movement
	if pitch >= 90:
		pitch = 90
	if pitch <= -90:
		pitch = -90
		
	# TODO: input smoothing
	$Camera.rotation_degrees = Vector3(pitch, yaw, 0)

#######################
#  Keyboard Movement  #
#######################

func keyboard_movement(delta, forwards_backwards, sideways):
	var current_speed
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = runSpeed
	else:
		current_speed = speed 
	
	if Input.is_key_pressed(KEY_W):
		# warning-ignore:return_value_discarded
		move_and_slide(forwards_backwards * current_speed * delta)
	
	if Input.is_key_pressed(KEY_S):
		# warning-ignore:return_value_discarded
		move_and_slide(forwards_backwards * -1 * current_speed * delta)
		
	if Input.is_key_pressed(KEY_A):
		# warning-ignore:return_value_discarded
		move_and_slide(sideways * current_speed * delta)
		
	if Input.is_key_pressed(KEY_D):
		# warning-ignore:return_value_discarded
		move_and_slide(sideways * -1 * current_speed * delta)
