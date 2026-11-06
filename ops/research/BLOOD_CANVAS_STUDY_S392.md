# Blood & Canvas: Bareknuckle Boxing (demo) design study (S392)

Read-only on his install, our own words, names and numbers only, nothing copied. The game was not run or hooked. Build date 2026-09-25.
Unreal project BKKO, 20,592 manifest lines, 14,918 of them project files. A demo: treat every number as a demo number.

**Evidence tags:** **[T]** value read from a shipped data table, solid. **[C]** read from compiled Blueprint logic as an ordered list of variables and constants: values solid, operators come from temp names, and which branch owns a line is my reading. **[S]** the game's on-screen text says so, paraphrased. **[N]** a name only: it exists, runtime use unknown.

**How it was read:** manifests; the utoc directory (not encrypted); small assets read in memory from the ucas, nothing unpacked to disk. The exe holds no gameplay strings, so all gameplay is Blueprint and the exe scan gave nothing. The pak index is encrypted and was left closed, so its ini files are unread. Oodle-compressed assets were opened with the Epic-signed library from his UE 5.8 install. The unsigned copy in NBA 2K26 was found and not used.

## 1. What kind of game
- **Real-time action boxing, not a manager.** You are the fighter and throw each punch yourself. No roster, coach, training week or fight plan exists in any asset name. [N, absence] Your decisions: which fight, what to buy, when to stop. The rest is reflexes.
- Pick one of 4 heroes: Jack, Marcus, Hana, Adriana. [T] Stat tables are shared; only cosmetics are per hero. [T]
- **Hub:** a walkable gym with sparring ring, heavy bag, radio, trophies and an office computer. [T] Sparring has no lasting cost; the bag has a power and combo readout. [S]
- **The computer is the management layer, as fake phone-style apps** [N, S]: Underground (fights), BKVO (pro ranking), Pharmacia (stats), Blillow (gym stages), Copay+ (health), Threadz (clothes), Strix (money, tax, retire).
- **Career:** 3 underground venues at 5,000 purse each [T], then a pro ladder of 20 named men with the player placed at 21 (a female table exists too) [T], then title fight and champion. [S]
- **End of career:** lifetime damage passes a limit, or you retire for good. Final screens are a damage ledger and net worth after tax. [S, C]
- Named opponents: 34 men, 32 women, 4 sparring partners. [T] But `DT_EnemyStats` has **one row** in this demo, Curtis Jackson. [T]

## 2. How the fight is built
**Controls** [N, S]: 4 punch buttons plus uppercuts by chord (jab + hook), Power modifier, Body modifier, Lean modifier, Block, Block Low, Lock-on. `DetermineAttackType` reads IsInStepRange, IsPowerMod, IsBodyMod [C], so a step-in punch appears to be picked by range, not by a button.
**6 punches x 8 forms = 48:** Standard, Low, Power, PowerLow, Step, StepLow, PowerStep, PowerStepLow. [T]

| Punch | Damage std / power [T] | Stamina std / power [T] | Montage length [T] |
| --- | --- | --- | --- |
| Jab | 8 / 12 | 95 / 140 | 0.53 s (step 0.80) |
| Straight | 18 / 27 | 110 / 165 | power 0.73 s |
| Hook | 24 / 36 | 140 / 210 | 0.73 s |
| Uppercut | 20 / 30 | 165 / 220 | power 1.17 s |

Power is exactly x1.5 damage. Body and step forms do the same damage as the head form. Two cells look like typos: uppercut left PowerStepLow costs 45, uppercut right StepLow 110. [T]
Damage = table value x punch strength x crit modifier. [C]

**Fatigue, the best thing in the game** (`StaminaConsequences`, runs on stamina percent of the current ceiling) [C]:

