# TASK Q78 - QWEN - THE JUDO AND SAMBO ESCAPES AND DEFENCES THAT DO NOT EXIST

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Not the parse gate, not a
test. **Do NOT start Godot, for any reason**: Claude is running S2's test subsets in this
same checkout and only one Godot may run here at a time. Your gate is a Python script
that MUST exit 0.

## Owned files

- `research/Q78_judo_sambo_nodes.json` - **NEW, yours alone.**
- `research/Q78_JUDO_SAMBO_ESCAPES.md` - **NEW, yours alone.**

Nothing else. **Do NOT edit `technique_catalog.json`, `technique_vocabulary.json`, any
script, any test, `Q78_check.py`, `HANDOFF.md` or `AgentComms/roadmap.json`.** This task
DRAFTS nodes; nothing is merged here.

## Why this exists

Stage S1f makes the ground hold: the top man keeps a man down, and a man on the bottom
has to get out. Its measurements found two content gaps the engine cannot fix by tuning:

- **The judo tree (115 nodes) has NO `escape` node** and one `defense` node
  (`judo_ukemi`). A judoka pinned in osaekomi has nothing of his own art to escape with.
- **The sambo tree (18 nodes) has no `escape` and no `defense` node at all.**

Your job is to draft those nodes in the catalogue's own format, so S1f has content to
merge - with every node labelled by what supports it, so the operator can decide whether
an outside query is needed to verify the drafts before they ship.

## Where things are (read only these)

- The node format: pick three existing nodes with Python from
  `Godot/assets/data/technique_catalog.json` (670 KB - never open it whole) - e.g.
  `bjj_shrimp_escape` (an escape), `judo_ukemi` (the one judo defence), and any judo
  `control` node - and copy their shape: `id`, `name`, `kind`, `tier`, `branch`,
  `requires` (`discipline`, `attributes`, `prerequisites`, `reps`), `match` (`role`,
  `phases`, `effects`), `source`, `grade`, `grade_rank`. Look at the grade ladder the
  judo and sambo trees already use and place your nodes on it.
- The vocabulary: `Godot/assets/data/technique_vocabulary.json` - `roles`, `phase_seats`
  (**`ground` is RETIRING - name `ground_bottom` for an escape from underneath**),
  `defense_classes` and `defense_answers` (a `defense` node's effect keys MUST each have
  a `defense_answers` entry or the validator refuses it; read `_defense_note`).
- What is already researched on disk about judo newaza and sambo rules: grep
  `research/` for `osaekomi`, `escape`, `sambo` (e.g. `J26_IJF_MATTE_AND_ENDINGS.md`,
  `Q72_judo_seats.json`, `Q75_WHAT_RESISTS_A_STAND_UP.md`) and the `judo_ijf`,
  `sambo_fias_sport` and `sambo_fias_combat` entries of
  `Godot/assets/data/competition_rulesets_v2.json`. Quote what you use with file and line.

## Scope

**1. The nodes.** `{"judo": [nodes], "sambo": [nodes]}`. For EACH discipline:

- **at least four escapes** - `role: escape`, `phases` including `ground_bottom` - the
  named escapes that art actually teaches from underneath (a judoka from kesa-gatame,
  yoko-shiho, kami-shiho and tate-shiho; a sambist from a pin and from a leg lock
  entry), with effects built from keys the engine already reads (see how
  `bjj_shrimp_escape` does it);
- **at least two standing defences** - `role: defense`, `phases` including `standing`,
  whose effect keys answer an incoming `takedown` per `defense_answers` (a throw
  defence, a grip break) - named as that art names them.

Ids are new, prefixed `judo_` / `sambo_`, and never collide with an existing id.
Prerequisites must name real ids (in the live catalogue or in your file).
**Every node's `source` string starts `SOURCED:` (quote the file and line on disk that
supports it) or `INFERENCE:` (what you drew it from).** Most will be INFERENCE - that is
honest and expected; say so rather than dressing it up.

**2. The report** `Q78_JUDO_SAMBO_ESCAPES.md`:

- a table of every drafted node: id, name, role, seat, effects, grade, SOURCED/INFERENCE;
- **SEATS** - which seat each node is thrown from and what it answers, and why an escape
  is `ground_bottom` and never plain `ground`;
- **WHAT IS ON DISK** - what the research folder and the competition rules already say
  about these escapes, quoted with file and line, or "not on disk";
- **WHAT AN OUTSIDE QUERY MUST VERIFY** - the smallest list of facts a single outside
  research query would have to confirm before these nodes ship (names, which pins each
  escape answers, grade placement);
- a note on **SUBMISSION**: no `defense_answers` key answers `submission` today, so a
  sambo leg-lock defence cannot be a `defense` node that resists a submission without a
  vocabulary change - say how you handled that (an `escape` node, or a proposed key for
  Claude to adjudicate), and never invent a key inside a `defense` node.

## THE TRAP

**The validator is not decoration - run it yourself before the gate:**
`python Godot/tools/validate_technique_nodes.py research/Q78_judo_sambo_nodes.json`.
It refuses `ground` (retiring), a defence key with no `defense_answers` entry, a
dangling prerequisite and a phase that grants no seat. **Change your nodes to satisfy it,
never the vocabulary.** A draft that only validates because it borrowed a key that means
something else (a strike key on a throw defence) is worse than a smaller draft - say in
the reason which key you chose and what it answers.

## The gate

    python research/Q78_check.py

It runs the node validator on your file, checks seat coverage, id novelty, the labels
and the report's sections. It fails now because your files do not exist. **Fix YOUR
FILES, never the checker.**

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never** run
  `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`, `git clean`,
  `git add -A`, `git pull` or `git push`.
- `git status -s` first. Commit ONLY your two paths, ON the commit line:
  `git add -- research/Q78_judo_sambo_nodes.json research/Q78_JUDO_SAMBO_ESCAPES.md`
  then `git commit -m "Q78: ..." -- research/Q78_judo_sambo_nodes.json research/Q78_JUDO_SAMBO_ESCAPES.md`
  ending the message with `Co-Authored-By: Qwen <noreply@qwen.ai>`.
- Then `git show --stat HEAD` must list exactly those two files. If it lists anything else,
  say so in your mail - do not try to fix it.
- **Do NOT push.** Claude pushes it.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q78-done --body "<hash> judo=<n> sambo=<n> sourced=<n> inference=<n> validator=ok check=exit0"`
- Do NOT edit `HANDOFF.md`.
