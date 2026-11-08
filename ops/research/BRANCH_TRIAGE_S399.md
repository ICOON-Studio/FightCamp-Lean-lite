# Remote branch triage (S399)

68 handed over as 'unmerged'; 76 found unmerged into main on 2026-11-07. Nothing deleted: deletion needs the operator's OK.

| group | count | proposal |
|---|---|---|
| closed-PR | 35 | delete: each PR was closed with its reason (decided) |
| merged-PR | 2 | delete: content is on main (squash/merge) |
| no-PR | 39 | keep for now: wip/s399-*, live seat/session branches, and older seat runs judged in handovers - review in a later pass |

## closed-PR

- `goose/issue-10` 2026-11-01 #12:CLOSED
- `goose/issue-11` 2026-11-01 #15:CLOSED
- `agy/fight9r1` 2026-11-03 #24:CLOSED
- `agy/fight9r6` 2026-11-03 #30:CLOSED
- `cursor/fight9r4` 2026-11-03 #28:CLOSED
- `cursor/locowalk1` 2026-11-03 #31:CLOSED
- `cursor/locowalk2` 2026-11-03 #33:CLOSED
- `qwen/kallinums1` 2026-11-03 #27:CLOSED
- `qwen/noref1` 2026-11-03 #23:CLOSED
- `agy/bjj9r12` 2026-11-04 #36:CLOSED
- `agy/bjj9r13` 2026-11-04 #37:CLOSED
- `agy/fight9r10` 2026-11-04 #38:CLOSED
- `agy/fight9r11` 2026-11-04 #40:CLOSED
- `agy/fight9r12` 2026-11-04 #41:CLOSED
- `agy/fight9r9` 2026-11-04 #34:CLOSED
- `cursor/bjj9r14` 2026-11-04 #39:CLOSED
- `cursor/locowalk4` 2026-11-04 #35:CLOSED
- `agy/fight9r13` 2026-11-05 #43:CLOSED
- `agy/fight9r14` 2026-11-05 #45:CLOSED
- `agy/fight9r15` 2026-11-05 #50:CLOSED
- `cursor/bjj9r15` 2026-11-05 #42:CLOSED
- `cursor/bjj9r17` 2026-11-05 #49:CLOSED
- `qwen/sound1` 2026-11-05 #46:CLOSED
- `qwen/sound1r2` 2026-11-05 #51:CLOSED
- `agy/fight9r17` 2026-11-06 #55:CLOSED
- `agy/fight9r18` 2026-11-06 #56:CLOSED
- `agy/fight9r19` 2026-11-06 #57:CLOSED
- `arena/6e41a147-fightcamp-lean` 2026-11-07 #71:CLOSED
- `cursor/fightwalk1` 2026-11-07 #66:CLOSED
- `cursor/fightwalk2` 2026-11-07 #70:CLOSED
- `cursor/fightwalk3` 2026-11-07 #73:CLOSED
- `cursor/southpaw1` 2026-11-07 #74:CLOSED
- `qwen/hitsell1` 2026-11-07 #65:CLOSED
- `qwen/hitsell2` 2026-11-07 #69:CLOSED
- `qwen/hitsell4` 2026-11-07 #72:CLOSED

## merged-PR

- `arena/c361ab64-fightcamp-lean-lite` 2026-10-29 #7:MERGED
- `goose/issue-8` 2026-10-29 #9:MERGED

## no-PR

