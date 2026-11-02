# TASK U60 — CURSOR — JUDO AND BRAZILIAN JIU-JITSU, THE REAL VOCABULARY

Model: Composer, **medium effort**. Owner: cursor.
Test tier: **RESEARCH + DATA. No shipped `.gd` is edited, no test is touched, no
Godot is run.** `git status -s` before staging is the whole check.

## Read first, and read only this

`research/TECHNIQUE_CATALOGUE_CONTRACT.md` — the schema, the tier rules,
the effect-key rule and the deliverable shape. It is self-contained. Do **not**
read `HANDOFF.md`, `CURRENT_STATUS.md` or any digest, and do not explore to get
oriented.

## Owned files — yours alone, both NEW

- `research/U60_JUDO_BJJ_TECHNIQUES.md`
- `research/U60_judo_bjj_nodes.json`

**Do NOT edit `Godot/assets/data/technique_catalog.json`.** Claude validates and
merges; a bad merge moves every seeded fight in the game.

## The job

`technique_catalog.json` currently carries **18 judo nodes and 20 BJJ nodes**.
The real vocabularies, per the operator and checkable against published lists:

- **Judo: 68 nage-waza and 32 katame-waza.** The Kodokan katame-waza 32 breaks
  down as 10 osaekomi-waza, 12 shime-waza, 10 kansetsu-waza — confirm that
  against the Kodokan's own list and say if it differs.
- **BJJ: roughly 30 to 60 core submission ROOT FAMILIES.** Root families, not
  every named variation — an armbar from guard and an armbar from mount are one
  family. Say where you drew that line and why.

Deliver all of them. **Do not trim to fit what we can animate** — we own about 40
clips and that is deliberately not your problem.

## The operator supplied a starting point — read it second

`research/U60_INPUT_BJJ_BELT_CHECKLIST.md` transcribes a BJJ belt
progression checklist the operator provided, **plus an analysis of the six things
it misses**. Its BAND STRUCTURE (white->blue, blue->purple, purple->brown/black)
is a strong tier skeleton and you should use it. Its individual entries are
INFERENCE-grade — the PDF's own footer says AI responses may include mistakes —
so verify each against a named federation source.

**It lists roughly 27 checkpoints against the 30-60 root families you are asked
for, and several of those 27 are CONCEPTS, not techniques.** The input file names
exactly what is absent: whole choke and joint-lock families, the positional
vocabulary, sweeps, passes, takedowns beyond the double leg, the **gi/no-gi
axis**, and the **ruleset-legality axis**. Fill those.

## Tier from the syllabus, not from taste

Judo has the easiest mapping in the whole project: the **Gokyo no Waza** is
already ordered by teaching sequence, so its five kyo map nearly directly onto
tiers 1-4, with **shinmeisho-no-waza** as Signature. BJJ uses the belt syllabus,
white to black — name the source, because BJJ has no single federation and
syllabi differ between IBJJF, Gracie Barra and others.

`phases` matters more here than anywhere else: judo throws are `standing` and
`clinch`, katame-waza is `ground`, BJJ is mostly `ground` with guard pulls at
`clinch`.

## The traps

1. **DO NOT COIN EFFECT KEYS WITHOUT LOOKING.** 55 keys in this catalogue are
   read by nothing, many of them synonyms of keys that ARE read. Grep the
   existing file first; list anything genuinely new at the top of your report.
2. **A FABRICATED TECHNIQUE NAME IS THE WORST OUTPUT HERE** — unfalsifiable,
   authoritative-looking, and it ships. NOT FOUND is a good answer.
3. **A THROW SHARED BY JUDO AND BJJ IS ONE ID, NOT TWO.** You own both
   disciplines in this task precisely so that osoto gari does not appear twice
   under two spellings. Cross-reference; say which ids are shared.
4. **GI-ONLY AND RULESET-ILLEGAL TECHNIQUES MUST BE FLAGGED PER NODE.** Spider
   and worm guard are gi-only; heel hooks and slicers are banned under many
   rulesets and below brown belt under IBJJF. We have
   `assets/data/combat_rulesets.json`, and a technique the simulation scores in a
   ruleset that forbids it is a correctness bug, not a cosmetic one.
5. **The prerequisite graph must be acyclic.** Claude checks it and will bounce
   the file if it is not.
6. Every `id` must be unique across the WHOLE catalogue, not just your two
   disciplines.

## When done

`git add --` your two files only, commit, push, then
`python Tools/agent_comms.py send --from cursor --to claude --subject U60-done --body "<commit> judo_nage=<n> judo_katame=<n> bjj_families=<n> new_effect_keys=<n>"`.
Write your own 8-line HANDOFF block ABOVE the last `## Direction notes`.
**YOU PUSH TO A BRANCH AND LEAVE HEAD ON IT** — say which branch in your message.
