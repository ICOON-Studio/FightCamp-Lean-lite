# S75 digest - collect, phase 0, the booking lead time (Claude, 2026-09-25)

No operator playtest report arrived, so the order ran: collect, phase 0, booking model.

## Collected (verified on the main tree)
- **C200 one rig (Codex) MERGED** 55920f3b: 12 clip/retarget/world tests 0 fails; mutant (source_name_map tries only
  the Cascy map) caught. Its edit had turned every em-dash in FightClipRetarget.gd into cp1252 mojibake - repaired.
- **C198 pass 4 (Codex) MERGED default-OFF**: video md5s match the digest; overlap share re-measured here 6.22%
  (`c198_pass4_probe.gd`); fight_stage/world/room/paired/body_layers 21/1 (the known realism red).
- **C199 split (Codex) MERGED**: research captures + tools only, no game script; BUDDI/SMPL-free (only mention is a
  removed line).
- **U172 defender slice 1 (Cursor) MERGED default-OFF**: 9 OFF hashes identical before/after on our tree and equal to
  its digest; 7 subset tests 0 fails; ON defence rate 47% (J50 band 45-65%).
- **C201 (Codex, assigned and delivered this session) MERGED 8c082436**: admission now locks names + joint axes + units and keeps
  per-body proportions. It CORRECTED my brief: the eleven bodies' axes were already identity - C200's "differs on 22
  bones" was an exact Transform compare that included bone lengths. 12/12 ADMIT; f06/f08 exported at 1.75 m as `_v1`;
  skin error 3.6e-7 m; RamsterZ hash unchanged; contract 39/0. Live bindings not switched (S76 after the operator
  sees `c201_f03_old_vs_v1.mp4`).
- **Q173 p2 + Q174 (Qwen) NOT merged**: time share 10.07% < 10.36% floor; leg-share test floor lowered 6->4% without
  proof; Q174 measured identical fighters with uncommitted tools and changed boxing/kickboxing with no switch.
  -> Q175 "land the clinch work" assigned.
- **G96 (Grok) COLLECTED** -> `G96_AMATEUR_BOOKING.md`. **D18 (Dola) COLLECTED** -> `D18_MIC_CORNER_CALLS.md` (raw;
  recommends Vosk, Apache 2.0; several figures unsourced -> D19).

## Phase 0 (published https://claude.ai/artifact/JJHo56fezkGGyVyJ4fHdjn, copy `S75_PHASE0.html`)
Product sheet (three pillars, stand-up v1, EA $19.99, 10k wishlist target - for operator sign-off), legal inventory,
budget. Findings: **the private playable shipped the Reallusion CC export** (`assets/_local`) - now excluded from
`build_playable.py` and the export filter (pck 643 -> 200 MB). **Tripo free plan = "Public Models · Non-Commercial
Use"** (tripo3d.ai/pricing): the twelve fighters cannot ship in a sold game; regenerate on Pro ($20/mo) before release.
Governing-body/league names remain in 15 data files (WAKO 24, UFC 13...). Burn ~EUR 294-343/month (operator figures).

## Booking model (G96) - `AmateurBooking.gd`, GameState
- An amateur bout is fought **2-4 career weeks** after the week it is offered (G96 verdict 14-28 days, JUDGEMENT on
  England Boxing's SOURCED 8-12 week permits); fixed per offer id. `get_booked_fight_due_week` carries it; a booked
  offer keeps resolving until fight night.
- A novice (0-10 bouts, USA Boxing SOURCED) meets only novices. G96's 0-2 debut rule is named, NOT enforced: the
  census `tools/s75_amateur_pool_census.gd` found **0 of 60** pool opponents with <=2 bouts in four countries -
  the world population has no novices (WorldPopulation records are 0-8 wins, 0-5 losses).
- `amateur_booking_lead_time_test` (mutants: lead 0 -> 12 fails; filter off -> 1). Subsets 29/0.
- Exported build walked (`research/s75_exe_walk.plan`, new `until` verb): enter the card, CONTINUE through the camp,
  fight week, weigh-in, 3D bout, result - 33 steps, 0 dead ends, 0 script errors.

## Still open
The desk still lists many UNSAFE rows ("TEN FIGHTS TO NONE - NOBODY WOULD SANCTION THIS") because the world has no
novices; "NONE FIGHTS TO TWO" wording; ring card as 14 buttons; jargon on the weigh-in.

## Gate
`SUITE total=409 fails=9` (--jobs 4, run once this session before C201's merge; C201 then 4/0 on its subset). The nine
are exactly the S73 nine: athlete_development, capsule_coverage_contract, fight_body_overlap, fight_metres (hang),
fight_pace_anchor, fight_pair_live (PARKED), fight_scoring, fight_stage_realism, fighter_reachability_contract.
**From now the full suite is NIGHTLY** (operator rule, after the CPU hit 90 C): task "FightCamp Nightly Suite" runs
`Tools/nightly_suite.ps1` at 05:00 - warning popup, postpone 20 min, skipped if he is on the PC at 06:00 - then
`--jobs 2`; result in `AgentComms/nightly/latest.txt`.

## Agents at handover
Qwen Q175 pass 2 (time share 10.07% < floor; boxing hold 10.1 s vs 5-6 s; pass 1 proved the leg drop
denominator-only and put boxing_hold OFF with identical hashes). Cursor U173 (anticipate + counter). Codex C202
(reaction joins that crouch). Grok G98 (who is in a real amateur scene). Dola D20 (a link on every D19 row).
John, Kalli, Maria hold their standing tasks.
