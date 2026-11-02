# S230 DIGEST (2026-10-16) - gym floor playable push continued; nightly offer reds traced; Grok bots reachable again

Model: Opus 5.5. Stage handed over at 463k context (rule: 330k).

## What now works (all on master, pushed)
- FLOOR-PLAY 11 (9c695ab0) - Ludo r88 FloorVibe: every 40-90 day-minutes the floor has a moment - members praise him when the
  coach works with him (+1 gym reputation, max +2/day; apply_floor_effect learned "reputation"), a member claims a free station
  10-20 min, visitors (press/sponsor/coach scout/local) watch, the room's mood. Members on the floor = members x 0.20.
  Claude fix: Ludo's line/station pick read `roll` (always under the threshold) - a quiet gym only named 5 stations (test red on
  the draft, green on the fix). Tests floor_vibe 9/9, floor_vibe_floor (0-members + switch-OFF controls).
- FLOOR-PLAY 12 (69c36edc) - Ludo r89 Corner Check at the 200/400 block stop: badge over him ("PRIME FORM +0.4 TECHNIQUE") +
  the coach's line and a warning on the stop panel. Words only (Ludo's composure delta and "40% injury" number dropped).
  Ludo r89 = floor audit 3 (6 dead moments ranked) saved.
- FLOOR-PLAY 13 (a4c6060e) - Ludo r90: a claimed station asks LET MEMBER FINISH / COACH NEEDS STATION (first wave-off a day free,
  then -2 reputation, from the 4th -5 = Ludo's numbers, for the operator's approval) + POWER THROUGH strain warning under 45
  stamina. Fix: a click on a claimed station while he walked was queued unasked. Floor set 32/32 (--jobs 3).
- CORNERCALL1B merged by diff (9b6a123a, Arena PR #202 closed): every corner call MEASURED on real seeded forked fights (control
  exactly 0, mutant fails); Vaseline/water cards wired; seal protects next round; stool HR curve. 3-way merge with CORNERTAB1.
- VISUAL GATE block added to TASK_GLOBE2 / TASK_ROOMSROUTE1 (start flagged them).
- Grok bots reachable again (bcc4d269): `python Tools/gbot.py send|thread|list` -> Tools/grokbot_direct.mjs (box gateway,
  operator's Grok Bot plan). grok-bot-cli is dead; the xAI API key (xai-research.yml AND the cloud `grok` issue label) is out
  of credits (403) - board Q-S225-11.

## Nightly 10-16 (9d320fd5, 812 tests, 23 reds) - triage
- 8 offer/event reds (weight_cut, offer_desk, short_notice, event_night_backend, events_revamp_backend, game_training_split,
  fight_camp, amateur_offer_roundtrip) went red with S229's 1922a0cc (cards hold their org's sports): the paid boxing slot they
  booked was a boxing bout on the Cyprus MMA FEDERATION's card. Root cause: the real-organisation catalog has NO professional
  boxing promoter - every boxing body is a federation (no bookable paid slot), so a Cyprus/UK/Japan... boxing gym has no paid card.
  Fixtures fixed: fight_camp books a bookable boxing open slot (legal for his bout), amateur_offer_roundtrip reaches the open
  circuit from Georgia. Data fix = PROMOTERS1 (below). A tried code fix (federations never adopt the generated promotion) broke
  the "organisations are real" contract - reverted. Catalog v4 with 3 verified promoters also reverted (count pins + S5
  researched-ruleset contract need the full sourced rows).
- corner_instruction_contract (hook drifted after CORNERLIVE2) -> CORNERCONTRACT1 Grok Dev; fight_strike_whole (2 pins, same on
  master) -> STRIKEPIN1 Grok Dev.

## In flight (collect next session)
- LUDO r91 (project chat "LUDO ROUND 91", tab left open in Brave): paid fights abroad for a boxer from a market with no promoter
  (AwayCircuit.gd). Design verdict -> operator approval on the board before building.
- John PROMOTERS1B (Grok Bot plan): real promoters per market, official site + one recent show; `python Tools/gbot.py thread
  --to john --out f.json`. Dola's earlier answer saved raw (PROMOTERS1_DOLA_RAW_S230.txt) - only Matchroom, Queensberry,
  Top Rank verified by page title; the rest unverifiable (duplicate BoxRec ids, generic sources).
- Grok Dev STRIKEPIN1 (grok/strikepin1) + CORNERCONTRACT1 (grok/cornercontract1); Goose KICKREACH1 #194; Cursor UICARDS1 #201.

## Decisions (Claude, as developer)
- Ludo modules are integrated words-only where they invent numbers the engine owns (r86, r89, r90 strain).
- A promoter row ships only with an official URL checked by page title (COUNTRYDATA1B policy).
- Grok bots are driven through the box gateway, not the CLI; the cloud `grok` label stays off until the xAI key has credits.
