extends TabContainer

func create_new_tab(tab_name, text = ""):
	var tempTextEdit = TextEdit.new()
	tempTextEdit.name = tab_name
	tempTextEdit.text = text
	add_child(tempTextEdit)

func current_tab():
	return current_tab

func set_current_tab(index):
	current_tab = index

func get_all_texts():
	var texts = []
	for child in get_children():
		texts.append([child.name, child.text])
	return texts
