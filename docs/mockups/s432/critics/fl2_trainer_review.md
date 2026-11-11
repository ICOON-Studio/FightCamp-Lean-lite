# FIGHTLINK3 map v2 (S432) - review by a boxing trainer (fresh, blind)

Read: CRITIC_PACK, CRITIC_ACCESS, `ops/research/FIGHT_LINK_MAP_S432.md` (whole), `docs/mockups/s432/fightlink_v2.png`, the real result screen
`critic_pack/screens/21_result_real.png`, and the code: LiveRound.exchange / open / close, RingDuel (form, step, settle), Exchanges (EDGE, settle,
round_of, call_edge, uptake), BoutRules (PROTOCOLS, stale_energy, night_edge, scorecards, why, weapons_edge), BoutNight (_peak, _energy, _finish),
Attrs (of, from_stats, _punches), AttrGen (_attrs_build), Data (START_MOVE_SHARE, fighter_state), Duels (TOOLS, K and the dials), Knockdowns
(constants), Bouts.start_camp, FightWhy (outline). Neighbour maps only by their headings (CLUBWEEK v4.1, TRAINING, RPG). Nothing was run.

## Score: depth 6.5 / 10

One line: the best diagnosis of the fight this project has had, and the receipt (THE SCALES) is right; but most of it is a way to READ the fight,
not new things to DECIDE before it, and two holes in the code that sit right on the week-to-fight link were missed.

## How the build reaches the fight today (my own trace, where it adds to the map)
The map's table in section 2 is accurate where I checked it (EX_SPREAD 66, FORM_SD 5 fixed for the bout, call edge 17 / 5 / -10, HABIT_BOUT 1.75,
NO_CAMP_EDGE -1.5, the scorecards made from rounds won, the canned "conditioning held up" line, uppercut and check hook starting at 0). Three things
it does not say:
1. **No camp = no Legs.** `BoutRules.stale_energy` returns 0 when `camp.protocol < 1` (BoutNight._peak reads it). So an amateur bout with no
   camp (the S428 default) pays NO tank cost for a hard week, while it pays -1.5 on every exchange for "no camp" (night_edge). The week's best link
   to the fight is switched off on the main amateur path, and the penalty that replaced it is a flat tax the player cannot avoid. The map names the
   second half (defect 4) but builds its LEGS row and M6 on `stale_energy`, which reads zero there. CLUBWEEK's new Legs bar must replace
   stale_energy on every bout, and the scales' LEGS row must read that, or the row is always empty for amateurs.
2. **The punch gap is the whole set, not just the uppercut.** A signed fighter's punch levels are mastery (Data.START_MOVE_SHARE: jab 0.85,
   cross 0.75, lead and body hook 0.62 / 0.5, uppercut and check hook 0 of Technique). `Attrs.from_stats` sets no punch levels, so the duel reads
   those. Every opponent gets all four punches at its rating (AttrGen._attrs_build -> Attrs.lay). At Technique 60 against a rating-58 opponent:
   jab 51 v 58, straight 45 v 58, hooks 34 v 58, uppercut 1 v 58. The pocket and inside start lost before a week is trained. That is why the pads are
   the biggest lever, and it is a good lever; but it is hidden, and it makes the first offers harder than the shown stats say (the shown chance does
   include it, the seven-stat rows do not). PUNCHFLOOR1 must cover all four punches and the three-places strip must show it from day 0.
3. **The corner outweighs the build, by constant.** A right call is EDGE 17 x can-do (1.0 Good / 0.6 OK / 0.3 Poor) x uptake (0.7-1.0) x trust, and
   the minute's call keeps working every exchange of the round (LiveRound uses `lv["plan"]` when nothing is shouted). A whole fighter 5 points better
   is +5 (Duels K 0.5). One right call is worth two to three times the build gap on every exchange it fits. The can-do grade does tie it to the
   build (good), but the map never sets how much of a result the night should own against the weeks. A trainer's rule: the preparation wins
   fights, the corner saves close ones. Without a target, LEVERS1 measures but nothing is gated.

