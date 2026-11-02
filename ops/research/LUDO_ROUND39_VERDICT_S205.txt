# Ludo round 39 - Section 1 verdict (the 3D "loadout" fighter profile) - S205

Source: `LUDO_ROUND39_S205_reply1.txt` (27.9k chars, verbatim). Producer's idea: Phoenix Point-style screen - 3D fighter in the
centre, biometrics left, technique tree right, click a technique and the fighter performs it.

## Ludo's answer in one line
**ADAPT, not adopt.** A pure RPG loadout screen (big model in the middle, small icons around it) starves a management sim of
data: FM-class players open a profile 40-80 times a session and need the 9 attributes readable in under 1.5 s. But seeing the
fighter throw the punch shows reach, stance and speed better than any number, so keep the 3D stage, inside a "tactical dossier".

## What Ludo proposes (1920x1080)
- **Quick look stays the 730 px right drawer** on the gym floor (fast, no scene change).
- **Full profile screen = 3 columns**: LEFT 540 px biometrics (height, reach, weight vs. limit, age, 9 attributes, body wear,
  condition, contract) | CENTRE 700 px 3D stage (fighter on a mat plinth, idle guard, drag to turn) | RIGHT 680 px technique tree.
- **Technique tree (boxing)**: 4 branches - straights, hooks, uppercuts, defence/evasion (+ footwork) - tiers with
  prerequisites (e.g. Stepping Double-Jab needs Stiff Jab 3 + Footwork 2). Click a node = the stage plays that move looped,
  camera framed per move class (front-3/4 straights, side hooks/uppercuts, low for body shots), slow-motion toggle.
- **The decisions this screen carries** (so it is never just a viewer): (1) hours per week on a technique, auto-routed to a
  free station, warns when the station is overbooked; (2) fight-plan weight per technique: PRIMARY / SITUATIONAL / SUPPRESSED;
  (3) COMPARE WITH OPPONENT (key C): the booked opponent's scouted ratings side by side, reach offset in plain words.

## My verdict (Claude) - ADOPT Ludo's ADAPT, with these corrections
1. **Demo scope (D27)**: the tree lists every boxing technique, but only C223-CERTIFIED moves play on the stage and can be
   trained in the demo; uncertified nodes show "coming in a later build" - no uncertified clip ever plays (they still clip).
2. **Reuse, don't rebuild**: the stage is the fight's own body + clips (FightStagePlayer, certified palette); the fight-plan
   weight writes into the existing fight-plan setup (FightPlanSetupPanel), not a second plan system; opponent numbers go
   through the new ScoutFidelity module (merged today) so the compare view shows only what scouting earned.
3. **Our stat names**: Ludo's prerequisites use invented stats ("Reflexes 75+"); map them to our 9 (POW TEC SPD STM CHN DEF
   FTW IQ CMP) before building.
4. **Order**: PROFILE2 (the r37 profile, Cursor running now) lands first; this becomes **PROFILE3**: the r37 screen gets
   the 700 px centre stage + the right-hand tree. Behind a switch, closed by a still from the game and your OK.
5. Pieces: PROFILE3A tree data + rules (pure, Arena); PROFILE3B the 3D stage SubViewport (Codex sol); PROFILE3C screen
   assembly + the 3 decisions (Cursor).

Sections 2 (our V3 HUD) and 3 (r38 animation follow-ups) are being written by Ludo now (continue sent).

## Update S205 (later) - Ludo round 40 on "what else should be shown" (LUDO_ROUND40_S205_profile.txt, 27.7k, asked with the
## real game facts sheet - Tools/ludo_facts.py - so the tree is now OUR 54 nodes / 7 branches, not invented ones)
- Header (all tabs): name, age, division vs limit, stance, frame | record, morale, composure state | contract, gym cut, expiry, ambition.
- OVERVIEW left: the 9 bars; trait chips (read-only in the demo); BOUT DOSSIER with scouting levels 0-3 (our ScoutFidelity module,
  merged today); acute fatigue / camp mileage. Centre: the 3D stage. Right: the 54-node tree with states locked / available /
  learning / mastered / not-in-this-build, + the assign-hours / fight-plan-weight / compare strip.
- MEDICAL tab: region wear, damage history, weight-cut ledger. TRAINING PLAN tab: station hours, sparring cadence.
- EMPTY STATES (no blank boxes): boxer breathing in guard on the plinth with "click a technique to preview"; the tree always drawn
  (T1 available, the rest locked with their requirements) + "ASSIGN FIRST DRILL"; unbooked = "NO BOUT - OPEN MATCHMAKER [M]";
  pristine body = "all 6 regions 0% - unrestricted workload".
- Claude: Ludo's example numbers ($450/wk stipend, 73.5 in reach, "COMPACT-HEAVY") are placeholders - every value must come from
  the sim; anything the sim lacks is left out, never faked (S202 rule). Mockups: docs/previews/s205_ludo_profile/ludo_profile_v2.png.
