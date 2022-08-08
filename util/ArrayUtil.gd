class_name ArrayUtil

static func choose(arr: Array):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var index = rng.randi_range(0, arr.size()-1)
	return arr[index]
	
static func remove_value(arr: Array, value):
	arr.remove(arr.find(value))
