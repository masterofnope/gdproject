extends Control

const title = "CYBERSLASH"
const new_game = "NEW GAME"

var index = 0
var state = 0 # 0 for title, 1 for new game, 2 for blinking new game
var hidden = false

func _ready():
	$Timer.connect("timeout", self, "type")
	$Timer.start()

func type():
	if state == 0:
		$TitleLabel.text = title.substr(0, index)
		index += 1
		if index > len(title):
			state += 1
			index = 0
	elif state == 1:
		$NewGameLabel.text = new_game.substr(0, index)
		index += 1
		if index > len(new_game):
			state += 1
			$Timer.set_wait_time(0.5)
	else:
		if hidden:
			$NewGameLabel.show()
		else:
			$NewGameLabel.hide()
		hidden = not hidden
	$Timer.start()
