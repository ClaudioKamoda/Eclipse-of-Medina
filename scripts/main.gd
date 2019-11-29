extends Node


func _ready():
	#get nodes
	var player_health_bar = get_node('player/HealthBar')
	var SavePoint = get_node('SavePoint')
	var SavePoint2 = get_node('SavePoint2')
	var SavePoint3 = get_node('SavePoint3')
	var SavePoint4 = get_node('SavePoint4')
	var SavePoint5 = get_node('SavePoint5')
	
	#connect instances
	SavePoint.connect("health_updated", player_health_bar, "_on_health_updated")
	SavePoint2.connect("health_updated", player_health_bar, "_on_health_updated")
	SavePoint3.connect("health_updated", player_health_bar, "_on_health_updated")
	SavePoint4.connect("health_updated", player_health_bar, "_on_health_updated")
	SavePoint5.connect("health_updated", player_health_bar, "_on_health_updated")
	