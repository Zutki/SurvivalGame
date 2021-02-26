extends Control

var newGamePanel
var settingsPanel

func _ready():
	newGamePanel = get_node("Panels/NewGamePanel")
	settingsPanel = get_node("Panels/SettingsPanel")
	
	
# New Game
func _on_NewGame_button_down():
	settingsPanel.visible = false
	newGamePanel.visible = not newGamePanel.visible

# Settings
func _on_Settings_button_down():
	newGamePanel.visible = false
	settingsPanel.visible = not settingsPanel.visible
	
# Quit Game
func _on_Quit_button_down():
	get_tree().quit()

