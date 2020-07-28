extends Control

export (PackedScene) var default_tab_container : PackedScene

onready var NameDialog = $ConfirmationDialog
onready var NameLineEdit = $ConfirmationDialog/HBoxContainer2/LineEdit
onready var TabsHeader = $TabsPlus/Header/Tabs
onready var container = $TabsPlus/Container
onready var nameNotEmptyDialog = $AcceptDialog

func _ready():
	NameDialog.register_text_enter(NameLineEdit)

func get_current_text():
	if container.get_child_count() > 0:
		return container.get_child(container.current_tab).text

func get_all_texts():
	var texts = []
	for i in container.get_child_count():
		texts.append([TabsHeader.get_tab_title(i), container.get_child(i).text])
	return texts

func get_current_tab_name():
	return TabsHeader.get_tab_title(TabsHeader.current_tab)
	
func current_tab():
	return container.current_tab

func set_current_tab(tab):
	TabsHeader.current_tab = tab

func set_text(tab, text):
	container.get_child(container.current_tab).text = text

func _on_AddButton_pressed():
	NameLineEdit.clear()
	NameLineEdit.text = "New SQL template"
	NameLineEdit.select_all()
	NameDialog.show()
	NameLineEdit.grab_focus()


func _on_Tabs_tab_changed(tab):
	container.current_tab = tab
	container.get_child(tab).grab_focus()


func _on_Tabs_tab_close(tab):
	TabsHeader.remove_tab(tab)
	container.remove_child(container.get_child(tab))
	container.current_tab = TabsHeader.current_tab


func _on_ConfirmationDialog_confirmed():
	if NameLineEdit.text != "":
		create_new_tab(NameLineEdit.text)
	else:
		nameNotEmptyDialog.show()

func create_new_tab(tab_name, text = ""):
	TabsHeader.add_tab(tab_name)
	container.add_child(build_container(text))
	TabsHeader.current_tab = TabsHeader.get_tab_count()-1
	container.get_child(container.current_tab).grab_focus()

func build_container(text = ""):
	if not default_tab_container:
		var TE = TextEdit.new()
		TE.text = text
		return TE
	else:
		return default_tab_container.instance()
