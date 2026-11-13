# LIVERRIBS1 - the liver and the ribs do different things (design map v1, S460)

His answer, Q-S294-219 (S460 board): "Yes: liver = stamina drain + a knockdown chance when hurt, ribs = the injury place
(cracked rib, weeks out). Design map + critics first".

## Today (read in the code, S460)
- Only `body_hook` reaches a rib. The defender's liver side takes 60 in 100 of them (BodyMap.LIVER_SHARE), her right ribs
  when orthodox, her left when southpaw (BodyMap.gd:76-83).
- Every body shot taken costs the same stamina whatever the side (Exchanges.BODY_COST 1.2, scaled by her body stat,
  Exchanges.gd:35-45; FightMeters caps her tank by body_taken). The "hurt" line is the same on both sides (BodyMap.band).
- Knockdowns read HEAD damage only (Knockdowns.gd: DAMAGE_SCALE, KO_DAMAGE). A body punch never drops anyone.
- After the bout InjuryRoll draws ONE "Rib injury" (weight 10, x3 when a rib place is under 35; 21-35 days), the same for
  either side (InjuryRoll.gd BOUT_TYPES, RIB_HURT_LINE).
- The holo already names the sides "liver" and "ribs" (RoundHits.WORDS), so the player sees two places that act the same.

## The change in one line
The LIVER wins you tonight (her tank drains faster, and once it is hurt a hook can drop her). The RIBS cost her weeks (a
bruised or cracked rib after the bout, and a rib can crack DURING the bout - which hands the corner a real decision).

## Rules
| # | Rule | Numbers (TUNE range) | Real-world basis |
|---|---|---|---|
| 1 | Body stamina by side: a landed liver shot costs BODY_COST x LIVER_DRAIN, a rib shot x RIB_DRAIN. Chosen so 60/40 traffic costs what it costs today (no rebalance of the tank) | LIVER_DRAIN 1.3 (1.2-1.5), RIB_DRAIN 0.55 (0.4-0.7): 0.6x1.3 + 0.4x0.55 = 1.0 | A liver shot sets off a vagal reflex (blood pressure falls, legs go); a rib shot hurts but does not shut the body down |
| 2 | LIVER HURT knockdown: once her liver place is at HURT or worse (BodyMap band), each landed liver hook rolls a delayed fold | 3% x e^((his power - her Durability)/12), clamp 1-8%; x2 at CRITICAL; at most 2 a bout | Liver knockdowns come a beat late and are often full counts (fighter folds, cannot rise) |
| 3 | A liver knockdown is a body count: she rises at 8 or is counted out; her legs bar drops 25 for the round (the 3D shows a fold, not a fall back) | count-out share 35% (25-45%) vs 15% for a head knockdown today | Body knockouts are counted out far more often than head knockdowns (pain, not a blackout) |
| 4 | The S437 FRESH liver counter stays: a counter's left-hand body hook can drop a fresh fighter (0.6%, x2 on her Push, cap 3%, once a bout) | as DAMAGE_MAP_S437 row 10 | the timed liver shot |
| 5 | RIBS in the bout: once a rib place is at CRITICAL, each landed rib hook rolls a CRACK | 4% (2-6%) | ribs crack under repeated hooks; rare on one night |
| 6 | A CRACK changes the bout: her punches from that side x0.6, her guard on that side -10, and at the bell the corner must answer (rule 7). The opponent's crack is shown as a corner read ("she is holding her left side") | x0.6 (0.5-0.8), guard -10 (6-14) | a cracked rib = she shortens that arm and protects the side |
| 7 | YOUR fighter cracked: a corner card between rounds - PULL HER OUT (loss by retirement, the crack heals at the short end) or FIGHT ON (the rest of the bout at rule 6, and the crack heals at the long end x1.5) | Pull out: 35 days; fight on: 56 x1.5 = 84 days (TO SOURCE) | corners retire boxers with a cracked rib; fighting on worsens it |
| 8 | After the bout the ribs roll splits in two: BRUISED RIBS (the non-liver side under 50, or any rib at HURT) and CRACKED RIB (a crack in the bout, or the non-liver side at CRITICAL) | bruised 10-21 days (sparring locked, pads OK); cracked 35-56 days (no sparring, no pads on that side; roadwork, legs, technique OK) | rib bruise 1-3 weeks; rib fracture ~6 weeks to heal |
| 9 | The liver itself is never a weeks-out injury (a hurt liver is gone in days): its price is all on the night | - | liver shots leave no lasting injury in healthy athletes |
| 10 | Training: body sparring and body bag nights roll BRUISED RIBS from load as today (TRAIN_TYPES ribs); a cracked rib never comes from training without a spar night | as today | |

