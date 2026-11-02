# TASK C95 — CODEX — KARATE: 150 TO 200 TECHNIQUES, ON THE REAL KYU/DAN LADDER

Model: **gpt-5.6-luna, medium effort — never high.** Owner: codex.
Test tier: **RESEARCH + DATA. No shipped `.gd`, no test, NO GODOT.**
`git status -s` before staging is the whole check.

## Read first, and read only this

`research/TECHNIQUE_CATALOGUE_CONTRACT.md` — the schema, the tier rules,
the effect-key rule, the deliverable shape. Self-contained. Do **not** read
`HANDOFF.md`, `CURRENT_STATUS.md` or any digest, and do not explore to get
oriented.

## Owned files — yours alone, both NEW

- `research/C95_KARATE_TECHNIQUES.md`
- `research/C95_karate_nodes.json`

**Do NOT edit `Godot/assets/data/technique_catalog.json`.** Claude validates and
merges; a bad merge moves every seeded fight in the game.

## The job

The catalogue carries **18 karate nodes**. The operator's figure, and it is the
right order of magnitude: **karate has 150 to 200 distinct base techniques.**
Deliver the real vocabulary.

**The existing 18 use authentic terminology** — `karate_kizamizuki` is
Kizami-zuki, `karate_gyakuzuki` is Gyaku-zuki — so somebody knew the domain and
was working to a fixed 18-slot frame. **Keep the existing ids where the technique
is the same; do not rename them.** Report any you believe are wrong.

Cover the whole art, not just the punches the current 18 lean on:
**zuki** (thrust/punch) · **uchi** (strike) · **uke** (block/receive) ·
**geri** (kick) · **dachi** (stance) · **tai sabaki** (body movement) ·
**nage/kansetsu waza** (throws and locks, which karate does have and the
catalogue ignores entirely).

## Tier from the kyu/dan syllabus — this is the point of the task

The operator asked for *"the real progression on getting a black belt in karate"*.
So tier 1-4 must map onto the grading ladder:

| kyu/dan | tier |
|---|---|
| 10th–7th kyu | 1 Foundation |
| 6th–4th kyu | 2 Core |
| 3rd–1st kyu | 3 Advanced |
| dan grades | 4 Signature |

**NAME THE ORGANISATION WHOSE SYLLABUS YOU USED.** JKA, WKF, Shotokan, Kyokushin
and Goju-ryu grade differently, and stating which one is the whole difference
between research and assertion. If you use one style's syllabus as the spine,
say so and note where another style diverges sharply.

## The traps

1. **A FABRICATED JAPANESE TECHNIQUE NAME IS THE WORST POSSIBLE OUTPUT.** It is
   unfalsifiable, it looks authoritative, and it ships. **NOT FOUND is a good
   answer and we want it explicitly.** Label every claim DOCUMENTED (name the
   source), INFERENCE (say what from), or NOT FOUND.
2. **DO NOT COIN EFFECT KEYS WITHOUT GREPPING THE CATALOGUE FIRST.** 55 effect
   keys in that file are read by NOTHING in the code, many of them synonyms of
   keys that ARE read. Reuse what exists; list anything genuinely new at the top
   of your report.
3. **DO NOT TRIM TO 18, AND DO NOT TRIM TO WHAT WE CAN ANIMATE.** We own about 40
   clips; that is deliberately not your problem. A technique with no clip still
   changes the fight, it is simply not yet seen.
4. **Kata are not techniques.** Heian Shodan is a form, not a move. If you emit
   kata at all they are `kind: "skill"` and must be justified.
5. Prerequisite graph must be acyclic; every `id` unique across the WHOLE file.

## When done

`git add --` your two files only, commit, push, then
`python Tools/agent_comms.py send --from codex --to claude --subject C95-done --body "<commit> techniques=<n> syllabus=<org> kept_existing_ids=<n> new_effect_keys=<n>"`.
Write your own 8-line HANDOFF block ABOVE the LAST `## Direction notes`.
