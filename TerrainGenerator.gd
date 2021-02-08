extends MeshInstance

var columns = 6
var rows = 12
#var scl = 2

func _ready():
	var vertices = PoolVector3Array()
#	vertices.push_back(Vector3(0, 0, 0))
#	vertices.push_back(Vector3(0, 0, 1))
#	vertices.push_back(Vector3(1, 0, 0))
#	vertices.push_back(Vector3(1, 0, 1))
	
	for y in range(columns):
		for x in range(rows):
			#print(x,y)
			vertices.push_back(Vector3(x, 0, y))
			vertices.push_back(Vector3(x, 0, y+1))
	
	print(vertices)
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_STRIP, arrays)
	var m = MeshInstance.new()
	m.mesh = arr_mesh
	
	# load the mesh
	self.add_child(m)
