extends HBoxContainer

onready var languageSelecter = $Language/LanguageOption
onready var themeSelector = $Theme/ThemeOption
onready var fontSelector = $Font/FontOption

signal theme_changed(theme)
signal font_changed(font)

const user_options = "user://user_options.json"
const themes = ["res://UI/Themes/Solarized_dark_complete.tres", "res://UI/Themes/Solarized_light_complete.tres"]
const fonts = ["res://font/expressway.tres", "res://font/open_dislexia.tres"]
var prefs = {}

func _ready():
	load_prefs()

func _on_MenuAndOptions_tree_exiting():
	save_prefs()

func save_prefs():
	prefs = {
			"language" : languageSelecter.selected,
			"theme" : themeSelector.selected,
			"font" : fontSelector.selected
		}
	var save = File.new()
	save.open(user_options, File.WRITE)
	save.store_line(to_json(prefs))
	save.close()

func load_prefs():
	var file = File.new()
	if not file.file_exists(user_options):
		save_prefs()
		
	file.open(user_options, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	prefs = data
	file.close()
	
	if prefs.has("language"):
		languageSelecter.select(prefs["language"])
		_on_LanguageOption_item_selected(languageSelecter.selected)
	
	if prefs.has("font"):
		fontSelector.select(prefs["font"])
		_on_FontOption_item_selected(prefs["font"])
	
	if prefs.has("theme"):
		themeSelector.select(prefs["theme"])
	_on_ThemeOption_item_selected(themeSelector.selected)

func _on_ThemeOption_item_selected(index):
	emit_signal("theme_changed", load(themes[index]))

func _on_LanguageOption_item_selected(index):
	if index == 0:
		TranslationServer.set_locale("en")
	if index == 1:
		TranslationServer.set_locale("fr")

func _on_FontOption_item_selected(index):
	emit_signal("font_changed", load(fonts[index]))
