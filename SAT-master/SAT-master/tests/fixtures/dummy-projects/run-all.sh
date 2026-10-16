#!/usr/bin/env sh
# Run the validation script against every dummy project and compare the exit
# code with cases.tsv.
#
# Usage:  ./run-all.sh [-v] [name-filter]
#   VALIDATOR=/path/to/validate.sh   (default: the code-review-agent repo)
#   -v   also print each Project's Gate statuses
#
# cases.tsv columns (tab separated):  <dir to run in>  <expected exit>  <note>
# Expected exit "?" means "depends on which tools are installed"; it is shown, not asserted.
#
# Prerequisites for the JS/TS and Python cases to behave as listed: node/npm,
# and pytest + pytest-cov + ruff on PATH (the repo's .venv is added if present).
# The ts-* projects symlink node_modules to the repo's js-ts-passing fixture.
HERE=$(cd "$(dirname "$0")" && pwd)
VALIDATOR=${VALIDATOR:-$HOME/AI-projects/pwc/code-review-agent/validate.sh}
. "$HOME/toolchains/env.sh" 2>/dev/null
export MIX_HOME=$HOME/toolchains/mix HEX_HOME=$HOME/toolchains/hex
VENV_BIN=$(dirname "$VALIDATOR")/.venv/bin
[ -d "$VENV_BIN" ] && PATH="$VENV_BIN:$PATH"
export PATH NO_COLOR=1

VERBOSE=false
[ "$1" = "-v" ] && { VERBOSE=true; shift; }
FILTER=${1:-}

pass=0; fail=0; info=0
printf '%-44s %-5s %-5s %s\n' PROJECT EXIT WANT NOTE
while IFS="$(printf '\t')" read -r dir want note; do
  case "$dir" in ''|\#*) continue ;; esac
  [ -n "$FILTER" ] && case "$dir" in *"$FILTER"*) ;; *) continue ;; esac
  [ -d "$HERE/$dir" ] || { printf '%-44s missing directory\n' "$dir"; fail=$((fail+1)); continue; }
  rm -rf "$HERE/$dir/validation-report.json" "$HERE/$dir/validation-logs"
  got=0
  (cd "$HERE/$dir" && sh "$VALIDATOR" < /dev/null > "$HERE/.last-run.log" 2>&1) || got=$?
  if [ "$want" = "?" ]; then mark='  '; info=$((info+1))
  elif [ "$want" = "$got" ]; then mark='ok'; pass=$((pass+1))
  else mark='!!'; fail=$((fail+1)); fi
  printf '%-44.44s %-5s %-5s %s %s\n' "$dir" "$got" "$want" "$mark" "$note"
  rm -rf "$HERE/$dir/.build" "$HERE/$dir/build"   # swift/cmake build output
  if $VERBOSE; then
    grep -E '^│ ' "$HERE/.last-run.log" | grep -v 'Project ' | sed 's/^/      /'
  fi
done < "$HERE/cases.tsv"
rm -f "$HERE/.last-run.log"
printf '\n%d as expected, %d not as expected, %d informational\n' "$pass" "$fail" "$info"
[ "$fail" -eq 0 ]
