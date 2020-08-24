extends Control

const save_path = "user://last_session.json"
const user_prefs = "user://user_prefs.json"

var prefs = {}

onready var csvMethod = $MarginContainer/HBoxContainer/LeftColumn/VBoxContainer/CsvMethod
onready var templateTabs = $MarginContainer/HBoxContainer/LeftColumn/SqlTemplatesTabs
onready var generatedTabs = $MarginContainer/HBoxContainer/OutputWindow
onready var separatorLineEdit = $MarginContainer/HBoxContainer/LeftColumn/VBoxContainer/OptionsContainer/VBoxContainer2/CsvSeparator/LineEdit
onready var outputLinesSpinBox = $MarginContainer/HBoxContainer/LeftColumn/VBoxContainer/OptionsContainer/VBoxContainer2/OutputLines/SpinBox
onready var optionIgnore = $MarginContainer/HBoxContainer/LeftColumn/VBoxContainer/OptionsContainer/VBoxContainer/IgnoreTitles
onready var optionDouble = $MarginContainer/HBoxContainer/LeftColumn/VBoxContainer/OptionsContainer/VBoxContainer/DoubleApostrophes


func _ready():
	load_from_files()

func _on_MainScreen_tree_exiting():
	save_prefs()
	save_last_session()

func save_prefs():
	prefs = {
			"double_apostrophes" : optionDouble.pressed, 
			"ignore_title" : optionIgnore.pressed, 
			"csv_separator" : separatorLineEdit.text,
			"csv_method" : csvMethod.current_tab,
			"output_lines" : outputLinesSpinBox.value
		}
	var save = File.new()
	save.open(user_prefs, File.WRITE)
	save.store_line(to_json(prefs))
	save.close()

func load_from_files():
	load_prefs()
	load_last_session()
	pass

func load_prefs():
	var file = File.new()
	if not file.file_exists(user_prefs):
		save_prefs()
		
	file.open(user_prefs, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	prefs = data
	file.close()
	
	optionDouble.pressed = prefs["double_apostrophes"]
	optionIgnore.pressed = prefs["ignore_title"]
	separatorLineEdit.text = prefs["csv_separator"]
	csvMethod.current_tab = prefs["csv_method"]
	outputLinesSpinBox.value = prefs["output_lines"]
		

func load_last_session():
	var file = File.new()
	if not file.file_exists(save_path):
		save_last_session()
		pass
	file.open(save_path, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	if data:
		if data.templates:
			for tab in data.templates:
				templateTabs.create_new_tab(tab[0], tab[1])
			templateTabs.set_current_tab(data.last_tab_used)
		if data.results:
			for tab in data.results:
				generatedTabs.create_new_tab(tab[0], tab[1])
			generatedTabs.set_current_tab(data.last_tab_result)
	file.close()
	
func save_last_session():
	var texts = templateTabs.get_all_texts()
	var results = generatedTabs.get_all_texts()
	var session = {"templates": texts, "last_tab_used" : templateTabs.current_tab(), 
	"results" : results, "last_tab_result" : generatedTabs.current_tab()}
	var save = File.new()
	save.open(save_path, File.WRITE)
	save.store_line(to_json(session))
	save.close()

func _on_LineEdit_text_changed(new_text):
	if new_text != "":
		csvMethod.separator = new_text
	else:
		separatorLineEdit.text = ","

func _on_CsvMethod_browse():
	var fileDialog = load("res://UI/Dialogs/FileDialog.tscn").instance()
	fileDialog.initialize(csvMethod, "_on_FileDialog_file_selected")
	add_child(fileDialog)
	fileDialog.show()

func _on_ProcessButton_pressed():
	var template = templateTabs.get_current_text()
	var csv_inputs = csvMethod.get_csv_in_use()
	if not template or not csv_inputs:
		return
	var output = ""
	
	#ignore titles
	if optionIgnore.pressed:
		csv_inputs.pop_front()
	
	for line in csv_inputs:
		var dict = {}
		for column in line.size():
			if optionDouble.pressed:
				dict[str(column)] = line[column].replace("'", "''")
			else:
				dict[str(column)] = line[column]
		output += template.format(dict)
		for i in outputLinesSpinBox.value:
			output += "\n"
	output.strip_edges(false, true)
	generatedTabs.create_new_tab(templateTabs.get_current_tab_name(), output)
