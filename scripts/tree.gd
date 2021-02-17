
extends Spatial

var MaxInvalid # the maxium number of placement errors the tree is allowed to encounter
var InvalidErrors = 0 # the current number of errors encountered
var verticleOffset # the verticle offset into the ground (ONLY APPLIES TO TREEV2)

var map_size_x
var map_size_z

var selfType

func new(treeType, map_sizeX, map_sizeZ, max_invalid, vertOffset):
	map_size_x = map_sizeX
	map_size_z = map_sizeZ
	MaxInvalid = max_invalid
	verticleOffset = vertOffset
	
	selfType = treeType
	instanceRun(treeType)

# warning-ignore:shadowed_variable
func instanceRun(selfType):
	# Set Random Position
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var x_coord = rng.randi_range(map_size_x, map_size_z)
	var z_coord = rng.randi_range(map_size_x, map_size_z)
	#print(x_coord, z_coord)
	
	self.transform.origin = Vector3(x_coord, 1000, z_coord)
	
	# Ray Cast without using a raycast node
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(self.transform.origin, Vector3(0, -10000, 0), [self])
	
	if result:
		if selfType == 2:
			self.transform.origin.y = result.position.y + verticleOffset
		
		else:
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

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape): # check if we are intersecting another tree
	if area.name == "Area": # we are in violation
		instanceRun(selfType) # set new position
