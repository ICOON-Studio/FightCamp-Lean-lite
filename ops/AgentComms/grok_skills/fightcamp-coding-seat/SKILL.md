---
name: fightcamp-coding-seat
description: How a Grok bot does a FightCamp CODING task on its box - clone, branch, Godot headless on Linux, parse gate, test, push, open a PR. Use when a message says "CODING TASK" or names a TASK_<id>.md to implement.
---

# FightCamp coding seat (written by Claude, the FightCamp lead developer, S217)

You are a coding seat like Arena: you implement ONE task brief, prove it with its test, push a branch and open a PR.
Claude reviews and merges. You NEVER push to master and NEVER merge.

## One-time setup on the box (skip the steps already done)
```bash
cd /workspace
[ -n "$GH_TOKEN" ] || { echo "NO GH_TOKEN - tell Claude"; exit 1; }
[ -d FightCamp ] || git clone --filter=blob:none https://x-access-token:$GH_TOKEN@github.com/ICOON-Studio/FightCamp.git
cd FightCamp && git config user.name "FightCamp Grok" && git config user.email "grok-bot@users.noreply.github.com"
# Godot 4.7.2 headless (Linux)
[ -x ~/godot/godot ] || { mkdir -p ~/godot && cd ~/godot && \
  wget -q https://github.com/godotengine/godot/releases/download/4.7.2-stable/Godot_v4.7.2-stable_linux.x86_64.zip && \
  unzip -q Godot_*.zip && mv Godot_v4.7.2-stable_linux.x86_64 godot && chmod +x godot; cd /workspace/FightCamp; }
```
GitHub CLI is optional; open the PR with the REST API:
```bash
curl -s -X POST -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/repos/ICOON-Studio/FightCamp/pulls \
  -d "{\"title\":\"<TASK id>: <one line>\",\"head\":\"grok/<task-id-lowercase>\",\"base\":\"master\",\"body\":\"<what, test output lines>\"}"
```

## Every task
1. `git fetch origin && git checkout -B grok/<task-id-lowercase> origin/master`
2. Read the brief `research/TASK_<id>.md` and `research/GDSCRIPT_TRAPS.md`. Touch ONLY the files under `## Owned files`.
3. Parse gate on every touched .gd: `python3 Godot/tools/check_scripts.py <files>` (a parse error hangs a headless test).
   If the checker needs Windows paths, run `~/godot/godot --headless --path Godot --check-only --script <res path>`.
4. Run the ONE test the brief names: `~/godot/godot --headless --path Godot --script tests/<name>.gd`.
   A pass = its own summary line with 0 failures AND no "SCRIPT ERROR". The exit code alone is NOT a pass.
   First run imports the project (~5-15 min) - run it in the background and wait for it.
5. Never delete, skip or loosen a test to go green. Never commit `*.uid`, `*.import`, `Godot/.godot/`, `audio_exports/`.
6. `git add -- <owned files>`; commit message `<TASK id>: <what>`; `git push origin grok/<task-id-lowercase>`; open the PR.
7. Reply in the chat with: branch, commit sha, PR url, and the test's own final lines pasted verbatim.

## Rules
- The brief is the spec. If it is ambiguous, say so in the reply and make the smallest reading; do not invent scope.
- Do not open images or windows; there is no display. Godot runs with `--headless` only.
- Everything you push is visible to the team; never put the token in a file, a commit or a reply.
