# S361 digest (2026-11-02) - update 63: the week review as a reveal, she pushes back, a fight poster per bout

Lean commits: 5015885 (reveal), e7f3440 (reveal film), 64ad09b (push-back, trust, poster, fixes). Model: Opus 5.5.
Operator ruling acted on: Q-S294-86 "Yes, build them" (Miro top 5, verdict MIRO_TOP5_S357.md: 3 -> 2 -> 5, corner cap skipped).

## What now works
1. **Week review reveal** (scripts/rules/ReviewReveal.gd, WeekReview.gd). Rows land 0.12 s apart (0.08 s for two fighters), each
   bar filling as it lands. After a 0.45 s hold, the week's biggest surprise lands last on a yellow sticky note, tilted 1.5
   degrees, popping from 1.25x. Order: new injury (red) > new weapon > peak camp > ranking won or climbed > the biggest stat
   tick. A quiet week has no note. A click shows everything at once. `Injuries.new_this_week` feeds the injury.
2. **She pushes back** (scripts/rules/PushBack.gd + WeekTwist.ASKS). On some weeks her own ask takes the drawn twist card's
   place, so the week still holds one choice (Kalli's CORE3 warning against piling up picks). Each ask comes from who she is:
   - low discipline + a Hard morning -> ease off
   - confidence/temper 65+ or chases_stoppage/talks_when_ahead -> spar Friday
   - fades_late/clinches_when_tired -> roadwork
   - pressure fighter/slugger or loads_up/one_and_done -> heavy bag
   - a fatigue peak of 75+ -> Saturday off (asked first)

   An ask that would change nothing is never asked. Frequency runs from 60 % (coachability 0) to 20 % (coachability 100) of the
   weeks she has a reason. Her way = `heard` (+5); the plan = `overruled` (-5, x1.4 down to x0.7 by coachability). No answer
   = the coach keeps the plan. Cards speak in her words with {first} filled in (`WeekTwist.card_for`); no his/her.
3. **Morale is trust** (FighterProfile.TRUST/trust, LiveRound). PRIMARY SOURCE FINDING: before S361 nothing read morale.
   The verdict's "low morale already blunts the corner's calls" was untrue. Morale now scales what she takes in of every call
   and habit fix (Exchanges.uptake x trust): Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7. The fix_hold number shows it too.
   Measured (tests/trust_fight_test.gd, 120 nights, same seeds): vs Maria, Low 151 / Fired up 161 rounds won; vs Erin, 83 / 90.
   The Steady 55 vs Steady 70 control fights identical bouts.
4. **Fight poster** (scripts/ui/FightPoster.gd, assets/ui/halftone.gdshader). An old bill poster built from the bout: gym
   PRESENTS, AMATEUR BOXING in red, halftone headshots (the blue corner flipped to face red, dot size scaled to the picture,
   midtones lifted so a face in a dark ring reads), names in Bebas, VS in red, records and styles, the rules line and a
   ticket-stub date bar. The look is Maria's M32/M34 "B Fight poster". It is pinned on Home (250 px, tilted 1.8 degrees) from
   booking to fight night.
5. **Fixes (defects seen, fixed now)**: the review was narrower than a twist card's two 520 px buttons, so the stat gains hid
   under the scrollbar; the scroll now takes the widest row. On the whiteboard, the Pads/Combo dials shared a row with
   CONTINUE in camp week 2+ and ran the page past 1920 px (the S357 stills show it too); they now get their own row.

## Evidence
- Tests (exit 0, no script errors): review_reveal, push_back, trust_fight, golden_path, week_actual, week_twist, fighter_profile,
  plan_fight, corner_card, habit_fix, week_board_clarity, peak_camp, plan_test_it, balance_harness, injuries, perk_fight, week_opp.
  export.sh ran the full Lean list (see the build).
- Film + stills, opened by Claude, sent to him and on /review S361: docs/playtest/S361_review/review_reveal.mp4 (weeks 1-4:
  headlines "Conditioning up to 62", "NEW WEAPON: the uppercut", "...63", "NEW WEAPON: the check hook"),
  docs/playtest/S361_poster/{poster_full,poster_home,ask_whiteboard}_real.png.

## Decided (developer calls, why)
- An ask is a twist card, not a second weekly card. This reuses pick/lock/days/evenings and the morale hook, and keeps the
  week to one choice. "Once a week" in the verdict became "the weeks she has a reason, by coachability", so the twist variety
  he built in S356-S357 survives.
- I built the poster myself instead of handing it to an agent seat: the operator's S338 rule says agents do animations and
  Claude does mechanics + UI, and the poster is UI built from data (a shader + labels), not an art asset.
- Trust is a design value (playtest it). The sources (Jowett's coach-athlete relationship; Mageau & Vallerand 2003 on
  autonomy-supportive coaching) are cited in the code.

## Agents
- Ziva TASK_ZIVAFOOT1 (wt/ZIVA_LEAN, branch ziva/footwork1): still running. Its scratch tools/_join_dbg.gd awaited `p.ready`
  after add_child (already emitted), so its run hung for 27 min. I killed it by PID (58976) to free its tool call. Nothing
  is on the branch yet.
- No other seat ran: every item this stage was mechanics/UI (operator S338 rule).

## Not done
- Miro production map not moved this session (context hand-over at 342k).
- Next: collect ZIVAFOOT1; split WeekBoard.gd (490 lines); belt road v3; Tips cards.

## HANDOFF
Next session: S362. Start `git pull && python Tools/agent_comms.py start`, then E:\FightCamp\Lean NEXT_SESSION_PROMPT.md.
