extends Control

var template = {
	"baseId": "hello",
	"placeholders": {
		"ph": {
			"en": "back",
			"es": "front"
		}
	}
}

func _ready():
	$CenterContainer/GridContainer/Button.text = tr("hello").format({"ph": " njj"})

func _on_button_pressed():
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("es")
		#$CenterContainer/GridContainer/Button.text = tr("hello").format({"ph": " back"})
	else:
		TranslationServer.set_locale("en")
		#$CenterContainer/GridContainer/Button.text = tr("hello").format({"ph": " front"})
