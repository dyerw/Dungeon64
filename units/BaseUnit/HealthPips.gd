extends Node2D

var health := 0 setget _set_health

func _draw():
	# Draw a dot for each health at the bottom of the sprite
	for i in range(health):
		var p = Vector2(i * 2, 7)
		draw_line(p, p + Vector2(1, 0), Color("#e83b3b"))

func _set_health(n: int):
	health = n
	update()
