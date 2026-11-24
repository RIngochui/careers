extends RefCounted
# Base class for tests: call check(), the runner reads failures.

var failures: Array[String] = []
var tree: SceneTree


func check(cond: bool, msg: String = "") -> void:
	if not cond:
		failures.append(msg)
