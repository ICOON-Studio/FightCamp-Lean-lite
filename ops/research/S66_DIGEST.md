# S66 digest - the result screen says why; the money names its payee; the numbers agree (Claude, 2026-09-24)

Lane: management + GUI; Claude integrates the engine/motion agents.

## The three (lead's pick, from the S64 walk - the operator had not named three)
1. **THE READ was empty on every real-time bout - and so were the corner columns, the totals and the "why".**
   Two shape mismatches, both in the shared read modules, not the screen:
   - `FightRealtime` logs ONE record per blow (`actor`/`contact`/`region`/`band`/`significant`), while
     `BroadcastRead` only folded the old engine's per-exchange `burst`. Every row printed an em dash.
     Now a `contact` record with no `burst` folds as one throw; only SIGNIFICANT blows count as thrown/landed
     (FightMetric, J20); zones (head/body/legs), knockdowns and named defences are read off the record;
     per-minute uses the bout's clock (each round's first-to-last `t_s`) - summing the 0.1 s impact spans
     would print ~600 punches a minute. The old engine's burst logs read exactly as before.
   - A real-time scorecard is `{round, cards, consensus}` with no top-level `a`/`b`, so `PostFightRead` and
     `ScorecardRead` read every round 0-0 (the S64 screen: LARKIN 0 / STERLING 0 beside judges' 10-8).
     Both now read the consensus; `FightRealtime._close_round` stamps the round's `knockdowns_a/b` on the card.
   - With 1 and 2 fixed, `FightCausation` fills: seed 92013 "locked the submission - 1 attempt before the
     tap", "outlanded 78-51 on significant strikes", "owned the floor - 128 control units", "2 takedowns".
   - THE READ card adds HEAD · BODY · LEGS, KNOCKDOWNS, TAKEDOWNS, CONTROL, and drops a row neither man was
     measured on (real-time has no steps/range owner; boxing no takedowns). A measured zero still prints.
2. **PAID TO THE GYM $0 - it was two defects, and neither was the settlement.** (a) Settlement runs at the
   bell and clears `pending_fight_result`, so `get_fight_result_card` is always empty on the live path and
   the panel fell back to the ring payload, which never carried `paid` - $600 + $400 printed above $0.
   The settlement row now carries `paid`, `to_fighter`, `to_gym`, `weight_fine`, `performance_bonus`,
   `manager_filed`/`manager_share_percent`; the payload carries them; the ledger sums its own rows when a
   save predates them. (b) The big figure was the FIGHTER's money labelled as the gym's. By R43/J4 E1 the
   promoter pays the contestant; the gym takes a share ONLY through a filed manager contract (E23: none
   filed = exactly 0; E2: never a default %). Nothing in the game files one. The ledger now reads
   `TO <FIGHTER>  $1,000` and `TO THE GYM  $0  NO MANAGER CONTRACT FILED`.
   **Product gap, recorded for a stage:** the player (the gym) has no way to earn from a fight. The legal
   route is a manager contract the fighter signs, capped per jurisdiction (`manager_share_caps.json`).
3. **The numbers disagreed.** Profile CONDITION dial printed the fight-ready RATING (33, already printed as
   FIGHT-READY 33 below it) while Training's COND read body readiness (100): the dial now reads
   `BodyReadiness.minimum_readiness`, the hub's number. "0-1-0" beside "NO BOUT YET": a signed fighter's
   prior record now reads "NO BOUT FOR THIS GYM YET". TOP CONTROL / DISCIPLINES / BOXING overprinted: the
   attribute VBox added its theme separation the y-maths never counted (separation 0 now). The MARKS column
   overprint on the result: a fixed 21 px digit in an 18 px cell at eight rounds - sized to the cell now.

## Collected
**Q167 (Qwen) merged - and the data was wrong under a green test.** 81 of 88 punches were timed on a FOOT
(the tagger chose the bone that moved most over all four limbs) and `start` was one sample before contact.
Fixed in the tool (effector within the technique's limb; start walks back from the fastest frame); re-run:
punch wind-up median 0.10 s, **NO_RETURN 20 of 124, not 41** - half the "limbs never return" finding was
the artefact. `clip_phases_data_test` now checks the limb and the wind-up (old data fails 3 of 7).
**S65's "no ground game was mostly the screen" is RETRACTED.** Q166's probe drove `FightBeatAdapter` with
its default (grapple beats off); the live room has passed `grapple_beats: true` since S6 (`770aa536`,
2026-09-17), so take three already showed every grapple beat. Seed 92012 does not ground; that is why.
C190 (Codex) step 0 on current master: live ankle 31.8/34.8 m/s (S65: 52.8/75.2), engine_positions off
5.6/6.7 - still running. U159 (Cursor) running its tier.

## Assigned
Qwen: Q166 round 3 - why more ground time finishes 14 of 16 fights (J20 D4: ~51% decisions), census on
both trees, fix the rate that is off, then re-pin.

## Gates
`tests/result_screen_why_test.gd` (new): 26 checks on two real-time MMA bouts (grappler vs striker, named in
the file), a burst log and the ledger - **8 of 8 mutants caught** (per-blow fold off 10 fails, span clock 4,
significance filter 1, PostFightRead consensus 1, ScorecardRead consensus 1, knockdown stamp 2, ledger $0 1,
label back to the gym 1). Two mutants were first MISSED and the test was tightened: every blow in both bouts
was significant (a synthetic clinch blow now proves the filter), and the knockdown mutant zeroed only the
side that had none. Focused tier (reads, realtime, result, profile, hub, career walk, clip phases) 23/0.
Re-walk (`tools/s64_career_walk.gd`, gym-hub route, boxing starter vs board opponent, 8 rounds): result and
profile seen fixed on screen. Seen on the walk and fixed AFTER it (not yet re-walked): cause lines said
"Fighter A/B" (the real-time read state carried no names), THE RANGE said "no band" (`band` vs `range_band`
again), the gym note clipped, digits sat low in their cells.
**Still visible and not this stage's:** KNOCKDOWNS 0-0 beside five 10-8 rounds - the screen now SHOWS the
engine's 10-8-without-a-knockdown (Qwen Q164, queued behind Q166). WEEKLY PAY $0 against a $1,041 market on
the profile; the weight flag and CUT button on an unbooked fighter; the record line clips at "- FI".

## The operator's verdict on take three (VERBATIM, 2026-09-24)
"This video is much better I see still some moves are being executed extremely fast like uh, elbows I think and when
the hands like class but not uh, during the moving animation there is some uh, weird uh, hand movement let's say
They're still clipping, but it's much, much better than everything else. I've seen so far. Keep working on it. It's
still needs a lot. But you're, I think you are on the right uh, path now."
Routed: (1) too fast, elbows + (2) hands while moving / clashing -> **Cursor U160** (lead: `_kick_playback` caps
kicks and knees only - elbows and punches get neither the wind-up floor nor the tempo cap). (3) clipping -> **Codex
next after C190, ahead of C188** (the watch loop's rule: the operator's flagged items first; G86 says physics does
not fix clipping). Codex C190 relaunched as a continuation after the credit limit was lifted.

## Operator direction: TRAPS (VERBATIM, 2026-09-24)
"I think we should use the word trap to resolve critical moments in the fight. Be a factor in the submission event
should be associated How other events like grappling maybe maybe we should do it proper study and find ways to deepen
the decision making of the fighter the logic Transition of moves I also want your opinion on that"
Today "trap" exists only as a fight-offer verdict (TRAP) and one catalogue move (`arnis_empty_hand_trap`); the engine
has no trap state - a submission opens on N held ticks and finishes on a flat per-tick roll. Lead's opinion: build a
TRAP as an engine STATE on top of GroundGraph (S58) - a control won at a cost, which gates finishes and forces the
defender into a dilemma - calibrated to J20 D4/D6. Study assigned: **Grok G72** (`G72 - TRAPS`), in parallel with G71.
Also the operator approved the MANAGER CONTRACT (research G71) and asked for a hoverable BODY MAP on the profile.

## Integration suite (read off the run, tree `81516776` = S66 + C190 + U159 merged)
**`SUITE total=380 fails=10`** - the nine documented reds (athlete_development, capsule_coverage_contract,
fight_body_overlap, fight_metres [contention hang, passes alone], fight_pair_live [PARKED], fight_scoring,
fight_stage_realism, fighter_reachability_contract, weight_cut) **plus `c168_endpoint_contract_test`: NEW, and not
S66's.** Control arm: reverting only `PairedStagePlayer.gd` + `FightPoseSolver.gd` to `6e396dbd` gives `failures=0`
(from 1928/7720, signed error 0.2203 m). The one commit on both since S65's suite is **U157 `71c4ba0c`**, merged late in
S65 after its suite ran (verified by a tier only). -> Cursor U161 (queued behind U160 round 3).

## Agent state at handover (S67 collects)
- **Uncollected, verified in shape, NOT merged** (the suite had run; S67's integration takes them): Qwen Q166 round 4
  `12b69831` (skill direction fixed; subs 17.5% Pop A on the anchor), Qwen **Q164** `6cc84e11` (delivered in S64 and
  never collected: boxing 10-8 without knockdown 24.3% -> 0.4% via the damage gate; its note says margin 6->10 but the
  value is 15 - fix the note), Cursor U160 round 2 `d44c0c19` (take-four ON: worst kick 6.3x -> 2.54x; jab-lowkick gets
  the kick cap by effector).
- **Running:** Codex C191 (clipping census), Cursor U160 round 3 (the 4.64x elbow `karate_empiuchi`, the walk-boundary
  hand jump), Qwen Q168 (submission baseline for TRAPS), Grok G71 (manager contract) and G72 (traps).

## The operator's follow-ups, VERBATIM (2026-09-24), and what they started
"I am concerned why trap was not caught and found on earlier surveys as a necessary term in the game. Are, are we
missing something? And how how is this going to be linked to the training and the moves? That's interesting to see."
Answer given: the surveys calibrated OUTCOMES (J20, R133, the censuses), never CAUSES - an engine can match every anchor
with dice (Q166 r3 did). -> **Grok G73 "THE MECHANISM AUDIT"** (sent): every real cause-and-effect chain, which the engine
models, the top five missing. Training link (the TRAPS stage's design brief): a trap is a CATALOGUE technique (learned,
levelled by reps and by use), the finish it opens lists it as a prerequisite, escapes (trap-and-roll) are the defender's
traps drilled in camp against a scouted opponent, the fight plan's control priority sets traps more often, and the
result screen names it ("trapped the arm from mount, took the kimura").
"Do we have lateral uh, movements, like sidestepping, animations and things like that?" - Yes: intents close / hold /
retreat / CIRCLE (`FightIntent.gd`), `loc_strafe_left/right` + four diagonals bound (H2H WalkLeft/Right, in place).
Not bound: H2H Turn90/180. MISSING: a pivot / angle step off the line, an evasive side-step, cutting off the ring as a
decision - put into G73's audit.

## The operator on rival gyms and gym income (VERBATIM, 2026-09-24) - two rulings
"How is the rival gym uh, mechanic works? And how, how uh, can we link uh, income according to the equipment on the gym?
Like it attracts that many the current equipment attract that many customers. So the gym has income from that. And the
motive to put more equipment and expand the gym uh, ability to train more fighters."
Found: `Membership.natural_members` already counts equipment (3 members per item, rooms, tiers, reputation), but the
count was FROZEN by the operator's 2026-09-07 ruling (`weekly_drift_fraction` 0) - equipment earned $0. Rival gyms only
poach; they never compete for members or invest (facility_quality fixed at generation). No roster cap exists; station
capacity limits training slots.
**RULING 1 (AskUserQuestion): "Unfreeze now"** - reverses 2026-09-07; done in S67 as a data edit (0 -> 0.25).
**RULING 2: the gym market goes AFTER the body map** - S67 contract, S68 body map, S69 gym market. Research Grok G74 sent.
