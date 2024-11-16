extends TextureRect

var coinIconPosition

@onready var blast = $Blast

func play(coinIcon):
	coinIconPosition = coinIcon.position

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(randf_range(0.3, 1))
	tween.tween_property(self, "position", coinIcon.position, 2).from(Vector2(300, 500))
	tween.tween_callback(func(): blast.emitting = true)
