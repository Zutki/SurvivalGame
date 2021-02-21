# THIS IS NOT MY SCRIPT, I ONLY MODIFIED IT AND COMMENTED IT
# ALL CREDIT FOR THE SCRIPT GOES TO CODAT (YOUTUBE)
# https://www.youtube.com/channel/UCSWBKqm0Rxxi-yZa0zyvDjA

extends Spatial

func _ready():
	var noise = OpenSimplexNoise.new()
	#noise.seed = 1200
	
	noise.seed = rand_range(0, 999999)
	
	noise.period = 400
	noise.octaves = 8
	
	# PRESETS FOR TERRAIN:
	# p = 200 & o = 8 : Slightly Hilly Terrain
	# p = 200 & o = 6 : somewhat hilly terrain
	
	
	
	var plane_mesh = PlaneMesh.new() # create the plane
	plane_mesh.size = Vector2(400, 400) # set the size of the plane
	plane_mesh.subdivide_depth = 200 # subdivide the plane in half
	plane_mesh.subdivide_width = 200 # subdivice the plane in half on another axis
	
	var surface_tool = SurfaceTool.new() # create surface tool
	surface_tool.create_from(plane_mesh, 0) # create surface tool "mesh" from the plane
	
	var array_plane = surface_tool.commit() # create the plane array from surface tool
	
	var data_tool = MeshDataTool.new() # create MeshDataTool
	
	data_tool.create_from_surface(array_plane, 0) # create the "mesh" from array_plane
	
	for i in range(data_tool.get_vertex_count()): # loop through each vertex
		var vertex = data_tool.get_vertex(i) # get the current vertex we are working with
		vertex.y = noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * 60 # scale the y value by the noise value
		
		data_tool.set_vertex(i, vertex) # set the vertex to our modified value
		
	# NOTE:
	# not sure what his happening from here on out, still gonna try to comment it though
	
	for i in range(array_plane.get_surface_count()): # loop through each surface in array_plane
		array_plane.surface_remove(i) # remove the surface
	
	data_tool.commit_to_surface(array_plane) # commit to surface using the array_plane
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES) # make a new mesh using the triangles primitive
	surface_tool.create_from(array_plane, 0) # create the mesh from array_plane
	surface_tool.generate_normals() # generate the normals
	
	# I know what is happening here
	var mesh_instance = MeshInstance.new() # create a new MeshInstance
	mesh_instance.mesh = surface_tool.commit() # set the mesh from surface tool
	mesh_instance.create_trimesh_collision() # setup the collion using the mesh
	mesh_instance.set_surface_material(0, load("res://terrain.material")) # apply the terrain material
	
	add_child(mesh_instance) # add it as a child