## The player's choices this makes (depth)
- AIM LIVER (tonight): faster tank drain and, once it is hurt, a knockdown. Covered more (it is the rear side of an orthodox
  defender: 60% cover), so it pays against a pocket fighter who will not cover it, and against a southpaw where it is the lead side.
- AIM RIBS (the other side): less cover (30%), little tonight, but the crack chance and the injury after. Against a rival you
  will meet again on the ladder, a cracked rib keeps her off the cards for 6-8 weeks (the small living world reads her injury).
- DEFENCE for her own body: "Cover up" / "Tie up" already cut body shots; now the PLAYER picks WHICH side to cover - a liver
  cover saves the night, a rib cover saves the next two months. One shout, two meanings.
- THE CORNER CARD (rule 7): a cracked rib on your fighter is a real call - a sure loss and 5 weeks, or a chance tonight and 12 weeks.
- TRAINING: a body-puncher's camp picks body sparring on purpose; Durability (chin and body) now buys two different things.
- BOOKING: an opponent's file (scout) shows "hunts the liver" or "breaks ribs" from her past bouts; the forecast reads the Aim.

## Where it shows (every menu, what it is wired to)
| Menu | What the player sees | Wired to | Test |
|---|---|---|---|
| Live round: side holos | "liver" and "ribs" counts as today; tooltip: liver "each costs her X stamina; hurt: a knockdown can come", ribs "hurt: it can crack; weeks out after" | BodyLive + LiverRibs (new pure rules) | holo_live_test row |
| Live round: AIM buttons | "Liver" / "Ribs" in place of "Right ribs" / "Left ribs"; effect line "Liver: drains her, can drop her when hurt" / "Ribs: can crack, weeks out" | PaceAim labels + aim_effect | pace_aim row |
| Live round: corner read | "She is holding her left side" after a crack; "Her liver is hurt" at the HURT band | CornerRead lines | corner read row |
| Live round: knockdown | the 3D fold + count; the commentary names the liver | Knockdowns body path + KnockdownCount | knockdown_rates row |
| Between rounds: corner card | the CRACK card for your fighter: Pull her out / Fight on, each with its days out | CornerJobs + the injury days | golden path |
| Bout forecast (BoutRead) | the Aim's liver / ribs share fires in the forecast the same way as in the fight (S459 rule: mirror every fight lever) | BoutRead | bout_read_test |
| Fight result page | knockdown line "to the liver, round 2"; the injury line "Cracked rib (left), fit Mon 2 Mar" | Aftermath + Injuries.line | result_defects row |
| Home: needs card + news | the injury with its weeks; a crack fought on shows "fought on a cracked rib: 12 weeks" | Injuries.after_bout | injuries_test row |
| Fighter page > Week | locked sessions greyed: "no sparring, ribs, until Mon 2 Mar"; pads allowed on a bruise | PadWeek / StandDown locks | pad_week row |
| Opponent file (scout) | "hunts the liver" / "breaks ribs" from her record | Scout lines | scout row |

## Build (after the critics' 6+ / 6+ and his board OK)
1. LiverRibs.gd (pure, Qwen/Arena): drain(side), liver_fold_chance(power, durability, band), crack_chance(band), injury_split(places, crack) + tests.
2. Wire: Exchanges body cost by side; Knockdowns body path; BodyLive crack + corner card; InjuryRoll split; PaceAim words; BoutRead mirror.
3. Golden path: aim liver, see her tank drop faster, a body knockdown line on the result page; a crack on our fighter, the corner card, the weeks on the Home card.

## Open for the critics
- Is "ribs = weeks out" enough of a reason to aim the ribs for a player who only cares about tonight (rule 7/8 are mostly about
  OUR fighter)? The rival-on-the-ladder payoff needs the small living world; until then it is the crack in the bout.
- Is a liver fold at 3-8% per hurt hook the right size (two or three liver-hurt rounds a season should end in a body count)?
