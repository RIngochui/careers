#!/bin/bash
# The runner must pass the control fixture and fail the broken ones.
cd "$(dirname "$0")"
ok=0
./run.sh res://tests/fixtures/pass >/dev/null 2>&1 || { echo "selftest: pass fixture failed"; ok=1; }
for d in fail crash syntax; do
	./run.sh res://tests/fixtures/$d >/dev/null 2>&1 && { echo "selftest: $d fixture wrongly passed"; ok=1; }
done
[ $ok -eq 0 ] && echo "selftest OK"
exit $ok
