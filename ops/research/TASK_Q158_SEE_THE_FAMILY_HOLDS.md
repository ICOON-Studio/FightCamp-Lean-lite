# TASK_Q158 - SEE what Q157 bound, then do the same for the 186 striking NONE (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S62, 2026-09-24, straight after Q157.

## Why
Q157 mapped all 190 grappling NONE techniques to the 21 owned holds and reported ZERO unmapped.
Nobody has LOOKED at what that means on screen: the rule this project paid for is that coverage
by name is not coverage ("boxing_double_jab was a SINGLE jab ... not one clip was opened"). And
186 techniques are still NONE, all in the striking branches, where we own many more clips than
the grappling side does. Two parts, one branch `qwen/q158-see-the-family`.

## Part 0 - the muay thai naming contract moved
`Godot/tests/grapple_naming_contract_test.gd` (yours, Q152/Q153) reads muay_thai at 71.4% (75/105)
on master after S62's separation floor (it was 85.8% at Q153); every other ruleset passes. Re-run
it, print WHICH grapple events are unnamed now, and restore >= 85% the way Q152 did - catalogue
entries and vocabulary aliases - never by lowering the clause. If the residue is a genuine
catalogue gap (no muay_thai ground technique exists), say so with the count and add the technique
rows the catalogue needs (Mat Lumpee family) rather than an alias that lies.

## Part 1 - the contact sheets (grappling FAMILY)
1. `Godot/tools/audit_clip_contact_sheets.gd` exists and renders a clip to a PNG sheet (read its
   header for the args; it is a WINDOWED tool - launch it through
   `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/audit_clip_contact_sheets.gd -- <args>`,
   never a bare windowed run). Render ONE sheet per owned hold (21) into
   `previews/family_holds/<pair_key>.png`, both halves side by side if the tool can,
   else the attacker half.
2. For each of the 21 holds, list in the digest the techniques Q157 mapped to it (count and the
   first ten ids) UNDER its sheet, so the operator can look at the picture and read what it now
   stands for. Flag in a third column every mapping where the hold's SEAT contradicts the
   technique's name (a "standing" technique mapped to a ground hold, a bottom-man technique mapped
   to a top-man hold). That list is the finding; Q157's "unmapped 0" is the claim it tests.
3. Cross-check the seat of each mapping against `research/G82_GRAPPLING_POSITION_TAXONOMY.md`
   IF it exists when you reach this step (Grok is writing it): every contradiction G82 names
   against a Q157 mapping goes in the digest as a row, and the mapping is REMOVED from
   `PAIRED_FAMILY_BINDINGS` (a wrong picture is worse than no picture).

## Part 2 - the striking FAMILY class
The 186 NONE are striking techniques (boxing/kickboxing/muay thai/karate/TKD/MMA striking). We own
the RamsterZ H2H packs, the sliced jab/cross/hook clips, the receiver ladder and the Cascadeur
audition clips (`Godot/scripts/FightClipBinding.gd` BINDINGS, lines 25-1750 - grep, never read
whole). Build `STRIKE_FAMILY_BINDINGS` the same way Q157 built the paired one: technique id ->
existing BINDINGS key + a one-word reason (the limb and the line: `rear_straight`, `lead_hook`,
`rear_round_kick`, `lead_teep`, `rear_elbow`, `knee` ...). Wire it as the LAST fall-through in the
same seam Q157 used, add the class to `q133_clip_coverage.gd` under the same FAMILY line (split the
count: `FAMILY grappling=190 striking=N`). A spinning technique never maps to a non-spinning clip;
a kick never maps to a punch; a technique with no family clip stays NONE and is listed with its
limb and line - that residue is the striking authoring order.

## Owned files
`Godot/scripts/FightClipBinding.gd` (windows only), the ONE seam in `Godot/scripts/FightBeatAdapter.gd`
Q157 used, `Godot/tools/q133_clip_coverage.gd`, `previews/family_holds/*.png` (new),
`research/Q158_DIGEST.md` (new). Nothing else.

## Gate
Tier: scripts edited. Parse gate on every .gd touched, then
`python Godot/tools/run_tests.py --only fight_hold_binding,paired_clip_mount,fight_clip_alias,fight_beat,grapple_adapter,fight_clinch_binding,fight_clip_audit`.
Run the coverage tool before and after Part 2 and paste both. No full suite. One `send` per part.
Do NOT edit HANDOFF.md. Fresh worktree: `git fetch origin && git checkout -B qwen/q158-see-the-family origin/master`
first; if a test dies on a "TitleHonours" parse error the worktree lacks Godot's class cache - run
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` once and retry.
