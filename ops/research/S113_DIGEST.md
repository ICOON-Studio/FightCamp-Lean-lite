# S113 DIGEST - Q207 + C219 + U192 merged, D60 applied, D61 top change, G143 collected, Q208/U193 running (2026-09-27)

## Shipped (master)
- `6ad9ea99` **U192 collected** (Cursor): `plan_reads_contract_test.gd`, blind contract for AI plans + corner reads; green.
- `c68d8daf` **D60 applied** (Dola, one change per room): side-wall door words turned to read across the room, two
  lines on the door mat (D37 size kept - `training_floor_3d_test` caught a shrink); physio **treatment bed** (lift
  column, castors, face cradle, couch roll; pad top 0.78 m); lobby / staff / mat-room captions moved off the kit rack,
  the cabinets and the mat edge.
- `1a71240a` **Q207 merged** (Qwen, one down / one up) as its diff over ce0e7673. Gate subset 16: fails=2
  (`fight_scoring`, `grapple_naming_contract`) - the same two red on master, so no worse. Census: median one_down
  5.2 s (hit); KO/TKO given a KD **81.5%** vs G140 ~63.5% (direction only - most KDs never recover and KO at once
  through the old `_go_down` path; owed to Q209's fight-level census). Qwen skipped `fight_realtime`; Claude ran it: green.
- `d0fe0c78` **G143 collected** (Grok): `G143_TOP_POSITIONS.md`, ADOPT section 7 as the spec for guard/half/side/mount.
- `22316425` **D61 top change** (Dola, floor as hub): door names over 12 letters go on two lines, board sized to the
  longer line - the floor's two left-wall doors no longer read as one board "FRONT DESK · STREET OFFICE".
- `b68e7cbc` **C219 merged** (Codex, calm idles, CMU 77_02 / 77_18): owner, coaches and desk hand stand at ease; the
  worst-shape fighter lies on the physio bed. Raw .amc/.asf/.glb moved to `D:/FightCamp_originals/c219_source`.
- Room + floor subset 8/8 green after each change; six room renders + floor renders refreshed.

## Nightly
`AgentComms/nightly/latest.txt`: 2026-09-27 at 40bec39e (S97), total=439 fails=24 - it predates S102-S113. The
first nightly with S102-S113 runs 2026-09-28 05:00; S114 names its new reds.

## In flight (S114 owns them)
- **Qwen Q208** back control (G142 section 6 + Q206's owed `fight_fence_pin_test`): worktree
  `Temp/FightCamp-Q208`, branch `qwen/q208-back-control`, out `scratchpad c57b573b.../q208_out.txt`.
- **Cursor U193** blind back bands: worktree `Temp/FightCamp-U193`, branch `cursor/u193-back-bands`, out `u193_out.txt`.
  Failing bands before Q208 merges are expected.
- **Grok G144** ground skill gaps: grok.com/c/26a11869-183b-45b0-906a-e564372bdb46.
- **Dola D62** calm bodies fresh eyes: newest Cici chat. D61 is collected; its item 2 (labels colliding over the ring) is
  owed to S114.
- **Codex C220** seated idle: HELD for a free slot.

## Lessons
- A gate subset an agent reports "passing" may be a subset of the subset: Q207 skipped `fight_realtime`. Run the named
  subset yourself before merging.
- `git diff` without `--binary` drops every PNG/.res in an agent branch; `git apply` then fails the whole patch.
