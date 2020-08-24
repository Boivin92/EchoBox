extends TabContainer

func _ready():
	var popupScene : PackedScene = load("res://UI/Dialogs/PopupMenu.tscn")
	var popup : PopupMenu = popupScene.instance()
	add_child(popup)
	set_popup(popup)
	popup.connect("index_pressed", self, "_on_popup_action_pressed")

func _on_popup_action_pressed(id):
	if id == 0:
		free_tab(get_current_tab_control())

func create_new_tab(tab_name, text = ""):
	var tempTextEdit = TextEdit.new()
	tempTextEdit.name = tab_name
	tempTextEdit.text = text
	add_child(tempTextEdit)
	current_tab = get_child_count()-2 #-1 pour le nombre de tabs, -1 à cause du menu

func current_tab():
	return current_tab

func free_tab(tab):
	for i in get_child_count():
		if get_tab_control(i) == tab:
			remove_child(get_child(i))

func set_current_tab(index):
	current_tab = index

func get_all_texts():
	var texts = []
	for child in get_children():
		if child is TextEdit:
			texts.append([child.name, child.text])
	return texts


func _on_CopyButton_pressed():
	if get_child(current_tab):
		OS.set_clipboard(get_child(current_tab).text)

#func _input(event):
#	if event.is_action_pressed("ui_close_tab"):
#		remove_child(get_child(current_tab))
