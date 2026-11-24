extends Node3D

const CONFIG_PATH := "res://data/config.json"
const BG_COLOR := Color(0.18, 0.28, 0.4)


func _ready() -> void:
	var cfg = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	get_window().title = str(cfg["window_title"])
	add_child(Camera3D.new())
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = BG_COLOR
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	if "--shots" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		var path := ProjectSettings.globalize_path("res://review/shots/00_boot.png")
		get_viewport().get_texture().get_image().save_png(path)
		get_tree().quit()
