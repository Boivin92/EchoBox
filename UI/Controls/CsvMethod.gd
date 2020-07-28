extends TabContainer

onready var tree : Tree = $File/MarginContainer/VBoxContainer/Tree
var separator = ","

var file_content_as_array

signal browse

func _ready():
	pass

func get_csv_in_use():
	if current_tab == 0:
		return file_content_as_array
	if current_tab == 1:
		var lines = []
		for line in $Text/Textbox.get_line_count():
			lines.append($Text/Textbox.get_line(line).split(separator, true))
		return lines

func expose_csv(csv : Array):
	tree.clear()
	tree.columns = csv[0].size()
	var root = tree.create_item()
	tree.hide_root = true
	for line in csv:
		var new_line = tree.create_item(root)
		for column in line.size():
			new_line.set_text(column, line[column])


func _on_FileDialog_file_selected(path):
	expose_csv(get_lines_from_file(path))
	$File/MarginContainer/VBoxContainer/HBoxContainer/FileNameLabel.text = path

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
