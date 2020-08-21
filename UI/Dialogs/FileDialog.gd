extends FileDialog

func initialize(parent, method):
	connect("file_selected", parent, method)

func _on_FileDialog_hide():
	queue_free()