| Stage | Stamina | Punch power | Speed | Guard strength | Combo length |
| --- | --- | --- | --- | --- | --- |
| 5 | above 55% | 1.00 | 1.00 | 1.00 | 1.00 |
| 4 | 55% or less | 0.88 | 0.95 | 0.75 | 0.80 |
| 3 | 35% or less | 0.70 | 0.90 | 0.60 | 0.67 |
| 2 | 20% or less | 0.50 | 0.85 | 0.55 | 0.34 |
| 1 | 5% or less | 0.35 | 0.80 | 0.50 | 0 |
| 0 | empty | 0.25 | 0.75 | 0.45 | 0 |

Power falls far faster than speed. The combo column is set here but no reader was found: the combo check compares with plain MaxCombo, so it may do nothing. Walk speed 150 when tired, 75 at empty; IsTired appears to begin at the 35% line. [C] Tired also makes the combo cooldown x1.5. [C] The HUD blinks the stamina bar. [N]

**Stamina over a fight** [C]:
- Hero regen ticks every 0.1 s, only when not attacking or blocking. Base 28 a tick (280/s), maxed 36. Enemy: every 0.5 s, Curtis 100 a tick (200/s).
- A clean hit lowers regen by 1/200 of its maximum, a power hit by 1/111. Floor is half of maximum.
- A clean hit lowers the stamina ceiling by 0.7% of base, a power hit by 1.0%. Floor 70% of base. So being hit makes you permanently more tired inside that fight.
- A hero at base stamina has 12.6 jabs or 8.6 hooks in the tank before regen.

**The exchange** [C]:
- **Blocking:** block must be effective for the punch's height (high or low). A block scales damage by BlockDMGModifier, then 80% of what is left comes off stamina and 20% off health. Blocked damage piles up in BlockBreakDamage inside a timed window; reaching the threshold breaks the guard and forces a stumble. Curtis's threshold is 80. [T] Fatigue shrinks the hero's.
- **Combos:** a ComboReady notify opens the window; press in it. Each punch after the first multiplies punch strength by the combo modifier, compounding. MaxCombo is a stat.
- **Stumble:** fires on one hard punch (force above StumbleThresholdForce, Curtis 600 [T]) or on damage piling up in a window (above StumbleThreshold, Curtis 100 [T]). **ImpactForce is the fist's bone mass x its measured velocity**, so a punch's force comes from how it actually landed. The same force drives hit VFX size (0-200 maps to 0.5-5). Hero stumble timer 4 s. Enemy accumulator also tests force above 800; how that sits with the 600 is unclear.
- **Crit and knockdown:** at 10% health or less: damage taken x1.25, guard threshold x0.6, walk speed 60, guard dropped, and the AI backs off 150 cm with up to 50 cm sideways. At 0 health: if a get-up is left, a knockdown, otherwise the fight ends. A get-up appears to restore full health. Curtis has 0 get-ups. [T]
- **Feel:** hit stop 0.04 s on both sides. Hit detection is hand-component overlap.

**Animation set** [N unless marked]: 318 assets: 129 montages, 180 sequences, 7 blend spaces (combat move, tired walk, lean, block, block low).
- Two full attack sets: base and "Necio", a later update folder with its own table. Hit reactions: 6 high, 4 low. Stumbles: 9 montages. KOs: 9, picked by the punch that landed.
- **Hit reactions run on an `UpperBody` slot, 0.47 s, blend-in 0.10. Stumble (0.93 s, blend 0.15) and KO (0.43 s) run on `FullBody`.** [T]
- Punches are FullBody, blend 0.06, with notifies for ComboReady, ComboReset, ResetHit, ResumeMovement, Recovery. [T]
- Anim graph has inertial blending, layered bone blend, control rig, foot trace. [N] A PhysicsControl component drives arms, spine, upper body and head, with head physics on and off. [C] A blocking pose set exists. [N]
- Footwork: 8-way run and tired-walk blend spaces, no step clips beyond the Step punches. [N] Lean is its own 4-way pose set, plus a lean-block set. [N]