- `ziva/lean` 2026-10-30 no PR
- `qwen/bodytrack1` 2026-10-31 no PR
- `qwen/paceaim1` 2026-10-31 no PR
- `qwen/shortpunch1` 2026-10-31 no PR
- `cursor/fightcard1` 2026-11-01 no PR
- `cursor/ground2a` 2026-11-01 no PR
- `goose/issue-13` 2026-11-01 no PR
- `goose/issue-14` 2026-11-01 no PR
- `goose/issue-16` 2026-11-01 no PR
- `goose/issue-17` 2026-11-01 no PR
- `goose/issue-18` 2026-11-01 no PR
- `qwen/ground3` 2026-11-01 no PR
- `qwen/prodebut1` 2026-11-01 no PR
- `agy/refbreak1` 2026-11-02 no PR
- `claude/jabfix1` 2026-11-02 no PR
- `cursor/trainclips1` 2026-11-02 no PR
- `ziva/footwork1` 2026-11-02 no PR
- `ziva/smooth3-r4` 2026-11-02 no PR
- `ziva/bodyreact1` 2026-11-03 no PR
- `claude/boxmap1` 2026-11-04 no PR
- `claude/footwork1` 2026-11-04 no PR
- `claude/locowalk3` 2026-11-04 no PR
- `claude/theatre-ground` 2026-11-04 no PR
- `claude/defflow1` 2026-11-05 no PR
- `goose/issue-48` 2026-11-05 no PR
- `goose/issue-53` 2026-11-05 no PR
- `claude/bjjcontact` 2026-11-06 no PR
- `wip/s399-s394-portraits` 2026-11-06 no PR
- `claude/fighter-profiles-407aee` 2026-11-07 no PR
- `goose/issue-67` 2026-11-07 no PR
- `goose/issue-68` 2026-11-07 no PR
- `qwen/hitsell3` 2026-11-07 no PR
- `qwen/inside4` 2026-11-07 no PR
- `wip/s399-clinch-shape` 2026-11-07 no PR
- `wip/s399-fight9r10` 2026-11-07 no PR
- `wip/s399-fightwalk2` 2026-11-07 no PR
- `wip/s399-ground3` 2026-11-07 no PR
- `wip/s399-insidework` 2026-11-07 no PR
- `wip/s399-padview1` 2026-11-07 no PR

**S399 DONE (operator "yes delete"):** the 37 closed-PR and merged-PR branches above are deleted from origin. The no-PR group stays.

## S399 second pass - no-PR branches (git cherry vs main)
Proposed batch 2 for deletion (needs his OK): `qwen/shortpunch1` (every commit already on main); `goose/issue-67`
(INSIDE2), `goose/issue-68` (CORNERCAM1), `qwen/hitsell3`, `qwen/inside4` - all decided NOT merged in the S397 anim
chain (ANIM_HANDOVER_S397.md). The other 34 carry commits main does not have: keep until each is decided (wip/s399-*
are this session's saves; claude/fighter-profiles-407aee is FIGHTERMODEL3's BASE; claude/defflow1 has 40).

**S399 batch 2 DONE (operator "Yes, delete them"):** the 5 above deleted from origin.

## S400 third pass (operator "i want all fixes merged") - what each leftover branch still holds
Read-only check of 26 branches (file presence on main + commit messages; git cherry marks everything "+" because main
collects by diff). RESULT: no rules / menu / tool branch is left to merge - every one is already on main.
- Already on main, delete batch 3 (needs his OK): goose/issue-8, goose/issue-13, goose/issue-14, goose/issue-16,
  goose/issue-17, goose/issue-18, goose/issue-48, qwen/bodytrack1, qwen/paceaim1, qwen/ground3, qwen/prodebut1,
  qwen/kallinums1, qwen/noref1, qwen/sound1, cursor/ground2a, cursor/trainclips1 (16).
- Fight animation / BJJ, NOT on main, held by the S399 rule (no layer work until clips match the source): claude/boxmap1,
  claude/theatre-ground, claude/defflow1 (partly on main), cursor/fightcard1 (partly), agy/refbreak1 (referee dropped in
  NOREF S386 - obsolete), arena/6e41a147 (rejected on main d0e95c2e), claude/jabfix1 (stale single bake).
- Keep as record: ziva/lean (S311-S317 playtest notes), goose/issue-53 (menu direction review), wip/s399-s394-portraits
  (S394 gym portraits, scored 4.5 and not used).
