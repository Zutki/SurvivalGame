extends Label

var displayText = []

func addText(Text):
	displayText.append(Text)

func reset():
	self.text = ""
	displayText = []
	
func _process(delta):
	for string in displayText:
		self.text += string
	reset()