**Around the fight:**
- **Clinch:** none, 0 assets, 0 names. **Referee, judges, scorecards, cornerman, cutman:** none, 0 assets, 0 strings. [N, absence]
- **Rounds** [C, S]: game mode holds one float, 120.0, and the text says two-minute rounds. The round counter rises when the timer ends unless someone is down, then a corner break: fighters are teleported, and the sit clip's name ends in Temp. No round cap seen. What ends a fight with no KO was not found.
- **Cuts and blood** [C, N]: 5 wound spots (left high, left low, right high, right low, centre), side partly random. Each cut adds 1 lifetime injury and **1.5% of the lifetime limit** to lifetime damage, and marks ring and wraps with blood. Face damage is material masks: nose, each eye high and low, plus dedicated damaged-skin textures. What triggers a cut was not read.
- **Crowd** [T, N]: 3 intensity states x 4 venue tiers. 16 voice actors grouped by accent, 651 voice assets, in line families for flurry, stagnation, finish pressure, finish and damage. So the crowd has lines for a lull as well as a flurry. 18 crowd animation clips.
- **Camera and HUD** [N]: player-controlled fight camera on a boom, lock-on, separate KO camera, stadium view, intro sequence. Health with a delayed lag bar, stamina, damage number pop-ups coloured head or body, combo count, combo damage, max-combo flash, round and timer.

