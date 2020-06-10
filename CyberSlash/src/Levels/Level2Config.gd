extends Node2D

func _ready():
	$RocketBotSpawner.set_platform_bounds(230, 635)
	$BasicBotSpawner.set_platform_bounds(535, 985)
