# IDEA - corner shouts the fighter LEARNS in training (operator S249, 2026-10-18)

## The operator's words (verbatim)
"idea : during the corner at a fight you can shout a command every 25s (stay behind the jab e.g) these things you complete for your
during the trainiing bars feeling in real time as the fighter learns them , also being able to see(hear) what the opponent does and
prepare your next command(shout) options that are not fully learned by the fighter might be risky etc"

## What it means (Claude's reading, to confirm with Ludo)
1. During a bout the player shouts a command from the corner about every 25 s (e.g. "stay behind the jab").
2. The commands are LEARNED in the gym: each one has a training bar that fills in real time while the fighter drills it.
3. The player sees/hears what the opponent is doing and prepares the next shout from his options.
4. A command the fighter has not fully learned is RISKY: he may execute it badly or not at all.

## What already exists (do not rebuild)
- `Godot/scripts/rules/ApronShouts.gd` (LUDO-R17-MATH1, TASK_SHOUT1A/1B): mid-round apron shouts, data table
  `assets/data/apron_shouts.json`, cooldown 22 s, max 3 per round; switch `ludo_shouts` is in GAME_ON; HUD `LudoShoutBar.gd`;
  FightRealtime `_shout_queue`, SHOUT_* durations (lateral 2 s, body bias 20 s), own RNG stream SEED_SHOUT.
- FIGHTLINK (operator S248 "Go"): move MASTERY tiers Raw/Usable/Sharp/Signature from pad/bag/sparring hours (FIGHTLINK2, Arena
  building MoveMastery.gd) - the same learning curve fits shouts: a shout = a learned tactic with its own mastery bar.
- FIGHTLINK step 1 (aaed6910): the fight log now carries why-lines ("Reyes slips Perez's double jab") - the "hear what the
  opponent does" input exists as data.
- Corner report between rounds (FIGHTLINK step 4, Ludo r116 B2 asked).

## Where it fits
Extends FIGHTLINK (training -> fight) - it answers the operator's main concern from Q-S246-4 ("how all the training is translated
to the fight"). Order: after mastery (FIGHTLINK2) is wired, because shout learning reuses the mastery tier mechanism.

## Next step (D39 LUDO FIRST)
Ask Ludo (r117, after collecting r116): shout list for boxing, how each shout is learned (which station, hours per tier), the
execution chance per tier (risk of an unlearned call), the 25 s rhythm vs today's 22 s cooldown/3 per round, what the player sees
of the opponent to choose the next shout, and the HUD. Claude turns it into a verdict; the operator approves the verdict on the
board before anything is built.
