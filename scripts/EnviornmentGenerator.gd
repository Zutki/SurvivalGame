extends Spatial

var treeArray = ["res://prefab/treeV2.tscn", "res://prefab/treeV3.tscn"] # internal Array Contains all needed trees
var foliageArray = ["res://prefab/stone.tscn"] # internal Array contains all foliage except trees

export var mapSize = Vector2() # how big the map is
export var startingHeight = int() # where we start
#export var startingLocation = Vector3() # where the starting location is

export var RaycastDistanceDown = int() # how far to raycast down

export var NumberOfTrees = int()
export var NumberOfFoliage = int()

var exclusions = []

############################################
#  THIS CODE IS OLD AND NO LONGER USED!!!  #
############################################

##################################
#								 #
#         Generator Code         #
#								 #
##################################


func generateObject(objectArray, objectIndex, verticleOffset, rotation, startingLocation):
	# Load the object
	var loadedObject = load(objectArray[objectIndex]) # load it
	var instancedObject = loadedObject.instance() # instance it
	add_child(instancedObject) # add it as a child
	
	exclusions.append(instancedObject)
	
	# Object start
	instancedObject.transform.origin = Vector3(startingLocation.x, startingHeight, startingLocation.z)
	instancedObject.rotation_degrees = rotation
	
	# Raycast down to get bottom of the current location
	var space_state = get_world().direct_space_state
	var cast_from = instancedObject.transform.origin
	var cast_to = Vector3(instancedObject.transform.origin.x, RaycastDistanceDown, instancedObject.transform.origin.z)
	var result = space_state.intersect_ray(cast_from, cast_to, exclusions)
	
	# Set Position
	instancedObject.transform.origin = Vector3(instancedObject.transform.origin.x, result.position.y + verticleOffset, instancedObject.transform.origin.z)
	
##################################
#								 #
#  Code to generate enviornment  #
#								 #
##################################
	
	
func _ready():
	var rng = RandomNumberGenerator.new() # initialize rng
	rng.randomize() # randomize the values
	
	# generate some trees
	print("Making trees")
	for currTree in range(NumberOfTrees):

		var x_coord = rng.randi_range(mapSize.x, mapSize.y) # get the x coordinate
		var z_coord = rng.randi_range(mapSize.x, mapSize.y) # get the z coordinate

		var startLoc = Vector3(x_coord, 0, z_coord)
		var randomRot = Vector3(0, rng.randf_range(0, 360), 0)

		generateObject(treeArray, rng.randi_range(0, treeArray.size()-1), -0.1, randomRot, startLoc)

	print("Done making trees")
	
	print("Making stone")
	for currFoliage in range(NumberOfFoliage):
		
		var x_coord = rng.randi_range(mapSize.x, mapSize.y) # get the x coordinate
		var z_coord = rng.randi_range(mapSize.x, mapSize.y) # get the z coordinate
	
		var startLoc = Vector3(x_coord, 0, z_coord)
		var randomRot = Vector3(0, rng.randf_range(0, 360), 0)
		
		generateObject(foliageArray, rng.randi_range(0, foliageArray.size()-1), -0.1, randomRot, startLoc)
	
	print("Done making stone")
