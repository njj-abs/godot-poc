extends TextureRect

@onready var blast = $Blast

func play(coinIcon):
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_setPosition, Vector2(300, 500), coinIcon.position, 1)

	return tween

func _setPosition(value):
	position = value
