# SCOPE S220 - the scope cut (2026-10-13)

Operator (verbatim): "act on this tighten the scope", replying to: "Too much is open at once. There are 92 open queue items, 339
unmerged branches and 493 items waiting for a decision. Many queue rows date from S128-S190. Station wear, gym look, profile, story,
animation, MetaHumans and wardrobe all move a little each session, and none of them finishes."

## The rule (roadmap queue.focus_rule; `start` prints only these)
At most 14 FOCUS rows. A row is FOCUS only if it is on the demo path - New Career -> the gym -> train -> book -> WATCH THE FIGHT ->
result - or fixes a defect the operator has seen. A new row enters only when one leaves. Everything else is PARKED (state kept,
history kept, `start --full` shows it) and comes back only by the operator's call or when a FOCUS row needs it.

## FOCUS (in order)
| # | row | why it is on the path |
|---|---|---|
| 1 | NEWCAREER3 | the first screen of the career must show and arrange HIS gym (operator S220; Ludo r57/57b; waits his OK) |
| 2 | FLYFOOT1 | fighters fly / slide in the fight (operator C50-C52) - Codex running |
| 3 | PAIRLIVE1 | jab pair playback defects in the live fight |
| 4 | KM3B | the neck is buried on the MetaHuman boxers (punches to the head) |
| 5 | ANIMSOURCE1 (+MHNATIVE1) | the gloved punch clips - the fight's look |
| 6 | TECHSTAGE1 | finish only (FIX5, last red gate): a drilled move gets visibly better = training matters |
| 7 | SPLITFIGHT1 | the two 6,500-line fight scripts every fight fix edits - after FLYFOOT1 + PAIRLIVE1 land |
| 8 | STORYPARITY1 | sandbox promoters + debt (approved Q-S212-16) - Arena running |
| 9 | STATIONWEAR1D | collect 1D, build 1E only on the operator's yes (Q-S219-2) |
| 10 | GYMLOOK3 | the gym floor look: 3A on his OK (8787/review), then 3B |
| 11 | PROFILE2 | the fighter profile (scout / train screen) - Cursor r11 running |
| 12 | WARDROBE1 | boxers fight barefoot (defect seen 10-13) |
| 13 | MH5 | the two women look identical (defect seen 10-13) |
| 14 | NIGHTLY1 | the nightly suite stays green |

## SUPERSEDED (15) - folded into a FOCUS row
GYMLOOK1, GYMLOOK2, GYMLOOK3B -> GYMLOOK3 · METAHUMAN1 -> MH5 · ANIMPROOF1, RC2 -> MetaHuman-only rule (no MPFB bodies) · KM3 -> KM3B ·
MH3, CHOP3 -> ANIMSOURCE1 / FLYFOOT1 · FOOTLOCK -> FLYFOOT1 · PROFILE-STAGE-CAM, PROFILE3 -> PROFILE2 · NIGHTLY5 -> NIGHTLY1 ·
FLOOR-PLAY -> NEWCAREER3 (move zones) · STATION-WEAR1 -> STATIONWEAR1D · MHNATIVE1 -> ANIMSOURCE1.

## PARKED (63) - after the demo or by the operator's call
Biggest groups: the S190 Ludo evaluation rows (LUDO-*), members/sparring/cuts/wear design (MEMBERS1, SPAR1, CUTSCAR1, WEAR1,
ATTRITION1), equipment art and animation (EQUIP3, GYMART1, EQUIPANIM1, BAGRIG1, EQUIPSLOTS1), the UI restyle (UISYS1 = D47 warm brown on
the profile/fight HUD, after the playable loop as already decided), HUD2/PLAYUI1/HEADERS2/WIRE-HEADERS, story extras (STORY4-6), the
clinch/stamina engine rows (CLINCH, ST1), C223 run 10, LUDOANIM1, FIGHTLOG1, STAFF1, RECEPTION1, STRESS1, REALISM1, ROOMSUI1, K47,
DAGESTAN, SUMMER1, M_ICONS54, and the S197 rows that had no state at all (HALLSIZE1, STATIONS4, STATIONINFO1, ROOMSPLIT1/1B,
LUDO-R26, MEMBERS1B, SPLIT3, ENGINESPLIT1, SCREENSPLIT1). Full list: `python Tools/agent_comms.py start --full`.

## Not touched (needs the operator)
339 unmerged remote branches: deleting a branch cannot be undone, so none is deleted; parked rows keep theirs. 493 triage items:
report-only, nothing changes.
