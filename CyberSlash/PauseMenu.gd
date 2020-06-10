extends Control


onready var resume_button = $VBoxContainer/ResumeButton
onready var quit_button = $VBoxContainer/QuitButton

var not_paused = true

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if not_paused:
			get_tree().paused = true
			not_paused = false
			visible = true
		else: 
			get_tree().paused = false
			not_paused = true
			visible = false

func _on_ResumeButton_pressed():
	get_tree().paused = false
	not_paused = true
	visible = false

func _on_QuitButton_pressed():
	get_tree().quit()

