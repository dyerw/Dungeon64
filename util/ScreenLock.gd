extends Node

class_name ScreenLock

var id

func _init():
	id = UUID.v4()

func request(emitter: Node):
	emitter.emit_signal("request_lock", id)

func release(emitter: Node):
	emitter.emit_signal("release_lock", id)
	self.queue_free()
