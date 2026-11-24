GODOT ?= godot

.PHONY: run import test sim shots movie art export templates lsp lsp-stop

run: ; $(GODOT) --path .
import: ; $(GODOT) --headless --path . --import
test:
	@[ -d .godot ] || $(MAKE) import
	tests/run.sh res://tests
	tests/selftest.sh
shots:
	@[ -d .godot ] || $(MAKE) import
	mkdir -p review/shots
	$(GODOT) --path . -- --shots
movie:
	@[ -d .godot ] || $(MAKE) import
	mkdir -p review
	$(GODOT) --path . --write-movie review/demo.avi --fixed-fps 30 --quit-after 90
sim: ; @echo "sim: arrives in Phase 2"; exit 2
art: ; @echo "art: arrives in Phase 5"; exit 2
export: ; @echo "export: arrives in Phase 7"; exit 2
templates: ; @echo "templates: arrives in Phase 7"; exit 2
lsp:
	@mkdir -p .godot
	@$(GODOT) --headless --editor --path . --lsp-port 6005 >/dev/null 2>&1 & echo $$! > .godot/lsp.pid
lsp-stop:
	@[ -f .godot/lsp.pid ] && kill `cat .godot/lsp.pid`; rm -f .godot/lsp.pid
