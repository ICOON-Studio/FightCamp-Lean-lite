# TASK Q77 - QWEN - WHERE EVERY OTHER STANDING STRIKE LANDS

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Not the parse gate, not a
test. **Do NOT start Godot, for any reason**: Claude is running S2's test subsets in this
same checkout and only one Godot may run here at a time. Your gate is a Python script
that MUST exit 0.

## Owned files

- `research/Q77_strike_targets.json` - **NEW, yours alone.**
- `research/Q77_STRIKE_TARGETS.md` - **NEW, yours alone.**

Nothing else. Do NOT edit `technique_catalog.json`, any script, any test, `Q77_check.py`,
`Q70_kick_targets.json`, `HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

Your Q70 adjudicated where every KICK lands; S2 now applies it, one discipline per commit,
as an explicit per-technique target. Q70's census judged **326** standing-strike
candidates and ruled **200 of them not a kick** - elbows, knees, punches, combinations,
and many things that are not strikes at all (footwork, reads, sweeps, catches). S2 will
apply a discipline's targets in ONE commit, so muay thai's commit needs its knees and
elbows adjudicated as well as its kicks. That is this task, done before S2 reaches them.

Q70's review found two of its own census errors: **`karate_kizami_maegeri` and
`taekwondo_back_kick_counter` ARE kicks.** Both are among these 200 - adjudicate them here
as kicks, with a target, and name both in the report.

## Where things are (read only these)

- The 200 candidates: every `census` entry with `"is_kick": false` in
  `research/Q70_kick_targets.json`.
- Each node in `Godot/assets/data/technique_catalog.json` (nodes live under
  `disciplines[].nodes[]`; the discipline id is the parent's `id`): its `kind`
  (`move` / `sequence` / `skill`), `name`, `description` if present, and `match.role`,
  `match.effects`, `match.phases`. Read nodes with Python, never open the file whole
  (670 KB).
- What the locational keys mean today: `Godot/scripts/FightMoves.gd` - `sed -n '611,690p'`
  (`_regions_for`: `head_damage` says head; `body_damage`, `clinch_damage` and
  `ground_damage` say body; `leg_damage` and `lowline_damage` say legs). That file is
  1,138 lines - never open it whole.

## Scope

**1. One row per candidate, all 200.** For each:

- `id`, `discipline`, `kind`, `role`, `effects` - copied from the catalogue AS AUTHORED.
- `is_strike` - does this technique deliver a blow? A footwork pattern, a distance read,
  a sweep, a catch, a dump or a throw is **not** a strike even when its role is `counter`
  or its effects carry `damage`. A counter that hits is a strike. A catch that returns a
  strike (`muay_thai_catch_strike`) is a strike - say which blow in the reason.
- `strike_kind` - `punch`, `elbow`, `knee`, `kick`, `headbutt`, `mixed` (a chain of more
  than one kind), or `none` for a non-strike.
- `target` - where the blow lands in the sport the technique comes from: `head`, `body`,
  `leg`, or `spread` (it genuinely goes to more than one: a jab goes head and body).
  `null` for a non-strike.
- `confidence` - `high` / `medium` / `low`. **Low confidence is a legitimate answer -
  write it rather than guessing high.**
- `reason` - one line naming the technique as its sport defines it.

**2. SEQUENCES.** A `kind: sequence` node is a chain. Judge its target by the blow that
FINISHES the chain, unless the chain is built to attack one target throughout (a liver
combination is body). Say in a report section titled **SEQUENCES** which rule you applied
to each sequence that strikes.

**3. DISAGREES WITH ITS KEY.** Where a strike's node already carries a locational key and
your target differs (for example `clinch_damage` says body, and dirty boxing in the clinch
is punches to the head), list it in a report section titled **DISAGREES WITH ITS KEY**:
id, the key, what the key says, your target, why. Either the key or your reading is wrong,
and S2 must see which before it applies anything. **Do not bend a target to agree with a
key.**

**4. The report** `Q77_STRIKE_TARGETS.md`: its first line states the commit hash of the
catalogue you read (`git rev-parse --short HEAD`); your strike criterion in two sentences;
a per-discipline table (strikes, non-strikes, head, body, leg, spread); the two sections
above; the two Q70 census corrections.

## The JSON

    {"catalogue_commit": "<hash>",
     "rows": [{"id": "muay_thai_up_elbow", "discipline": "muay_thai", "kind": "move",
               "role": "damage", "effects": {"cut_threat": 8, "damage": 7},
               "is_strike": true, "strike_kind": "elbow", "target": "head",
               "confidence": "high", "reason": "an upward elbow through the chin"}],
     "summary": {"strikes": 0, "not_strikes": 0, "head": 0, "body": 0, "leg": 0, "spread": 0}}

Rows sorted by discipline, then id. **The field names and values are a CONTRACT** - S2's
apply tool reads this file. (`effects` above is illustrative - copy the real ones.)

## THE TRAP

**Never classify from the id or from effect-key substrings.** `mma_clinch_knee_trip` has
`knee` in its id and is a trip; `boxing_catch_counter` has `catch` in its id and is a
punch; `clinch_damage` says body and the technique may be punches to the head. R137 calls
the substring matcher a workaround for missing data, and S2 exists to replace it. Read
what each technique IS.

## The gate

    python research/Q77_check.py

It checks coverage of all 200, the catalogue columns, the enums, a few anchors no reading
of the sport disputes, the summary counts, and that every key disagreement is named. It
fails now because your files do not exist. **Fix YOUR FILES, never the checker.**

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never** run
  `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`, `git clean`,
  `git add -A`, `git pull` or `git push`.
- `git status -s` first. Commit ONLY your two paths, ON the commit line:
  `git add -- research/Q77_strike_targets.json research/Q77_STRIKE_TARGETS.md`
  then `git commit -m "Q77: ..." -- research/Q77_strike_targets.json research/Q77_STRIKE_TARGETS.md`
  ending the message with `Co-Authored-By: Qwen <noreply@qwen.ai>`.
- Then `git show --stat HEAD` must list exactly those two files. If it lists anything else,
  say so in your mail - do not try to fix it.
- **Do NOT push.** Claude pushes it.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q77-done --body "<hash> strikes=<n> not_strikes=<n> head=<n> body=<n> leg=<n> spread=<n> disagree=<n> low_conf=<n> check=exit0"`
- Do NOT edit `HANDOFF.md`.
