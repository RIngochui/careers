extends SceneTree


func _initialize() -> void:
	await process_frame # root must be in the tree so _ready fires on added nodes
	var dir := "res://tests"
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--dir="):
			dir = a.substr(6)
	var failed := 0
	var files := Array(DirAccess.get_files_at(dir)).filter(
		func(f): return f.begins_with("test_") and f.ends_with(".gd"))
	files.sort()
	if files.is_empty():
		print("FAIL no tests found in ", dir)
		failed += 1
	for f in files:
		var script = load(dir.path_join(f))
		if script == null or not script.can_instantiate():
			print("FAIL ", f, " (does not load)")
			failed += 1
			continue
		var t = script.new()
		t.tree = self
		for m in t.get_method_list():
			if not m.name.begins_with("test_"):
				continue
			t.failures.clear()
			t.call(m.name)
			if t.failures.is_empty():
				print("PASS ", f, ":", m.name)
			else:
				failed += 1
				print("FAIL ", f, ":", m.name, " ", t.failures)
	print("ALL PASSED" if failed == 0 else "%d FAILED" % failed)
	quit(0 if failed == 0 else 1)
