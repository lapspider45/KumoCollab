class_name DirUtils
extends Directory

enum {
	TYPE_INVALID,
	TYPE_FILE,
	TYPE_DIR,
}

func _init():
	include_navigational = false
	include_hidden = true

# returns an array enumerating the current directory
# each array index contains a dictionary with three keys:
# 	* name - the filename
# 	* type - 1 for file, 2 for dir, see the enum above
# 	* path - the absolute path to the file
func ls()->Array:
	var contents := []
	var path := get_current_dir()
	var err := list_dir_begin()
	if err:
		push_error("failed to begin dir listing of %s with code %d" % [path, err])
	while true:
		var filename:String = get_next()
		if filename == "":
			break
		var entry := {
			"name": filename,
			"type": TYPE_FILE,
			"path": path.plus_file(filename)
		}
		if current_is_dir():
			entry.type = TYPE_DIR
		contents.append(entry)
	
	list_dir_end() # just to be sure
	return contents

func entry_is_imported(entry:Dictionary):
	return entry.get("type") == TYPE_FILE and entry.get("name", "").ends_with(".import")
