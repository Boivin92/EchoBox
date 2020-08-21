extends Panel

func _on_MenuAndOptions_font_changed(font):
	theme.set_default_font(font)

func _on_MenuAndOptions_theme_changed(theme):
	var tempFont = self.theme.get_default_font()
	self.theme = theme
	self.theme.set_default_font(tempFont)
