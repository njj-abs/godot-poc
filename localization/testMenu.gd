extends Control

func _ready():
	$CenterContainer/GridContainer/Button.text = tr("hello {ph}").format({"ph": " njj"})
	pass

func _on_button_pressed():
	if TranslationServer.get_locale() == "en":
		TranslationServer.set_locale("es")
	else:
		TranslationServer.set_locale("en")
	
