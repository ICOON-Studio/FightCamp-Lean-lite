# CLAUDE LAND NOTE - J61 (how shipped management games lay out their scene trees)

- **Land as:** `research/J61_SCENE_TREE_GAMES_SURVEY.md` (copy of the box file, unchanged). Staging copy in `_john_delivery/`.
- **Scope:** RESEARCH ONLY. No code, no .gd/.tscn edits. HANDOFF not edited. Claude writes any HANDOFF block.
- **Date:** 2026-10-03. Input: `SCENE_TREE_REVIEW_INPUT.md` (read whole). Grok CLI not used (balance exhausted); web reading only.

## Headline findings
- Many doors to one screen is normal (FM24: at least 4 routes to fixtures; Two Point Hospital: 4 routes to staff training). What confuses is the SAME screen under DIFFERENT names. FightCamp: Schedule has 3 doors under 3 names; Staff has 5 doors from 3 places.
- Proposed rule: a leaf gets at most ONE room object (its place) plus ONE area index tile, same name and icon. Schedule 3 -> 2 doors, Staff 5 -> 2 (script count over the 53-entry map: 41 KEEP, 8 REMOVE, 4 RE-JOB).
- No surveyed game shows an animated preview of a move before training it. Only verified example: WWE 2K25 move-set screen (highlight a move, wrestlers demonstrate). "Not found", not "does not exist".
- Best model to copy: Two Point Hospital lectern -> one course screen (qualification, trainer, trainees, estimated duration) = shape of TRAIN1.
- Proposed tree covers all 29 screens of the input map (sections 3.3, 3.5, 3.7).

## Open questions for Claude / operator (section 6.3)
- Q1 operator said Schedule is in the Staff room; the map shows no such object. Check the 3D scene.
- Q2 Staff room and Physio are tier 4 but hiring and injuries are needed at tier 1.
- Q3 Mat room has no leaf screen (new Classes board, size UNKNOWN).
- Q4 Film room has no door in the map today (orphan); floor door proposed.
- Q5 Office desk content (GOALS) is an inference from FLOW_PASS2 (2026-09-22).
- Check whether `assign_technique_training` accepts a station context and whether moves can be tagged per station (code not read).

## Limits
No game played; counts come from manuals, wikis, patch notes and reviews. Steam samples English-only and partial. Reddit/forums not searched. FM24 training manual, Magic Game World and kairosoft.wiki.gg were blocked (extracts or mirror used).
