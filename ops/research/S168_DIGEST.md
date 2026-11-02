# S168 DIGEST - CARD1: THE CANDIDATE on the FM logic (cloud session, 2026-10-05)

## Request
Operator 2026-10-05 ("next session will be cloud session again", "go 2"): build CARD1 per `TASK_CARD1.md` - NAV1
slice 3 (D37), the K86 s5 coach + fighter wireframes, behind career switch `candidate_card_v2`.

## Change (03d48b54, behind `candidate_card_v2`, user arg `candidate_card_v2`; OFF in the game until his OK)
- NEW `Godot/scripts/CandidateCard.gd` (pure builder, `build(card, row, on_sign, on_decline, opts)`):
  - identity strip: portrait (fighter: `TaleOfTape.generated_portrait`; coach: initials ring), name, facts line
    (fighter: country · age · division women/men · record; coach: country · role coach · personality), one verdict
    sentence (fighter: band now / band ceiling + age read; coach: teacher band for the seat, tactics band).
  - ATTRIBUTES · SCALE 1-20 in two columns: 1-99 sheet -> ceil(v/5) clamped 1-20, band word + colour (Excellent green,
    Good text, Fair amber, Poor red) + a thin bar, a tooltip on each (meaning + the band table). Fighter: the six
    striking numbers of STAT_ORDER + Rating + Potential; coach: Teaching, Tactics, Youth work, Rating.
  - VS OUR GYM in sentences (empty seat / held by X at n/20, cover or upgrade; open locker / number n), payroll
    before -> after a week, coach places used.
  - THE ASK: "$976 a week for 15 weeks (about 3 months). $2,928 to sign." - "weeks" never bare; the affordability
    refusal says it in money too.
  - fighter ambition as a sentence (P6, from `Ambitions.ambition_label_for`), her/him by sex.
  - ONE gold verb (Sign coach / Sign fighter) beside Decline; Shortlist + Negotiate as quiet buttons (the drawer is
    kept, not re-implemented).
- `ScoutingHubPanel._build_candidate`: switch on -> `_build_candidate_v2` (frame sized to the card, so the Sign row
  ends at y 724, clear of the guide plate at 808); OFF path unchanged. `_on_card_sign` signs through the existing path:
  start_negotiation (if none) -> propose the candidate's own current ask -> `_on_sign` (finalize_negotiated_signing).
  A moved ask (open/accepted negotiation) is what the card shows. Built from the ONE get_candidate_card read per
  selection (the trap).
- `GameState`: `is_candidate_card_v2_on()` beside `is_gym_is_menu_on()`; `get_candidate_card` adds `ambition`
  (athlete) and `youth_development`, `capacity`, `personality` (staff) - additive keys.

## Verification
- `candidate_card_test` 42/0. Population: DevJump slot 9 seed 4242 week 6, 4 generated roster fighters; boxer Sofia
  Park (F, welterweight, 30, Cyprus, rating 34 / potential 55), coach Jae Williams (boxing, teaching 47 / tactics 41,
  Fearless). OFF control arm: no CandidateCard, old OPEN THE OFFER still drawn. ON (both cards): portrait, name,
  country, age + division (fighter) / role (coach), every attribute 1-20 + matching band word + tooltip, no bare
  "weeks", the ask in one sentence, exactly one gold button reading SIGN FIGHTER / SIGN COACH, Decline, verdict,
  vs-gym, ambition sentence; guide plate (1478,808 420x250) vs Sign (1604,684 278x40) - no overlap; Sign coach hires
  Jae Williams (staff 1 -> 2, cash 16,918 -> 15,378), no negotiation left open.
- Red on the shipped tree: 7 FAIL (switch missing, no card, no Sign). Mutants: switch forced off -> red; band table
  shifted (Good from 10) -> red.
- Neighbours 9/9 green: `run_tests.py --only candidate,scouting,staff_hub,first_job,tutorial,gym_menu --jobs 3`.

## Owed (PC)
- Stills of both cards on the game camera (as_game, `candidate_card_v2`) + the first-ten-minutes video with
  timeline_bar + gym_is_menu + candidate_card_v2, opened by Claude, then the operator's OK. Coaches carry no age in
  the world data, so the coach strip shows the personality instead.
- The .uid sidecars for the two new scripts are written by the next editor/import pass on the PC.

## Delegation
None: cloud session, no browser pane or shell seats (operator S167: "leave the video, gbot and Arena for the PC").

Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/candidate_card_test.gd`
