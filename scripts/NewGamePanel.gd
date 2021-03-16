extends Panel

var world_types = ["Slightly Hilly", "Very Hilly", "Flat", "Custom"]

func _ready():
	var WorldType = get_node("WorldType") # get the WorldType drop down menu object
	
	# get rid of the default value of the labels for the custom terrain settings
	get_node("PerlinNoiseEditor/Period/value").text = String(get_node("EditTerrainGeneratorSettings/Period").value)
	get_node("PerlinNoiseEditor/Octave/value").text = String(get_node("EditTerrainGeneratorSettings/Octave").value)
	
	# TODO
	#var periods = []
	#var octaves = []
	
	for index in range(world_types.size()): # for loop to add items to drop down
		WorldType.add_item(world_types[index], index)


func _on_Random_toggled(button_pressed): # update the seed selector visibility
	var spinBox = get_node("WorldSeed/Seed")
	spinBox.visible = not button_pressed


func _on_WorldType_item_selected(index): # function called when user selects a new value from the spin box
	var PerlinEditor = get_node("PerlinNoiseEditor")
	PerlinEditor.visible = world_types[index] == "Custom"


func _on_Period_value_changed(value):
	var value_lbl = get_node("PerlinNoiseEditor/Period/value")
	value_lbl.text = String(value)


func _on_Octave_value_changed(value):
	var value_lbl = get_node("PerlinNoiseEditor/Octave/value")
	value_lbl.text = String(value)
