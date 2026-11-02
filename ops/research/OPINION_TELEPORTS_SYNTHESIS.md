# Body teleports - six opinions, one decision (Claude, S60, 2026-09-23)

Brief: `TASK_OPINION_BODY_TELEPORTS.md`. Answers, blind to each other: `OPINION_TELEPORTS_{DOLA,CURSOR,CODEX,QWEN,GROK,JOHN}.md`.
Kalli and Maria were not asked (out of rotation, operator ruling 2026-09-22).
Measured problem (U145 probe): ~73 root jumps (> 0.10 m or > 15 deg in 1/60 s) per boxing round,
45-61 per MMA round, from two writers: the full-depth overlap push in `_floor_clamped`, and the
paired-clip mount snap at grapple start/end.

## Where all six agree
1. **No body may move more than a capped amount in one frame, from ANY system.** Caps proposed:
   Cursor 2 cm, Dola 3 cm + 10 deg, Qwen 5 cm, John 7-10 cm (sprint speed), Grok/Codex "capped".
2. **The unapplied correction is carried as state and shed over the following frames** - never
   dropped, never applied at once (Qwen's decay buffer; Dola 25 %/frame; Cursor residual depth).
3. **Two-person clips ENTER and EXIT through a warp window of ~8-15 frames (0.2-0.3 s)** that moves
   both roots toward the clip's authored relative transform; residual size mismatch inside a hold
   goes to contact IK, not to the roots (Grok, Codex, John, Cursor, Qwen, Dola).
4. **Later, the engine keeps a minimum distance before close-range work**, so the room has less to
   correct (John: engine owns separation outright; Dola: engine pre-alignment; Grok, Qwen).
5. Full motion warping / motion matching is the long-term shape; not this week.

## Where they differ
- **Who owns separation:** John - the ENGINE, the room never deep-pushes. Codex - one room-side
  "reconciliation coordinator" that is the only writer of roots. Cursor - room, hands/elbows yield
  BEFORE the root moves. These are compatible in order: coordinator now, engine separation later.
- **The trade every one of them raised against themselves:** easing the push means a few frames of
  SHALLOW OVERLAP instead of a jump; the operator has rejected overlap before.

## Decision (lead)
- **Overlap budget: <= 3 cm of visible interpenetration for <= 0.1 s, never deeper.** Beyond that the
  correction speed rises (up to the 10 cm/frame ceiling) rather than the overlap growing.
- **Per-frame cap on any root write: 3 cm and 10 deg** outside the budget case above; one
  coordinator owns every root write (Codex), hands yield first (Cursor).
- **Gate:** boxing <= 5 root jumps per round, MMA <= 8 (John's 5, Dola's 2 as the stretch);
  zero one-frame full-depth pushes; zero mount snaps; beat list byte-identical (engine untouched).
- **This week:** U146 (Cursor, in flight) = items 1-3. **Next:** engine minimum-distance envelope
  before clinch/grapple (item 4) as its own stage, measured with the same U145 probe.
