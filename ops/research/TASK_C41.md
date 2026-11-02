# TASK C41 — CODEX — THE KIT NOBODY CALLS

Model: top tier, effort **high**, Fast off. One session.

**Research only. You write ONE new file and change nothing else.** No `.gd`
edit, no `HANDOFF.md` edit, no screen touched. The whole point is to turn
invisible debt into a queue Claude can assign from.

## Why this exists

`Godot/scripts/UIKit.gd` is 7,350 lines and defines **161 public factories**.
**35 of them have zero callers** anywhere in `Godot/scripts/` or
`Godot/tests/` outside `UIKit.gd` itself.

That is the same debt the read backlog was — built, sometimes tested, never
spent — except the read backlog was seven items and this is thirty-five. R57,
R58, U5, U6 and U8 all exist because somebody wrote down which reads had no
callers. Nobody has ever written this list down.

Reproduce the count yourself before you trust mine:

```
cd Godot && grep -o "^static func [a-z_]*" scripts/UIKit.gd | sed 's/static func //' | sort -u | grep -v "^_" > /tmp/pub.txt
while read f; do c=$(grep -rl "UIKit\.$f(" scripts/ tests/ --include=*.gd | grep -v "scripts/UIKit.gd" | wc -l); [ "$c" -eq 0 ] && echo "$f"; done < /tmp/pub.txt
```

The 35 as of 2026-09-08:

`action_card, action_flag, alerts_column, belt_holder_row, boot_body_rect,
boot_seam, combo_alert_, command_list, creation_body_rect, creation_seam,
day_cell, desk_ledger, division_switcher, fighter_slab, focus_chip,
gate_estimate_pair, gradient_texture, ledger_row, light_overlay, moment_row,
obligation_color, obligation_text, obligation_word, occupancy_chip,
phase_clock, phase_shutter, record_cell, result_card, scorecard_row,
setpiece_body_rect, shortlist_pin, stakes_tag, station_tile, tree_node,
way_out_strip`

Note `combo_alert_` — the trailing underscore is suspicious and is itself a
finding. Report what it actually is; do not "fix" it.

## Owned files

- **`research/C41_UIKIT_DEAD_FACTORY_AUDIT.md`** — you create it. It is
  the only file you write.
- `Godot/scripts/UIKit.gd` — **7,350 lines, NEVER open it whole.** Work by
  `grep -n "static func <name>"` to find each factory, then read only the
  `sed -n 'A,Bp'` window of that function. Thirty-five small windows, not one
  big read.

Nobody else is in `UIKit.gd` this cycle, and you are not editing it anyway.

## The work

One row per factory, in a table or a short block each. For every one:

1. **Name and line** — `factory_name` at `UIKit.gd:NNNN`.
2. **What it renders**, in one sentence, from its own code and docstring.
3. **Tested?** — does any file in `Godot/tests/` construct it? Name the test.
4. **Bucket** — exactly one of:
   - **SPEND** — a real screen visibly wants this and does not have it. Name
     the screen and the function in it that would call it. This is the bucket
     that becomes a task, so be specific or pick another bucket.
   - **SUPERSEDED** — a newer factory does the same job. Name it.
   - **PRIMITIVE** — it exists to be composed by other UIKit factories, and
     the zero-caller count is an artifact of my grep only looking outside
     `UIKit.gd`. Say which factory composes it.
   - **UNKNOWN** — you genuinely cannot tell. This is a legitimate answer and
     an honest UNKNOWN beats an invented recommendation.
5. **One line of evidence** for the bucket. A claim with no `file:line` behind
   it is not evidence.

Close with a **Priority ruling**: the five SPEND rows you would assign first,
in order, with one sentence each on what the player would gain. Claude turns
those into task files.

## Refusals

- **Do not edit `UIKit.gd`.** Not a rename, not a deletion, not the
  `combo_alert_` underscore. This audit decides nothing; it informs.
- **Do not edit any screen** to "prove" a factory can be spent.
- **Do not edit `HANDOFF.md`.** Claude writes your block.
- **Do not delete anything.** A dead factory is Claude's call and the
  operator's, and several of these are probably deliberate primitives.
- **No new UIKit factory**, obviously, and no refactor proposals — the
  question is "who should call this", never "how should this be rewritten".
- Do not open `GameState.gd` at all. Nothing here needs it.

## Gate

You change no `.gd`, so there is no parse gate and no test run. The gate is
that the repository is untouched apart from your one new file:

```
git status -s
```

Must show exactly one untracked file, `research/C41_UIKIT_DEAD_FACTORY_AUDIT.md`,
plus whatever other agents already had in flight — which is not yours to
commit. If it shows a modified `.gd`, you have broken the task.

## When you are done

```
git add -- research/C41_UIKIT_DEAD_FACTORY_AUDIT.md
git commit
git push origin master
python Tools/agent_comms.py send --from codex --to claude --topic "C41 done" --body "<counts per bucket, one line>"
```

Never a bare `git stash`, `reset --hard`, `checkout .` or `clean` — this
checkout is shared with Cursor and a stash wiped an entire finished stage on
2026-09-07.

## The one trap

The grep that produced the 35 deliberately excludes `UIKit.gd` itself, so a
factory composed only by other factories looks dead and is not. That is what
the **PRIMITIVE** bucket is for, and getting it wrong in the confident
direction is the expensive mistake here: a SPEND recommendation on something
that is already called internally sends a future agent to build a screen block
around a helper that was never meant to be public. Check
`grep -n "\b<name>(" Godot/scripts/UIKit.gd` before you call anything dead.
