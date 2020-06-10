extends Control

onready var health_bar_over = $HealthOver
onready var health_bar_under = $HealthUnder
onready var update_tween = $UpdateTween

func _on_health_updated(health):
	health_bar_over.value = health
	update_tween.interpolate_property(health_bar_under, "value", health_bar_under.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	update_tween.start()
	
func _on_max_health_updated(max_health):
	health_bar_over.max_value = max_health
	health_bar_under.max_value = max_health
