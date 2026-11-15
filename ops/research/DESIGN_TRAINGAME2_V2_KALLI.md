# TRAINGAME2 v2 - rewrite the training week (Training K) as a DESIGN MAP that clears 6+ depth and 6+ general design

You are Kalli, the game designer. Two fresh critics scored TRAINGAME2 v1 below the owner's bar (S459: 6+ depth AND 6+
general design): John depth 5 / general 5 / play 6, Kalli (fresh) depth 4 / general 5 / play 4. Their full reviews are
ops/research/DESIGN_TRAINGAME2_CRITIC_JOHN_JOHN.md and ops/research/DESIGN_TRAINGAME2_CRITIC_KALLI_KALLI.md - read both,
then ops/research/TRAINGAME2_REAL_NUMBERS_S484.md (v1, the game's measured numbers) and the critic pack
(ops/research/CRITIC_PACK.md). Write v2 as a design map: the decisions in order, every option, what each changes, the
dominant-pick test, a bot probe to run, and a table of every menu it appears on and what each is wired to.

## Facts from the code (Claude checked them in S486; use them, do not re-guess)
1. A pad night is PadWeek.PAD_NIGHT_MINUTES = 240 drill units (game units, the scale of the old weekly lumps), split over
   the cards on that night. v1's three pad nights (Mon check hook, Wed body hook, Fri check hook) were each a FULL night on
   ONE card (tools/training_k_numbers.gd lines 76-81). So Friday's +7.5 (20.7 -> 28.2) already had the whole night: a
   different split cannot close the 1.8 gap to Usable 30; only another pad night can (Monday 23 in fight week). Say the
   real-minutes figure once, if you use it, and never mix units and minutes.
2. Words (one vocabulary, Data.LABEL / Attrs.LABEL): the ability is STAMINA; "Cardio" is only the body-chart GROUP
   (stamina + recovery, owner S431). FIGHT IQ, never "Ring IQ" (fixed in the code S486). Mornings name the ability they
   raise, from Attrs: Strength, Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure,
   Heart, Accuracy, Timing, Defence, Footwork, Inside fighting.
3. Fire share (FireLevel.GAME_SHARES): under 30 never, Usable 30-59 1 in 2, Sharp 60-84 3 in 4, Signature 85+ always.
4. The probe body: 70 kg IS a women's amateur class (IBA/England Boxing women: 48, 50, 52, 54, 57, 60, 63, 66, 70, 75, 81,
   81+). Keep the body; no names in the page body ("your boxer", "the test fighter"; names only in headers, owner S448).
5. Tiredness: v1's line was drawn, not measured. From a carried-in 40 the rule gives 47, 45, 51, 49, 54, 48, 40 through
   the week (Sunday rest -8). Overreached from 80: gains x0.6, injury risk x3 (critic pack 4.x); a load spike 1.5+ gives
   2-4x injury risk. The taper week keeps pads at half minutes and spars none (PadWeek).
6. The coach fills every night the player leaves empty (PadWeek.defaults); Standard between fights = 3 pad nights + 1
   sparring night; in camp Hard = 3 + 2.

## What v2 must answer (the critics' top items)
- The cost side: every extra pad night or Hard morning shown in tiredness and injury risk, so "pad the move nearest
  Usable" is a real trade, not a free pick. The dominant-pick test: does "always pad the nearest-to-Usable move" beat the
  coach's week by more than its tiredness costs? It must NOT always win.
- The readiness forecast: each night card says "+X mastery" and the move's tier by fight night ("Usable Fri 20" /
  "Usable Mon 23"), re-forecast as the player moves cards (PadWeek.project already forecasts; say what is new UI).
- What readiness buys: Usable fires 1 in 2, Sharp 3 in 4; the win value from a probe (the pack's measured one: Sharp
  over Usable = +2.8 wins in 100), never a drawn +1.5%.
- The play: anticipation across the week (Friday's night decides Saturday week's fight), a reward the player feels.

Scores and checks: mark every new number ESTIMATE; CHECK anything you cannot see in the pack.

End with **To reach 10/10** (most important first, buildable) and describe your 10/10 page (1920x1080). Plain words.
Save as your answer; Claude sends it to two fresh critics.
