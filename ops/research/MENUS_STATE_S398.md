# Menus state, S398 side session (2026-11-07) - branch claude/menus-to-8b-5fe49c

Successor of ops/research/MENUS_STATE_S397.md. Reports go to the S398 main session, which merges in order (after
Fighter profiles). Do not merge this branch yourself.

## Week page: v3 -> v8 on paper, then built
- Designer seat for v3: Cline plan mode (its draft was thin; kept: x-off, blue drop targets, ladder once, cost chips).
  Claude wrote v3-v8; from v5 the critics judged a 1920x1080 HTML mock-up (Edge headless, the game's fonts, numbers
  from the game's own tiredness model): docs/week_mock/ (week_v8.png, week_v8_pop.png, notes, html).
- Blind scores (fresh critic each): v3 7.0/7.0, v4 6.8/6.8, v5 6.8/6.9, v6 7.0/7.0, v7 6.8/7.0, v8 6.8/7.0. Stalled; the
  critics contradicted each other. S398 main session (design call, not the operator's): build v8, judge the built stills.
- Built: WeekBoard (new order and pieces), WeekCards.gd (tiles, cards, tired line, meter, totals, popover frame, goal
  bar), WeekPops.gd (the two popovers), WeekDay (head + evening card), DrillCard restyle, DrillTray head, BoutActs "weve"
  and drops on any evening. Rule change (approved in S397): WeekPhase.edit_eve + PadWeek.with_evenings/coach_nights,
  tests/evening_edits_test.gd. Stills: tools/week_still.gd (Week Saturday, both popovers, camp Week, camp Fight prep).
- Built-still scores, round w3 (fresh blind critics): Week 6.4 / 5.8 (the old page 5.5); Fight prep v1 6.4 / 6.3 (old 4).
  Their faults since fixed: cards not adding up to PLAN TOTALS in camp (camp multiplier, pads' camp drill, sparring's
  drill gains), the UNDRILLED stamp over names, clipped cap lines, the camp head overflowing 1920 (weeks strip), START
  HERE under the fold, unlabelled marks; Fight prep pills that repeat panels, three calls to "write the plan", no tale
  of the tape, empty space -> v2 (tale + WHAT YOUR PLAN SHOULD ANSWER with Write it per trait).

## Built rounds and the stop (main session's rule: stop after ~4 built rounds under 7, write the structural list)
| round | Week (2 fresh blind critics) | Fight prep |
|---|---|---|
| w3 | 6.4 / 5.8 | 6.4 / 6.3 (v1, agy draft) |
| w4 | 6.2 / 6.4 | 6.4 / 5.8 (v2, the operator's actionable rule) |
| w5 | 6.0 / 6.2 | 5.4 / 6.0 (move renders as pictures: lower - they carried nothing) |
| w6 | 6.2 / 6.4 | 5.4 / 6.2 (kind icons, corner line, chips) |
Old pages: Week 5.5, Fight prep 4. STOPPED at ~6.2 / ~6. What is left is structural:
- Fight prep: a real decision surface - the plan written ON this page (round by round, or a few tactic choices with
  their effect on the win chance), not free-text lines in another tab (ties to the Playbook Game plan hub, the brief's
  step 3, and rank 3's "lines compete"); the win chance as the headline with a Scout action beside it; the fighter's own
  attributes against the opponent's (bars, both portraits face to face) - after Fighter profiles lands; style-clash and
  stance rows with their own answers; each answer's own picture (the style A/B, ops/research/STYLE_AB_S398.md).
- Week: one focal point (the goal), fewer and larger numbers; fatigue once (the week bar + a red day number only when
  over the line); empty pads cards half height with a drag ghost; the popover anchored with a pointer, the goal row kept
  visible; the gauges (legs / scale / risk) clickable to what moves them; the coach's fix that reaches the target or says
  it cannot.

## Round-6 structural list (from MENUS_STATE_S397)
1 one mastery word (MoveMastery.word / LADDER) DONE; 2 fill near-empty pages OPEN; 3 one Enter label + Needs words DONE;
4 Overview radar vs bars WAITS for Fighter profiles (21 attributes reshape AttrBoard); 5 one FIXTURES list (Fixtures.gd)
DONE; 6 Playbook viewer only once picked DONE; 7 brush font only 28 px+ (UI.label) DONE; 8 Records "judged on fight
night" DONE; 9 Championships lit step "open now" DONE.

## First-hour critics' list (Rank 5, via the main session)
1 Fight prep rebuilt (FightPrep.gd; design draft agy, cut by Claude: no engine numbers) BUILT, not yet scored;
2 bout page: Accept/Pass on the title line, "Weight at risk" chip, win chance one number + range DONE (unscored);
3 walk-in card: shared ceiling said once, closest 4 perks, "Defence 65, now 57" DONE; 4 top bar: arrows, no red
NEEDS YOU while the guide runs DONE.

## Operator rules this session
- S398: "i do not want stupid and unecessary information to be displayed unless the player can really do something
  about it" (memory feedback_only_actionable_info_s398). Audit of every page by a fresh reviewer; cuts made: rail
  text, Overview radar + road pills + "Injuries: None", Championships met rings -> one Eligible line, Playbook ghost
  caption / blurbs / squares, Combos "no help" rows, Records weekly member lines + count, News footer, Rankings
  repeats, Roster "No table"/"No cut", the week review in Fixtures, People's member quotes, History totals strip and
  Rounds column, the weeks strip on Week and Fight prep (the operator was asked: words or remove; pending).
- S398: one word for the 0-100 scale: Fatigue ("+6 fatigue", "WEEK FATIGUE"); Tired only as a state word.
- Left for others: Money says "8 weeks below $0 closes the gym" vs the decided 4 (Money session); Home's "club this
  week" panel and stat-tick line (Rank 5's Home); new mh_staff_*.jpg need an editor import (PromoShot now guards null).

## Coordination
- Fighter profiles lands first; the Week bars draw labels from Data.LABEL / the preview (no stat list).
- Main session fixes the dayless-bout root cause in state code; this branch guards Fixtures.events and ProFights
  _table_card (main asked).
- PC: one Godot job at a time; the heat guard blocked most of the afternoon (five other Godot jobs).

## Hand-over (end of the S398 menus side session)
- Branch claude/menus-to-8b-5fe49c pushed at 80bd258d+ (origin/main merged); the S398 main session merges it (before
  Fighter profiles). Touched tests green (38, golden_path 0 failures); new: evening_edits_test, two_boxers_two_years_test.
- Money's signal-11 crash: its harness rebuilt pages hundreds of times in ONE frame (Godot's 32 MB deferred-call queue
  overflowed); the game runs a day per timer tick. Fixed in Money's harness (84b2ca41); regression test here.
- Next for menus: the structural list above (a decision surface on Fight prep with the win chance as headline +
  Scout; BoutRead.likely "about X%" once Fighter profiles lands; the fighter's attributes vs the opponent's; Week one
  focal point), the art-style A/B (STYLE_AB_S398.md), Overview after Fighter profiles. Critics as sonnet sub-agents
  (operator at 49% of the plan); stills tools/week_still.gd + tools/cut_pages_still.gd; Godot jobs through
  ops/Tools/godot_slot.py.
