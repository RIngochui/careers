extends Node3D

const CONFIG_PATH := "res://data/config.json"


func _ready() -> void:
	var cfg = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	get_window().title = str(cfg["window_title"])
	add_child(Camera3D.new())
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(cfg["background_color"][0], cfg["background_color"][1], cfg["background_color"][2])
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	if "--shots" in OS.get_cmdline_user_args():
		await RenderingServer.frame_post_draw
		var path := ProjectSettings.globalize_path("res://review/shots/00_boot.png")
		get_viewport().get_texture().get_image().save_png(path)
		get_tree().quit()
