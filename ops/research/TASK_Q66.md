# TASK Q66 — QWEN — THE KICKBOXER WHO STOPPED KICKING

**Model:** qwen3-coder, medium effort, `--yolo`. Fixed at assignment; do not self-escalate.

**Test tier:** a Python script and a JSON file change, plus ONE headless Godot
measurement run. **Do NOT run the full suite** — you touch no `.gd` under
`scripts/` and no shipped data file. The gate is the measurement itself.

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest. Do not explore to get
oriented.

---

## THE SITUATION

Four new technique trees are validated and on disk but NOT merged into the live
catalogue. R129 measured the merge in a shadow copy and found it good in almost
every column — except one clear regression, which blocks the merge:

**Kickboxing's LEG share collapses from 14.3% to 4.4% of landed strikes.** The
real-fight anchor (J20, D3) is **14–18% leg**. So the merge would take the one
ruleset that was already correct on legs and break it.

**The cause is structural.** `FightMoves` gives a fighter with no
`technique_progress` record — which is every fighter in every seeded bout and
every generated opponent — his disciplines' **tier 1 and tier 2** nodes only.
Kickboxing draws on `["kickboxing", "boxing"]`. R128 added **36 boxing nodes
against 7 kickboxing ones**, so kickboxing's tier 1+2 palette went 20 → 41 and
most of the 21 newcomers are punches. The hands drowned the kicks.

## R129's PROPOSED FIX IS A NO-OP, AND YOU MUST NOT JUST APPLY IT

R129 says to "promote the low kick, the teep and the shin check into tier 1–2".
**Check that claim before you act on it.** In
`Godot/tools/build_boxing_kickboxing_nodes.py`:

- `kickboxing_teep` is **already tier 1** (~line 286)
- `kickboxing_low_kick` is **already tier 2** (~line 292)
- `kickboxing_kick_check` (Shin Check) is **already tier 2** (~line 301)

All three are already in the palette. Promoting them changes nothing. **If you
apply R129's literal instruction and report the leg share unchanged, that is a
correct finding and you should say so — but do not stop there.** Find the lever
that actually moves the number.

## WHAT YOU ACTUALLY HAVE TO DO

**Find and apply the smallest spec-table change that brings kickboxing's leg
share into 14–18% without wrecking its head share (currently a good 63.6%
against a 61–65% anchor) or any other ruleset's numbers.**

The levers available to you, in the order we think they are worth trying — but
**measure, do not assume**:

1. **Promote more kickboxing kicks into tier 1–2.** `kickboxing_body_kick` is
   tier 2 already; `kickboxing_high_kick`, `kickboxing_switch_kick` and
   `kickboxing_question_mark` are tier 3. A body roundhouse and a switch kick
   are taught early in every kickboxing gym; a question-mark kick is not.
2. **Demote some boxing tier-2 hand work to tier 3** in the boxing spec table.
   This is the riskier lever: **boxing's own numbers must not regress**, and
   boxing draws only on itself, so every demotion costs boxing palette too.
   Measure boxing before and after any demotion you make.
3. Anything else you find in the spec tables that is genuinely mis-tiered
   against how the sport is actually taught.

**Do not change `RULESET_DISCIPLINES`, do not change `FightMoves.gd`, and do not
touch the live catalogue.** The tier numbers in the two spec tables are the only
thing you are authorised to edit.

## THE LOOP YOU RUN

```bash
python Godot/tools/build_boxing_kickboxing_nodes.py
python Godot/tools/validate_technique_nodes.py research/R128_boxing_kickboxing_nodes.json
python Godot/tools/shadow_merge_catalogue.py
```

then, **with no other Godot running on this machine**:

```
%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_catalogue_impact.gd
```

That run takes a few minutes. It prints the live-vs-shadow table for all four
rulesets against J20's anchors. **The row you are moving is kickboxing's leg
percentage; the rows you must not break are everything else.**

## OWNED FILES

- `Godot/tools/build_boxing_kickboxing_nodes.py` — the two spec tables. Boxing
  starts around line 60; kickboxing's table starts at `kickboxing_guard`,
  ~line 280. Each row is `(id, name, TIER, branch, role, effects, range_bands,
  range_delta, prereqs, attr_reqs, rules)`. **The tier is the third field.**
- `research/R128_boxing_kickboxing_nodes.json` — regenerated output, commit it.
- `research/Q66_KICKBOXING_TIER_FIX.md` — your write-up. New file.

You may READ `Godot/tools/shadow_merge_catalogue.py` and
`Godot/tools/measure_catalogue_impact.gd` to understand the gate. Do not edit them.

## THE GATE — A CEILING, NOT AN EXACT TARGET

- Kickboxing leg share in the shadow measure: **≥ 12.0%**. Landing inside 14–18%
  is the goal; **if you beat it, say so and push.** If you cannot reach 12.0%
  without breaking another row, push your best attempt and **state plainly what
  you could not reach and why** — a measured failure is a real deliverable here.
- Kickboxing head share must stay in **58–68%**.
- Boxing, muay thai and MMA rows must not move more than **2 percentage points**
  from what R129 recorded for the shadow, in any of D3's three target columns.
- `validate_technique_nodes.py` must print OK.

## WHAT TO WRITE UP

`research/Q66_KICKBOXING_TIER_FIX.md`, short:
- the before/after table for **all four rulesets**, not just kickboxing
- exactly which rows you re-tiered and the one-sentence sport reason for each
- whether R129's literal three-node fix moved the number (we expect: no)
- anything you could not reach, stated plainly

## THE TRAP SPECIFIC TO THIS TASK

**The tier field is the third element of an unlabelled tuple.** Every row is a
bare Python tuple with eleven positional fields and no keywords. Miscount by one
and you will silently edit the `branch` or the `name`. Before you change a row,
print it and check that field 3 is the integer you expect. The builder has a
validation pass at the end — read what it prints, do not just check the exit code.

## WHEN YOU ARE DONE

```bash
git add -- Godot/tools/build_boxing_kickboxing_nodes.py research/R128_boxing_kickboxing_nodes.json research/Q66_KICKBOXING_TIER_FIX.md
git commit
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q66-done --body "kb_leg_before=4.4 kb_leg_after=<N> kb_head=<N> rows_retiered=<N> other_rulesets_max_move=<N>pp"
```

Check `git status -s` before you stage — another agent's work-in-progress may be
pre-staged in this shared checkout. Stage explicit paths only. Do **NOT** edit
`HANDOFF.md`.
