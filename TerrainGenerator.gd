extends MeshInstance

var columns = 50
var rows = 50
#var NoiseScl = 1.5
var NoiseScl = 1.5

# Noise Setup
var noise = OpenSimplexNoise.new()



func _ready():
	# Noise Configuration
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 1.0
	noise.persistence = 0.8
	
	# get some noise!
	#print(noise.get_noise_2d(2.0, 1.0))
	
	var vertices = PoolVector3Array()
	
	for y in range(columns):
		for x in range(rows):
			#print(x,y)
			#print(noise.get_noise_2d(x, y)*scl)
			
			# Noise Generation
			
			#heightMap.push_back(noise.get_noise_2d(x, y)*NoiseScl)
			
			
			# Vertex Generation
			vertices.push_back(Vector3(x, 0, y))
			vertices.push_back(Vector3(x, 0, y+1))
			
			#vertices.push_back(Vector3(x, 0, y))
			#vertices.push_back(Vector3(x, 0, y+1))
	
	#print(vertices)
	
	
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = vertices
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	#arr_mesh.regen_normalmaps()
	var m = MeshInstance.new()
	
	print(arr_mesh.get_surface_count())
	
	var newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = Color(1,1,1,1)
	newMaterial.flags_unshaded = false

	m.material_override = newMaterial

	m.mesh = arr_mesh
		
	# make the terrain face the correct way
	m.rotation_degrees.x = 180
	
	# load the mesh
	self.add_child(m)
