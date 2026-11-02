# K86 - what the day-goal plate on the gym floor should say (Kalli, S231)

FightCamp is a PC boxing-gym management sim (Football Manager depth). On the gym floor, top-left under the fighter's
name, stamina and strain bars, the game shows two small "day goal" lines with icons, for example:
  [icon] Stamina above 30 at the bell     (an orange underline bar under it)
  [icon] Jab usable by Friday             (a black underline bar under it)
The CEO looked at it and wrote: "no clue wtf is this".

What the system is: each training day the coach sets up to two goals for the selected fighter. "Stamina above 30 at the
bell" = finish the day's last block with stamina >= 30 (you manage it by picking intensity cards: POWER THROUGH +30%
gains, burns 25% more; CRISP FORM +35% card drill; PACE YOURSELF -25% gains, saves 40% drain). "Jab usable by Friday" =
the jab technique reaches its usable stage before the week ends (drilled at the matching station). The underline is the
progress bar. Meeting a goal gives a small morale / coach-trust bonus.

Answer (concrete, buildable, no new mechanics):
1. The exact words for a header and each goal line so a first-time player understands it with no tutorial
   (max ~40 characters per line), including what the reward is.
2. How progress reads (bar, numbers, ticks) and what changes when a goal is met or failed.
3. Where it sits and when it shows (always, or only while a goal is live).
4. Should it stay in the demo or be cut - one sentence why.
5. A first-hour click path (8-10 steps) using only mechanics already on, in which this plate is understood.
