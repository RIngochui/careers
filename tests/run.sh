#!/bin/bash
# Usage: run.sh <res:// dir>. Fails on exit code, script errors, or missing ALL PASSED
# (a GDScript runtime error logs but doesn't change Godot's exit code).
set -o pipefail
cd "$(dirname "$0")/.."
out=$(${GODOT:-godot} --headless --path . -s res://tests/run_tests.gd -- --dir="${1:-res://tests}" 2>&1)
code=$?
echo "$out"
[ $code -eq 0 ] || exit 1
echo "$out" | grep -qE "SCRIPT ERROR|Parse Error" && exit 1
echo "$out" | grep -q "^ALL PASSED" || exit 1
