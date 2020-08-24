extends TabContainer

onready var file_path_label = $FILE_TAB_LABEL/MarginContainer/VBoxContainer/HBoxContainer/FileNameLabel
onready var tree : Tree = $FILE_TAB_LABEL/MarginContainer/VBoxContainer/Tree
onready var raw_text_input = $TEXT_TAB_LABEL/Textbox
var separator = ","

var file_content_as_array = []
const last_inputs = "user://last_inputs.json"

signal browse

func _ready():
	load_inputs()

func get_csv_in_use():
	if current_tab == 0:
		return file_content_as_array
	if current_tab == 1:
		var lines = []
		for line in raw_text_input.get_line_count():
			lines.append(raw_text_input.get_line(line).split(separator, true))
		return lines

func expose_csv(csv : Array):
	tree.clear()
	if csv:
		tree.columns = csv[0].size()
		var root = tree.create_item()
		tree.hide_root = true
		for line in csv:
			var new_line = tree.create_item(root)
			for column in line.size():
				new_line.set_text(column, line[column])


func _on_FileDialog_file_selected(path):
	expose_csv(get_lines_from_file(path))
	file_path_label.text = path

func get_lines_from_file(path):
	var file = File.new()
	var values := []
	file.open(path, file.READ)
	while !file.eof_reached():
		var line = file.get_csv_line(separator)
		for column in line:
			if column != "":
				values.append(line)
				break
	file.close()
	file_content_as_array = values
	return values

func _on_BrowseButton_pressed():
	emit_signal("browse")

func _on_CsvMethod_tree_exiting():
	save_inputs()

func current_file():
	return file_path_label.text

func save_inputs():
	var inputs = {
		"file" : {
			"selected_file" : file_path_label.text
			},
		"raw_text" : raw_text_input.text
	}
	var save = File.new()
	save.open(last_inputs, File.WRITE)
	save.store_line(to_json(inputs))
	save.close()

func load_inputs():
	var file = File.new()
	if not file.file_exists(last_inputs):
		save_inputs()
	file.open(last_inputs, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	if data:
		if data.file.selected_file && file.file_exists(data.file.selected_file):
			file_path_label.text = data.file.selected_file
			_on_FileDialog_file_selected(data.file.selected_file)
		if data.raw_text:
			raw_text_input.text = data.raw_text
	file.close()
