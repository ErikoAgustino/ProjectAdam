extends CanvasLayer


func fadeOut():
	$ColorRect.color.a = 255
	$Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 0, 0.5, Tween.TRANS_EXPO)
	$Tween.start()
	
func fadeIn():
	$ColorRect.color.a = 0
	$Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 255, 0.5, Tween.TRANS_EXPO)
	$Tween.start()

func _on_Tween_tween_all_completed():
#	queue_free()
	pass
