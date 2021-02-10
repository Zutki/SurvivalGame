extends Spatial

var MaxInvalid # the maxium number of placement errors the tree is allowed to encounter
var InvalidErrors = 0 # the current number of errors encountered

var map_size_x
var map_size_z

func new(map_sizeX, map_sizeZ, max_invalid):
	MaxInvalid = max_invalid
	map_size_x = map_sizeX
	map_size_z = map_sizeZ
	
func instanceRun():
	# Set Random Position
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var x_coord = rng.randi_range(map_size_x, map_size_z)
	var z_coord = rng.randi_range(map_size_x, map_size_z)
	#print(x_coord, z_coord)
	
	# initial coords
	self.transform.origin = Vector3(x_coord, 1000, z_coord)
	
	# Ray Cast without using a raycast node
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(self.transform.origin, Vector3(0, -10000, 0), [self])
	
	if result:
		self.transform.origin.y = result.position.y
		self.rotation_degrees.y = rng.randi_range(0, 360) # Set Random rotation
		
	checkIfValid() # make sure the tree location is valid
			
func checkIfValid(): # function to check if the tree is in a valid position.
	
	if InvalidErrors >= MaxInvalid: # too many errors were encountered
		#print(" (!!!) Destroyed self, too many errors!")
		self.queue_free() # Destroy self
	
	elif self.transform.origin.y > 1:
		InvalidErrors += 1
		#print(" (!) Position not Valid!")
		self.transform.origin.y = 0.1

# godot go brrrrrr
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape): # check if we are intersecting another tree
	if area.name == "Area": # we are in violation
		instanceRun() # set new position
