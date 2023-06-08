extends Node

const transSine = Tween.TRANS_SINE
const easeInOut = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()

func start(duration, frequency, amplitude, priority):
	if (priority >= self.priority):
		self.priority = priority
		self.amplitude = amplitude
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 /float(frequency)
		$Duration.start()
		$Frequency.start()
		
		newShake()
		
func newShake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, transSine, easeInOut)
	$ShakeTween.start()

func reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, transSine, easeInOut)
	$ShakeTween.start()
	
	priority = 0

func _on_Frequency_timeout():
	newShake()


func _on_Duration_timeout():
	reset()
	$Frequency.stop()
