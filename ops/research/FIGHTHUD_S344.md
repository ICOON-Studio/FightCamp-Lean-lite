# FIGHTHUD2 - beat the UFC 6 fight HUD (S344)

Operator S344: "gotta beat this, check what 6 stats they show on the fight" (youtube 7I_jixI6Y6o, EA UFC 6 ground guide).
Read with eyes (frames 0:31, 1:50-1:55 zoom, 6:58; narration 1:50 and 6:56). Picture: img/ufc6_hud_s344.jpg.

## What UFC 6 shows, per fighter (top corners, bars + icons, no numbers)
1. Shield icon, white bar - the block / guard meter (not named in the video).
2. Head icon, green bar - head health; a grey end is damage that stays.
3. Torso icon, green bar - body health.
4. Leg icon, green bar split in two lines - the two legs.
5. Lightning icon, yellow bar - stamina; the grey end is stamina lost for the fight. Narration 1:50: "every time you deny
   a transition it goes down"; 7:27 "body strikes drain stamina, head strikes do damage".
6. White flag icon, purple bar under the name - not named in the video; the flag reads as tap-out / will to go on.
Plus a 7th in the middle top: the grapple advantage tick meter (6:57 "shows who has a grapple advantage").

## Ours today (FightHud.gd)
Text block: ROUND 2 OF 3 2:46, EXCHANGES WON 0-0, an energy bar + "ENERGY 82", "BODY TAKEN 4"; the body figures each side
with FRESH/WARM/HOT/BURNING and LANDED/JABS/POWER/BODY numbers. More text than bars.

## The plan to beat it (Claude decides, operator approves)
Same six, boxing-true, each one tied to something the player DOES:
1. HEAD - head damage (BodyMap head/eyes/nose); the grey end never comes back this fight (cuts, swelling).
2. BODY - body shots taken (ribs); every body shot also greys a slice off the end of her stamina, and both bars flash
   together so the player SEES why body work pays.
3. LEGS - two lines, lead and rear: her legs go when she is tired or hurt; low legs = slower steps, she cannot cut the ring.
4. STAMINA - our energy; the grey end is gone for the fight.
5. GUARD - how high her hands stay; it sinks as her arms tire. That is the tell you SPOT in the tape room (TELLS1): when her
   guard bar sinks the corner's shout lights "Over the top!".
6. HEART - how far she is from quitting (Heart attribute, knockdowns, hurt moments).
Middle top: ROUND EDGE - a tick meter of who is winning this round (exchanges won, the judges' lean), like their advantage bar.
What beats theirs:
- The opponent's GUARD and HEART show "?" until scouting found them (tape room / her file) - the HUD shows what your
  homework bought you. UFC shows everything to everybody.
- Every bar tweens and pulses on change (operator: animated meters); the body figure lights where the punch landed.
- No numbers on screen; numbers live in the tooltip and the round page.
