# S563 digest (2026-11-26, Opus 5.5)

## His words this session (quoted)
- "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ? Can you
  have ziva and some other agents playtest the current version and provide feedback" -> ALLPLAY2 (below).
- "Yes, close them" (the 13 old Claude desktop sessions, to free memory for Ziva) -> 14 old FightCamp sessions from Nov
  24-26 archived (the two newest kept: they launched INSIDE1 and GLIDE2); memory 97% -> 76%, the PC went GREEN, every
  worker stayed alive.

## His question, answered by four playtesters (ALLPLAY2, `ops/research/allplay2/<seat>/`)
Built first: a TELLS trial in the words tool only (`proto/twohands/tools/tells.mjs`, `play_cli.mjs new ... tells=1`):
before each beat ONE thing his body does, from the beat he already chose (John SQ336's real cues, Kalli SQ335's design),
honest except one learnable lie per man. Each seat played bouts with and without it.
| Seat | Bouts | Pick | Fun no tells / with tells |
|---|---|---|---|
| Claude (console) | 6 | one body tell | 7 / 8 |
| Arena (cloud) | 6 | one body tell + keep his last three beats | 6 / 8 |
| Ziva (editor, hidden desktop) | 6 | one body tell, with four fixes | 3 / 8 |
| Dola (by message + a follow-up) | 4 | one body tell | 6 / 8 |
| Antigravity (by message) | 4 | (running at the handover) | |
All four: NOT his whole plan ("The fight becomes a lock to solve" - Claude; "every beat ... has one correct answer that I
could work out by sum" - Arena). Arena: his punches landed 27 times blind, 17 with tells. Ziva: "worth about 4 points a
bout". What all asked to fix: lies that actually fire (the Jabber and the Slugger hardly lied), the ledger saying WHEN a
fake came, the front foot meaning nothing Inside, "quiet" hiding a clinch, and a cost for a fake.

## Done (commits on main)
- f51515942 tells trial + ALLPLAY2 brief; play_by_message.mjs `tag=` and `opp:seed:t` bouts (S563 also: the report
  prompt asks the owner's question; Dola was asked it as a follow-up because the first prompt did not).
- f173f1fec page fixes from the Claude playtester's pictures: the beat story's words full width under each label (it
  wrapped one word a line and the commentary covered rows), the throw order "Feint - 2nd" (was "Feint (2)", read as a
  cost). order / punch (rebuilt by make_punch.py, F) / head / kick; page_parse 4 ok, page_play_test 4 passed.
- 5b0cf60a5 TELLS VERSION 2 (`tells=2`, DESIGN_TELLS2.md): lies on states on screen - the Jabber the beat after he backed
  off (29% of beats), the Slugger the beat after you landed (27%), the Body Snatcher the beat after you blocked a punch
  (13%), measured with `tell_rates.mjs` (the page's AI in both corners); lies are bluffs only (a caught lie leaves a gap),
  a fake costs him 1 stamina, a back-foot cue (back off / clinch), the foot means nothing Inside, the ledger says when.
  Version 1 bouts play exactly as before (it was changed while two playtests were running: checked on a seed).
- a308d8f21 PROGP3 collected (Arena PR 455): health 20 v 16 alone 73% (over its bar), stamina worth the most per step,
  guard decides nothing (the guard almost never breaks; the S562 note that its runs were clamped was wrong: the probe's
  cap is per man). DESIGN_PROGRESSION1 3d now keeps health 17-19, stamina 7-9, recovery 1; best v worst 65%.
- 76177b9e8 KICKFIX2 collected (PR 454): E1 dead (low kick lands 93%), the limp loop ran uncapped (5 of 9 stoppages after a
  limp) - the run stopped on its own brief's loop rule.
- PR 453 (PUNCHCHANCE2, collected in S562) closed.

## Launched (Arena, cloud; nothing on the PC)
| Run | Branch on FightCamp-Lean-lite | What |
|---|---|---|
| KICKFIX3 | arena/c178d87d | E2 and E3 measured as prepared, the limp capped (N.limp 6) only where its loop fires |
| PROGP2 | arena/15b7ab01 | his Q-340 "Yes, a choice": at Sharp, cheaper or faster, per punch (probe_sharp.mjs) |
| ALLPLAY2B (Arena) | arena/f0a3ce55 | tells version 2 replayed, compared with its round 1 |
| KDHEAL1 | arena/836987cb | "a knockdown heals" (Arena, Ziva): get-up [4,3], [4,2], [3,2] against [6,4] |
Still running from S562: HEADPULL1 arena/397eb67a, MOMENTGAP1 arena/4bdf9ebc, CLINCHFIX2 arena/204b98f9 (P0 8 of 9 both
seeds), JABLAND1 arena/ba10e2bf. Ziva plays ALLPLAY2B in its same chat (editor on the hidden desktop, port 7012).

## Not done / open
- The knockdown picture pushes the man off the ring's left edge; the overhand is drawn with the hook picture (renders:
  his game was open all session). On the map NEXT.
- The other findings all four agree on (DESIGN_TELLS2 3b): the clinch deletes a paid beat (CLINCHFIX2), Long is a
  corridor, his habit read and his pull counter are invisible.
- The tells on the page: after version 2's replay and a measure on the instrument (Kalli's bars), as a POSE of his body
  (three guard poses a man), the cue word in the ring's corner badge - never near the men (S562).