## What is good
- THE SCALES replays every exchange on the same dice with a group taken out: the honest answer to "which of my choices won or lost it", and it
  extends `plan_swing`, which already works. One button per row that IS the next decision is exactly how a corner reviews a fight.
- THE JUDGES: scoring from clean punches, big shots and ring control, a count as 10-8, one reason per card. Fixes a real lie on the shipped result
  (Lucy won 10 of 18 exchanges, out-landed 61 to 56 and lost all three cards with no reason).
- THE THREE PLACES strip with the punch against the answer, by number ("hooks 41 v guard 61"), and what moves it by Saturday: this is how a
  trainer reads a matchup.
- LINES THAT SUIT: the step back is right for the boxer who wins at range and wrong for the slugger. The build finally shapes the plan.
- THE NIGHT, EARNED: form halved and moved by the fight week, mood, the scale and ring rust, shown before the bell, named after.
- The cut rule (1.5 in 100) applied to the camp night edge, the weapons count and peak camp: removes decoration instead of dressing it.
- Every size waits for its probe; populations named; control arm first. Defects listed before mechanics.
- BJJ gets the same receipt (M11).

## Missing options (each changes something)
1. **Throw the towel / pull them out at the corner minute.** The trainer's hardest call on the night, and it is tied to the build: a stoppage loss
   lowers the durability ceiling for good (Attrs.wear_stoppage, -2 each) and brings the 30-day suspension. Today the player cannot trade a loss
   for the fighter's future. The agreed cutman card (stop it / go on) is one case of it.
