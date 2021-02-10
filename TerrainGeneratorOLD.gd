extends MeshInstance

# values above 100 cause the engine to lag
var columns = 10
var rows = 10
var NoiseScl = 1.5

# Noise Setup
var noise = OpenSimplexNoise.new()


func _ready():
	# Noise Configuration
	noise.seed = 44544
	noise.octaves = 4
	noise.period = 1.0
	noise.persistence = 0.8
	
	var vertices = PoolVector3Array()
	var arr_mesh = ArrayMesh.new()
	
	for y in range(columns):
		for x in range(rows):
			# Noise Generation
			var generatedNoise = noise.get_noise_2d(x, y)*NoiseScl
			var generatedNoise2 = noise.get_noise_2d(x, y+1)*NoiseScl
			
			vertices.push_back(Vector3(x, generatedNoise, y))
			vertices.push_back(Vector3(x, generatedNoise2, y+1))

#			if y % 2 == 0: # we are on an even line
#				vertices.push_back(Vector3(x, generatedNoise, y))
#				vertices.push_back(Vector3(x, generatedNoise2, y+1))
#
#			else: # we are on an odd line
#				vertices.push_back(Vector3(rows-x, generatedNoise, y))
#				vertices.push_back(Vector3(rows-x, generatedNoise2, y+1))

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, makeArray(vertices))
	var m = MeshInstance.new()
	
	print(arr_mesh.get_surface_count())
	
	var newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = Color(0,1,0,1)
	newMaterial.flags_unshaded = false

	m.material_override = newMaterial

	m.mesh = arr_mesh
		
	# make the terrain face the correct way
	m.rotation_degrees.x = 180
	
	# load the mesh
	self.add_child(m)

func makeArray(vectorList):
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vectorList
	arrays[ArrayMesh.ARRAY_NORMAL] = vectorList
	return arrays
