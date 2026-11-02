# TASK Q65 — QWEN — MUAY THAI: 55 BASE AND 30 MASTER TECHNIQUES

Model: qwen3-coder, **medium effort**. Owner: qwen.
Test tier: **RESEARCH + DATA. No shipped `.gd`, no test, NO GODOT AT ALL.**

## Read first, and read only this

`research/TECHNIQUE_CATALOGUE_CONTRACT.md`. Self-contained. Do **not** read
`HANDOFF.md`, `CURRENT_STATUS.md` or any digest.

## Owned files — yours alone, both NEW

- `research/Q65_MUAY_THAI_TECHNIQUES.md`
- `research/Q65_muay_thai_nodes.json`

**Do NOT edit `Godot/assets/data/technique_catalog.json`.**

## The job

The catalogue carries **18 muay thai nodes**. The real vocabulary is roughly
**55 base techniques plus 30 master techniques**, and the 30 is not a round
number — it is **Mae Mai Muay Thai (15 major techniques) plus Luk Mai Muay Thai
(15 minor/complementary)**. Confirm that against a published source and say so;
if the source disagrees, report what it says rather than what this file says.

Cover the full arsenal: punches (mat), elbows (sok), knees (khao), kicks (te),
teeps, the clinch (chap ko / plum), and defensive techniques. **Use the Thai
names** — `Sok Tat`, `Khao Loi`, `Teep` — with a short English gloss. Romanisation
varies; pick one system, say which, and be consistent.

## Tier from the real progression

Base arsenal is Foundation and Core. **Mae Mai and Luk Mai are Advanced and
Signature** — that is the art's own division and it is exactly the expertise axis
the operator asked for. Muay Thai has no universal belt system; if you find no
formal grading, say **NOT FOUND** and tier by teaching order from a named
instructional source rather than inventing a syllabus.

## The traps

1. **DO NOT COIN EFFECT KEYS WITHOUT GREPPING FIRST.** 55 keys in this catalogue
   are read by nothing, many of them synonyms of live ones. List anything new at
   the top of your report.
2. **Q61 IS YOUR CAUTIONARY TALE AND IT APPLIES DIRECTLY.** That report drew a
   verdict from an instrument whose own control had failed, and it was thrown
   out. Here the equivalent is a technique name you cannot source. **NOT FOUND
   beats a plausible invention.** A fabricated Thai name is unfalsifiable and
   would ship.
3. **Do not trim to 18 or to what we can animate.** The frame is the defect.
4. Prerequisite graph must be acyclic; every id unique across the whole file.

## When done

`git add --` your two files only, commit, push, then
`python Tools/agent_comms.py send --from qwen --to claude --subject Q65-done --body "<commit> base=<n> mae_mai=<n> luk_mai=<n> new_effect_keys=<n>"`.
**Write your own HANDOFF block** — you shipped Q59 without one — ABOVE the last
`## Direction notes`, header status OPEN or COMPLETE, never `IN PROGRESS`.