2. **Sparring someone who fights like the opponent, for amateurs.** With no camp on amateur bouts, the outside partner and the southpaw mate are
   gone from the main path, and WeekOpp (weeks spent on the opponent's game) has no amateur source. One sparring night "as Priya" with a club mate
   whose style matches (CLUBWEEK SparSet / TRAINING T4 own the night) should feed WeekOpp, open one tell, and remove the never-faced-a-southpaw
   cost.
3. **Whether the coach knows tonight's officials.** Showing all three judges' leans at the weigh-in is knowledge a club coach earns (local
   officials). Make it read through the coach (Known / coach level / the Ex-pro edge): known leans shown, unknown "?". Then the aim pick is a read,
   not a lookup.
4. **Stoppage risk on the aim.** WALK THEM DOWN costs 4 of guard; its price line must say what that does to the count chance against this puncher
   (power v chin), not only the place shares.
5. **A row for "ready for their style".** The parts list stores WeekOpp, the lefty week, the stance edge and the fade, but the group table puts none
   of them in a row; PARTS1 will sum and the player will not see where they went.

## Useless or weak as drawn
- "Small things: perks, film, the clinch +1 exch": folding perks into small things hides the RPG layer's rewards. A perk or a trait that fired
  gets a chip with its number (Heart beat the count, Counter sense x2) even when small.
- WHO THEY ARE split at 28 days ("the build gap" = everything before last month) blames "who they are" for what the player trained in weeks 1 to 5.
  Split at signing: SINCE YOU SIGNED (yours) against THE GAP YOU SIGNED (talent).
- The WORK lean is a professional idea (effective aggression). Amateur scoring is quality blows, domination, competitiveness. Keep WORK for pro
  bouts; give amateur panels CLEAN and RING (or call the third "initiative" and score it from forward exchanges won).
- The result page as drawn has eight rows, three judges, three places, a quote and the Why: two headlines say the same thing ("IT TURNED ON" and the
  Why). Keep the headline in the first row's highlight and the Why as one line.

## New mechanics (only where decisions are thin without them)
- THE TOWEL (corner minute, only when the fighter is hurt at the bell, has taken a count, or head damage is past the critical band): Pull them
  out = loss by retirement, no durability cap loss, suspension halved, morale -4 and loyalty +1 (the RPG bond); Keep going = the shown stoppage
  risk for the next round. Shown as "stoppage risk next round: 1 in 9" from Knockdowns (power v chin, damage, heart). Probe TOWEL1: a bot that
  pulls at risk over 1 in 4 keeps more season wins (through the durability ceiling) than one that never pulls, on 600 careers.
- MATCHUP SPARRING (the fight week's sparring night, owned by CLUBWEEK / TRAINING, sized here): a club mate "as <opponent>" gives WeekOpp on the
  opponent's main game, one tell and the southpaw answer; costs that mate's night and the spar injury roll. Probe SPARAS1 on the played bout.

## To reach 10/10 (most important first, each buildable)
1. Fix the two missed code holes with the listed defects: (a) every bout reads the Legs (CLUBWEEK's bar) instead of `stale_energy`, which is zero
   without a camp; NO_CAMP_EDGE goes from amateur bouts in the same task (NOCAMP1 widened, one probe before and after on 400 amateur bouts);
   (b) PUNCHFLOOR1 covers all four punches (jab, straight, hooks, uppercut) against AttrGen's rating-level punches, with the strip showing the
   gap from the first offer.
2. Set the target before LEVERS1 runs: over a season, the preparation groups (week, pads, sparring, since signing) explain at least 55 of 100
   turned exchanges and the night (shouts, minute, aim) at most 30. If the corner's 17 breaks it, scale EDGE best down or tie more of it to the
   can-do grade (Fight IQ and the punch the call needs). The Handbook says this ratio in plain words.
3. Scales for stoppages: a THE COUNT card (power v chin, head damage carried in and which exchanges put it there, heart at the count), and the
   replay re-rolls the counts on the same seed with each group out, so "without the open habit, no count in round 2" can be said.
4. THE TOWEL in the corner minute, with the stoppage risk shown and the durability ceiling named as what it protects (probe TOWEL1).
5. Every stored part sits in a row: add READY FOR THEIR STYLE (WeekOpp, lefty week, stance edge) to YOUR WEEK; fade and talk to their groups;
   PARTS1 also asserts each part has a group.
6. Split the build at signing: store a signing snapshot of the 14 abilities and the punch levels; rows SINCE YOU SIGNED and LAST 4 WEEKS (yours),
   THE GAP YOU SIGNED (theirs). The Monday review sums "what you made of Lucy" from it.
7. Matchup sparring for amateur bouts (hook into CLUBWEEK SparSet / TRAINING T4), feeding WeekOpp, one tell and the southpaw answer (SPARAS1).
8. Officials known through the coach: leans shown only for the judges the coach knows (coach level / Known / Ex-pro), the rest "?"; amateur
   panels use CLEAN and RING, WORK only in pro bouts.
9. Perks and traits that fired get their own chips with numbers on the result and in the round report (never folded into "small things").
10. The bill before the fight shows the same groups and rows as a forecast ("on the bill"), and the result shows the forecast beside what
    happened, so the player learns to read their own prep (drawing: `fl2_trainer_10.png`).
11. The result page: the first row carries the headline; at most eight rows with the rest folded; the Why as one line; "who decides this
    fighter's fights" (season shares by group) on the result and the Character tab.
12. The golden-path test adds a no-camp amateur bout (asserts a non-zero LEGS row after a hard week) and a bout with a count (asserts THE COUNT
    names power, chin and damage).

## Complete for this version?
Yes, with the list applied. Four fighters, amateur bouts with no camp, the first pro fight and Ana's opens all get the same chain: the week sets
the Legs, the punches and readiness; the three places show the matchup; the plan suits the fighter; the aim and the towel are the night's
decisions; the judges and the scales say what turned it, and every row's button is next week's first move. Without items 1 and 3 it is not:
the main amateur path would show an empty LEGS row and a stopped fight would have no reason.

Drawing: `docs/mockups/s432/critics/fl2_trainer_10.png` (the result page: on the bill against tonight, the build split at signing, sparring
"as Priya", the count, the officials the coach knew, the towel's minute, who decides this fighter's fights over five bouts).
