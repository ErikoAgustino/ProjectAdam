extends Camera2D


func shake(duration = 0.2, frequency = 15, amplitude = 20, priority = 0):
	$ScreenShake.start(duration,frequency,amplitude,priority)
	print("kameranya goyang")
