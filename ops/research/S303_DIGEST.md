# S303 digest (2026-10-29) - combo energy on real numbers, combo words, the corner card

Work in E:\FightCamp\Lean (defe340, f3bb35a, f35e1b9); Game 8e8bfc1b (seat answers).

## What now works
- ENERGY ON SOURCED NUMBERS (John J-COMBOENERGY1, SQ16). Primary sources opened: Arseneau 2011 abstract (bag VO2 24.7 /
  30.4 / 38.3 at 60/120/180 a minute -> a combination-cadence punch costs 1.39x, derived), Martusciello 2025a full text
  (2023 women's world finals, 12 bouts, 3x3 min: winners 19.3/16.8/18.1 punches a minute, rear hand -19% in round 2,
  combinations 46.6% of actions). Davis 2014 is a 3x2-min semicontact study, paywalled per-round values - used for the
  shape only. Combos.gd: two-part tank (60% fast debt, 52% back each rest = Bogdanis 1995 PCr half-time 56.6 s, 40%
  stays), 0.10/s moving, punch 0.22, combo 0.22 x (1 + 1.39(n-1)), 54 punches a round, fitness 0.8-1.2 on the rest and
  1.2-0.8 on the spend; force/speed/timing hold to 20, combos ~30% shorter 70 -> 30, under 40 she may leave a combo
  unfinished. Bells for an average boxer 69/48/31 (John's target 68/46/29); golden path 100->71, 81->52, 66->37 (was 56
  at the last bell, so nobody tired).
- COMBO WORDS (Kalli K-COMBOWORDS1, SQ17) in assets/data/combo_words.json via rules/ComboWords.gd: ring caption when a
  SIGNATURE combo lands whole or a tired one is cut; coach line in the news when a combo turns usable / signature and on
  the Training combo row; corner energy line (fresh/tiring/empty). tools/combo_words_probe.gd: unfit boxer leaves 0.15
  combos a round unfinished in round 3; signature lines ~0.15 a round.
- CORNER CARD (FIGHT_MODEL step 5): rules/CornerCard.gd reads the beats the ring played (FightView sets r["card"]), so
  the card agrees with what was watched: WORKED, HURT, COACH (tired = calm; hurt by short punches = stay long;
  outworked at range = go to the body; else more of what worked); his pick marked on the button.
- DEFECT FIXED: the round's words said a pressure fighter "works both hands inside" while her jab did the landing -
  RoundStyle.from_opponent gave every style the same jab-first mix. Style now shapes it (ESTIMATE weights);
  round_style_test red on the old code, green now.

## Evidence
20/20 Lean tests (tools/run_tests.sh), export .pck (the .exe copy fails while his FightCamp.exe is open). Real stills on
the hidden desktop: S303_corner_energy.png, S303_corner_card.png (Lean Builds/review, 8787/review).

## Not done
- Cloud seats (Q-S294-6 "you fix both"): Tools/lite_mirror.py --lean is written and dry-run (261 files, 0.82 MB, no
  secrets, no models/clips/fonts) but uncommitted: the session's permission guard blocked writing the repo secret,
  creating the public repo, and committing an auto-push to it. The operator runs three commands.
- Combination share by round, combo cost by length and the interval under fatigue are unpublished (John's gaps).

## HANDOFF
Next: S304 per roadmap now.next_action (cloud seats if he ran the commands; his verdicts; FIGHT_MODEL step 6 film).
