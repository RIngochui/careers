extends "res://tests/assert.gd"


func _cfg() -> Dictionary:
	return JSON.parse_string(FileAccess.get_file_as_string("res://data/config.json"))


func test_config_title() -> void:
	var t = _cfg().get("window_title")
	check(t is String and t != "", "window_title missing")


func test_main_sets_title() -> void:
	var m = load("res://src/presentation/main.tscn").instantiate()
	tree.root.add_child(m)
	check(tree.root.title == _cfg()["window_title"], "title not from config")
	m.queue_free()
