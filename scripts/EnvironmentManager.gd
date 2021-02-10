extends Node

# number of trees to generate
export var trees = 300
export var stones = 300

export var mapSizeX = -200
export var mapSizeZ = 200

export var maxInvalid = 3
export var treeVerticleOffset = 0

func _ready():
	# GENERATERS HAVE BEEN DISABLED FOR NOW
	# WHILE WORKING ON TERRAIN GENERATOR!
	print("Generating ", stones, " Stones:")
	generateStones()
	print("Done.")

	print("Generating ", trees,  " Trees:")
	generateTrees()
	print("Done.")
	
func generateStones():
	for i in range(stones):
		var loadedStone = preload("res://prefab/stone.tscn")
		
		var stone = loadedStone.instance() 					# instance the stone
		add_child(stone) 									# add stone as child
		stone.new(mapSizeX, mapSizeZ, maxInvalid) 			# stone variables setup
		stone.instanceRun()									# tell the stone to set it self up
		
		# warning-ignore:integer_division
		# warning-ignore:unused_variable
		var percentDone = ((i+1)*100)/stones
		#print(percentDone, "% ", i+1, "|", stones)
	
func generateTrees():
	for i in range(trees):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var loadedTree
		var treeType # the type of tree that is being generated
		
		if rng.randf_range(1, 2) <= 1.5:
			loadedTree = preload("res://prefab/treeV2.tscn")  # load tree 1
			treeType = 2
		else:
			loadedTree = preload("res://prefab/treeV3.tscn")  # load tree 2
			treeType = 3
		
		var tree = loadedTree.instance() 										# instance the tree
		add_child(tree) 														# add tree as child
		tree.new(treeType, mapSizeX, mapSizeZ, maxInvalid, treeVerticleOffset)	# tell the tree to set it self up
		
		# warning-ignore:integer_division
		# warning-ignore:unused_variable
		var percentDone = ((i+1)*100)/trees
		#print(percentDone, "% ", i+1, "|", trees)
