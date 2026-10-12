#!/usr/bin/env bash
# Tests of .claude/hooks/guard.sh (PreToolUse guard). Usage: bash scripts/tests/guard.tests.sh
# Builds a throwaway fixture project, pipes hook inputs into the guard and checks exit codes
# (2 = blocked, 0 = allowed). Exit code of this script = number of failed cases.

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
guard="$repo/.claude/hooks/guard.sh"
fixture=$(mktemp -d)
mkdir -p "$fixture/.claude/hooks"
cp "$repo/.claude/hooks/role-boundaries.conf" "$fixture/.claude/hooks/"
printf '# exclusions\n/dist/\n*.secret\n' > "$fixture/.copilotignore"
export CLAUDE_PROJECT_DIR="$fixture"

pass=0; fail=0

json_escape() { local s=${1//\\/\\\\}; printf '%s' "${s//\"/\\\"}"; }

run() {
    # run <expected-exit> <label> <json>
    local expected=$1 label=$2 json=$3 got
    printf '%s' "$json" | bash "$guard" 2>/dev/null
    got=$?
    if [[ $got == "$expected" ]]; then pass=$((pass + 1)); printf '  ok   %s\n' "$label"
    else fail=$((fail + 1)); printf '  FAIL %s (expected %s, got %s)\n' "$label" "$expected" "$got"; fi
}

shell() { # shell <expected> <command> [tool]
    local tool=${3:-Bash}
    run "$1" "$tool: $2" "{\"tool_name\":\"$tool\",\"cwd\":\"$(json_escape "$fixture")\",\"tool_input\":{\"command\":\"$(json_escape "$2")\",\"description\":\"test\"}}"
}

file() { # file <expected> <relative-path> [agent] [tool]
    local tool=${4:-Edit} agent_json=
    [[ -n $3 ]] && agent_json=",\"agent_type\":\"$3\""
    run "$1" "$tool ${3:-main}: $2" "{\"tool_name\":\"$tool\",\"cwd\":\"$(json_escape "$fixture")\"$agent_json,\"tool_input\":{\"file_path\":\"$(json_escape "$fixture/$2")\",\"old_string\":\"a\",\"new_string\":\"b\"}}"
}

echo "== destructive commands (must block)"
shell 2 'rm -rf build'
shell 2 'sh -c "rm -rf build"'
shell 2 '/bin/rm notes.txt'
shell 2 'find . -name "*.tmp" | xargs rm'
shell 2 'cd src && rmdir old'
shell 2 'Remove-Item -Recurse -Force build' PowerShell
shell 2 'remove-item build' PowerShell
shell 2 'git clean -fd'
shell 2 'git -C . reset --hard HEAD~1'
shell 2 'git push --force origin main'
shell 2 'git push -f'
shell 2 'git push origin +main'
shell 2 'git push origin :old-branch'
shell 2 'git branch -D feature'
shell 2 'git stash drop'
shell 2 'git checkout -- src/app.ts'
shell 2 'git restore src/app.ts'
shell 2 'psql -c "DROP TABLE users"'
shell 2 'mysql -e "truncate table logs"'
shell 2 'sqlite3 db "DELETE FROM users"'
shell 2 'cat dist/app.js'
shell 2 'type .\dist\app.js' PowerShell

echo "== safe commands (must pass)"
shell 0 'npm run format'
shell 0 'git status && git diff --stat'
shell 0 'git rm obsolete.md'
shell 0 'git branch -d merged-feature'
shell 0 'git restore --staged src/app.ts'
shell 0 'git push origin main'
shell 0 'docker run --rm node:20 node -v'
shell 0 'sqlite3 db "DELETE FROM users WHERE id = 1"'
shell 0 'echo perform the task'
shell 0 'Get-ChildItem -Recurse src' PowerShell

echo "== .copilotignore (writes)"
file 2 'dist/app.js'
file 2 'config/prod.secret'
file 0 'src/dist-utils.ts'

echo "== role boundaries"
file 0 'src/app.ts' DEVon
file 2 'src/app.test.ts' DEVon
file 2 'src/__tests__/app.ts' DEVon
file 2 'docs/ARCHITECTURE.md' DEVon
file 2 'README.md' DEVon Write
file 2 'src/app.ts' QALvin
file 0 'src/app.test.ts' QALvin
file 0 'tests/fixtures/data.json' QALvin Write
file 0 '.claude/plans/005_reports/PHASE_1_COMPLETION_REPORT.md' QALvin Write
file 2 'src/app.ts' DOCly
file 0 'README.md' DOCly
file 0 'docs/adr/004-choix.md' DOCly Write
file 0 '.claude/plans/README.md' MAINa
file 0 'docs/adr/004-choix.md' MAINa
file 2 'src/app.ts' MAINa Write
file 0 'src/app.ts'
run 0 "Write QALvin: outside project" "{\"tool_name\":\"Write\",\"cwd\":\"$(json_escape "$fixture")\",\"agent_type\":\"QALvin\",\"tool_input\":{\"file_path\":\"/elsewhere/scratch/notes.md\",\"content\":\"x\"}}"

if command -v cygpath >/dev/null 2>&1; then
    echo "== Windows-style paths"
    win=$(cygpath -w "$fixture")
    export CLAUDE_PROJECT_DIR="$win"
    run 2 "Edit DEVon: windows path test file" "{\"tool_name\":\"Edit\",\"cwd\":\"$(json_escape "$win")\",\"agent_type\":\"DEVon\",\"tool_input\":{\"file_path\":\"$(json_escape "$win\\src\\app.test.ts")\"}}"
    run 0 "Edit DEVon: windows path source file" "{\"tool_name\":\"Edit\",\"cwd\":\"$(json_escape "$win")\",\"agent_type\":\"DEVon\",\"tool_input\":{\"file_path\":\"$(json_escape "$win\\src\\app.ts")\"}}"
    run 2 "Edit main: windows path ignored file" "{\"tool_name\":\"Edit\",\"cwd\":\"$(json_escape "$win")\",\"tool_input\":{\"file_path\":\"$(json_escape "$win\\dist\\app.js")\"}}"
fi

rm -r "$fixture"
echo "== $pass passed, $fail failed"
exit "$fail"
