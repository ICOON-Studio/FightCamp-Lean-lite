# U19 Digest — the broadcast read

Built against the written R80 contract, not its code. Own fixture.

`BroadcastRead.build(log)` derives the eight reads from `type == "action"` only. One exchange = 14 fight-seconds; per-minute figures use `measured × 14 / 60`. `defense_used` credits the target. Stance prints once (`CLOSED` / `OPEN`).

Empty case is an em dash for every read: no actions, thrown=0 connect/jab, missing `burst` (the path that ships first), missing `stance_matchup`. A zero-throw fighter did not miss everything — connect is `—`, not `0%`. Pre-R80 logs still show time-at-band and range owned from fields already on the event.

Live line on each move strip (`BroadcastReadout`); C59's `_animate` family match was not touched. Post-fight `FightResultPanel` draws THE READ beside THE RANGE when a post-fight read is on the payload. `PostFightRead` carries a `broadcast` key.

Parse 8/0. broadcast_read_test 75/0. ring_stage 0 failures. fight_playback 39/0. post_fight_read 17/0. setpiece 0 failures. Full suite `SUITE total=190 fails=0`.

Do not edit HANDOFF.md — Claude writes the block. Branch `cursor/u19-broadcast-read-70f7`.