## 3. Fighter data (the part we care about most)
**Nothing is rolled per fighter.** Random calls in fight code are all moment-to-moment. [C] Fighters are hand-written rows; the hero is bought in levels. [T]
**The sheet: 31 fields** [T], of which these change a fight (Curtis Jackson's values):

| Field | Curtis | Effect |
| --- | --- | --- |
| MaxHealth / MaxStamina | 1600 / 1100 | pools |
| AttackSpeed / PunchStrength | 1.02 / 1.8 | multipliers |
| StaminaRegenAmount / CostModifier | 100 / 1.0 | gas tank |
| GetUps | 0 | knockdowns survived, our nearest thing to heart |
| MaxComboCount | 4 | longest combo |
| BlockBias / DefendChance / CounterChance | 0.56 / 0.40 / 0.20 | defensive habit |
| AggressionScore | 0.82 | how often he attacks |
| AttackIntervalMin / Max | 0.19 / 0.46 s | pace |
| PressureScoreThreshold | 0.89 | when he breaks and retreats |
| BlockbreakThreshold | 80 | guard durability |
| StumbleThreshold / ForceThreshold | 100 / 600 | chin, split into accumulated and single shot |
| Purse | 5000 | pay |

Also name, nickname, hometown, bio, portrait, flag, mesh, scale, behaviour tree. **FighterType (Brawler, Boxer, Defender) is loaded from the row and read by nothing else found, in any AI asset.** [C] So styles appear to be numbers on the sheet, not separate logic. One shared tree, `BT_BKKO_Base`, plays everyone. [T]

**AI brain** [C]:
- Pressure, every 0.1 s: new = lerp(old, 0.7 x damage + 0.2 x distance + 0.1 x momentum, 0.3).
- Damage part = hit size against a maximum, fading with the square of time since the hit, gone by 0.8 s. Distance part = 1 at 115 cm, 0 at 170 cm. Momentum = 0.5 while the hero moves forward.
- Attack roll: random below clamp(aggression - pressure). So pressure directly cuts his output.
- Combo length: random from 2 to floor(MaxCombo x stamina percent). Must have 20 stamina to act. Retreats when pressure passes his threshold.
- Names for close, mid and long bands, orbit and corner escape exist on the blackboard but the live tree does not use them. [N]

**Hero growth, 12 paid rungs per line** [T]. STR has one row out of order: 1.47 sits between 1.643 and 1.8.

| Line | Start | Max |
| --- | --- | --- |
| STR: punch strength / combo step | 1.0 / 1.0 | 1.8 / 1.15 |
| DEX: speed / stamina / cost / max combo | 1.0 / 1200 / 1.0 / 2 | 1.2 / 1600 / 0.9 / 6 |
| VIT: health / recharge | 1000 / 28 | 2800 / 36 |

## 4. Economy and career clock
- Upgrade rungs cost 2,490 rising to 274,990, the same ladder on all three lines, about 1.15 M a line and 3.44 M for all. The upgrades are fictional performance drugs. [T, S]
- Gym stages cost 25,000, 100,000 and 250,000. [T] A 25-row special line runs 1,499 to 109,999, effect unknown. [T, N] Wins pay money, XP and followers; amounts not read. [C]
- **Lifetime damage:** damage from landed hits outside sparring adds to it (blocked hits not checked). Passing the limit ends the career at once, with a medical reason on the game-over screen. [C, S]
- **Telecare** gives a written prognosis in tiers with a fights-left estimate. 4 health warnings exist, single-use treatment shots give some back, and doses run out. [S, N] Screens show damage per fight, injuries, knockouts. [S]

## 5. Numbers to hold against ours
- Jab 0.53 s, hook 0.73 s, power uppercut 1.17 s. Undisputed's control-back was 0.12-0.17 s, so this is slower and committal.
- Hit reaction 0.47 s, upper body only. This answers issue 4 in UNDISPUTED_MIX_S391.md: another shipped boxing game layers reactions and leaves the legs alone.
- AI pressure band 115-170 cm. Hit stop 0.04 s. Crit at 10% health. Guard split 80/20. Tired power falls to 0.25, speed only to 0.75.

## 6. Where it beats us
1. The fatigue ladder is one small readable table that touches power, speed and guard at once.
2. One fighter sheet makes every opponent different through one shared brain.
3. Force from the actual punch, so a good connection is a good connection.
4. Career ending is a visible number with a forecast, which is what our career arc lacks.
5. Crowd lines tied to what the fight is doing.

## 7. Could not establish
- **Class default values:** BlockDMGModifier, LifetimeDMG_Limit, BlockBreakWindow, StumbleWindow, combo cooldown, DMGMaxForPressure. Alignment tests failed, so no field names go on these. A lone 25000.0 in the hero defaults may be the lifetime limit, unproven. Enemy defaults hold 0.5, 1.5, 3.0, 0.9 and 40, unassigned.
- How a fight ends with no KO, how many rounds, whether stats reset between rounds. Pro purses.
- Every opponent but one, so the spread of the sheet across a career is unknown.
- Config ini files (encrypted pak, left closed). Feel, difficulty, whether it is fun: nobody played it for this study.

## What we take
- **A staged fatigue table for our fight model.** Reason: one small table gives clear, explainable effects, which is our "show why" hook.
- **Rolled traits as numbers on one sheet, feeding one shared brain.** Roll aggression, pressure threshold, guard durability, chin split into single-shot and accumulated, get-ups, counter chance. Reason: their sheet proves these knobs make distinct fighters without per-style code. Rolling them is what they did not do, and it is ours.
- **Pressure as a score that cuts output.** Reason: a plan that pressures an opponent would visibly reduce his punches, which the Why panel can show.
- **A shrinking stamina ceiling from clean hits.** Reason: body-work and early damage then pay off late, a plan effect players can see.
- **Upper-body-only hit reactions over live footwork.** Reason: confirms the S391 expectation and fixes feet stopping on hits.
- **A lifetime damage ledger with a fights-left forecast.** Reason: gives a long career an honest clock, and every fight a cost beyond the week. Needs a design pass before it enters scope.
- **Crowd reacting to lulls as well as flurries.** Reason: cheap, and it adds sound to a fight that has little.

## What we do not take
- **Real-time punch control.** Reason: our player plans and watches; the bible's hook is the plan.
- **Buying stats with money.** Reason: it replaces training, and pillar 2 needs weeks to cost something.
- **The drug-and-debt satire.** Reason: not our tone, and it could complicate store and ratings work.
- **Their numbers as ours.** Reason: 8-to-36 damage on 1000-2800 health is tuned for hands on a pad, and a demo at that. Keep the shapes, tune our own.
- **Physics-driven limbs and fist force as built.** Reason: our fight is scripted from exchanges. A force-like value can be computed instead.
- **A hidden type label with no effect.** Reason: if we show a style, it must do something (pillar 4). Their enum is the warning.
- **Teleporting to the corner.** Reason: fine for a demo, and we can stage it properly.
