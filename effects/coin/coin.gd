extends Control

const COIN_ICON_SCENE = preload("res://effects/coin/coin_icon.tscn")

var coinAmount = 5

@onready var coinIcon = $CoinIcon

func _ready():
	_animateCoin()

func _animateCoin():
	for i in coinAmount:
		var coin = await _createCoin()
		coin.play(coinIcon)

func _createCoin():
	var coinScene = COIN_ICON_SCENE.instantiate()
	add_child(coinScene)

	return coinScene

func _on_button_pressed():
	_animateCoin()
