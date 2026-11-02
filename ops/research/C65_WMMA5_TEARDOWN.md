# C65 — What WMMA5 knows about a gas tank

Source: `D:/Databases/Default/WMMA5.mdb`, read with `access-parser` 0.0.6, plus targeted embedded SQL/help strings from `D:/WMMA5.exe` where the parser returned the wrong table shape. The parser catalog exposed 167 non-system names in this run, not the previously reported 168.

## Parser audit

| Result | Tables |
| --- | --- |
| Clean enough to use | `tblFightMetric`, `tblFightPBP`, `tblFighterAttribute` |
| Unusable as named | `tblFighter` (bogus `NumDays`, zero rows), `tblCompanyRules` (three unrelated columns, zero rows), `tblFightResult` (action-metric columns), `tblJudge` (injury columns), `tblResults` (relationship columns), `tblReferee` (reality-show columns) |

Six of the nine targeted tables therefore did not parse into their real schema. For the last four, only the relevant real column names were recovered from SQL strings embedded in the executable; no values were inferred from the malformed parser output.

## 1. The gas tank

| Evidence | Observed result |
| --- | --- |
| `tblFightMetric.Conditioning` | 1,658 values; min 0, max 100, mean 66.36, median 71, Q1 60, Q3 80 |
| `tblFightMetric.Conditioning` in ten-point bands | 0–9: 82; 10–19: 12; 20–29: 17; 30–39: 44; 40–49: 79; 50–59: 176; 60–69: 341; 70–79: 490; 80–89: 323; 90–99: 87; 100: 7 |
| `tblFightPBP.Conditioning`, `Stamina`, `Breath` | The fight-state table carries the roster rating alongside two changing gas-state fields. |

**Finding.** WMMA5 calls cardio **Conditioning**. Its roster distribution is a broad single mound concentrated from 60–89 (1,154 of 1,658, 69.6%), with a long low tail and a separate spike of 82 zeroes; the median above the mean shows that low tail pulling the average down. The embedded help text describes Conditioning as setting initial stamina and reducing the stamina cost of actions, which agrees with the three columns above.

## 2. Fatigue: output only, or degraded ability?

| Evidence | Stored example |
| --- | --- |
| `tblFightMetric.FighterUID`, `Strength`, `Mobility`, `Reflexes`, `SFootwork`, `SPunchPower` | Fighter 327's roster baselines, on the fight table's ×10 scale, are 500, 670, 750, 580 and 520. |
| `tblFightPBP.UID`, `Stamina`, `Strength`, `Mobility`, `Reflexes`, `SFootwork`, `SPunchPower` | At stored stamina 76, the same fighter is 423, 579, 635, 462 and 489: reductions of 15.4%, 13.6%, 15.3%, 20.3% and 6.0%. |
| `tblFightPBP.Conditioning`, `Chin`, `Gameplan` | In that row these remain at the roster-scaled 730, 630 and 760. |
| `tblFightPBP.UID`, `Stamina`, `Strength`, `Mobility`, `Reflexes`, `SFootwork`, `SPunchPower` | Fighter 486 at stamina -292 stores 554/840 strength, 418/600 mobility, 343/520 reflexes, 177/310 footwork and 378/440 punch power. |

**Finding.** Fatigue does not merely reduce output: WMMA5 stores selectively degraded in-fight physical and technique values while stable traits remain intact. The schema proves the before/after state but not the formula or whether every reduction is caused by stamina alone; that causal reading is supported by the executable's embedded documentation, which says tired fighters receive increasingly heavy skill penalties and explicitly names fatigue as a punch/kick-power reducer. FightCamp currently does the first half only: `FightStamina` spends and restores stamina and exposes `fatigue_fraction()`, but does not apply it to performance.

## 3. What the per-round counters count

| Comparison | Counters |
| --- | --- |
| WMMA5 row identity | `tblFighterAttribute.UID`, `WhichSide`, `ThisRound`; 32 stored rows, evenly split across side 1/2 and current-round true/false |
| Clear conceptual overlap with FightCamp | `KnockDown`; `HeavyStrike`/`MediumStrike`/`EasyStrike`; `Takedown`; `Wrestling`; `Pass`; `CloseSubmission`; `Slam` |
| WMMA5-only observations | `Stuff`, `CrazyStrike`, `GroundStall`, `PassFail`, `SweepFail`, `Separation`, `StrikeFail`, `AvoidContact`, `Smother`, `StrikeStalemate`, `DullGrapple` |
| FightCamp's nine scoring inputs | `striking_score`, `lands_round`, `knockdowns_round`, `control_score`, `takedowns_round`, `position_points_round`, `submission_attempts_round`, `throw_points_round`, and zone counts from `hits_round` (`RoundScoring.round_points`, lines 69–84) |
| FightCamp-only information | Hit-zone counts; WMMA5's 20 event columns contain no body-zone field. FightCamp also carries an explicit aggregate damage score rather than only three strike-severity buckets. |

**Finding.** WMMA5's table is richer about *failed or stalled action*—stuffs, failed passes/sweeps/strikes, separation, avoidance and dull phases—while FightCamp's score input is richer about *where damage landed*. The useful difference is telemetry, not a reason to award points for failure or boredom.

## 4. Attribute count

| `tblFightMetric` group | Count | What the extra resolution buys |
| --- | ---: | --- |
| General physical/development traits | 14 | Conditioning, durability, athleticism, consistency, resilience and development constraints |
| Stand-up technique (`S*`) | 22 | Separate footwork, feints, defence, power, technique and speed for hands and kicks |
| Clinch technique (`C*`) | 10 | Takedowns, defence, elbows, knees and dirty boxing |
| Muay Thai control/strikes (`MT*`) | 5 | A second, narrower clinch vocabulary |
| Ground technique (`G*`, excluding `Gameplan`) | 23 | Ground strikes, passes, sweeps, submissions, defence, control, scrambles and escapes |
| Fight-mind/comfort traits | 8 | Experience, killer instinct, gameplan, heart, cage/ring comfort, recuperation and preparation |
| Presentation traits | 6 | Charisma, interviews, looks, menace, performance and aura |
| **Total, excluding `FighterUID`** | **88** | Fine-grained matchup and style identity, at the cost of a large opaque model |

**Finding.** WMMA5 has 88 fighter metrics, not thirty. Sixty are technique fields. That granularity can make specialists distinct, but it is not evidence that FightCamp's seven player-facing attributes should expand; the extra resolution is more useful as hidden technique/style structure than as 81 more ratings to read and maintain.

## 5. Scoring, stoppage and judges

| Evidence | Finding |
| --- | --- |
| `tblFightPBP.Judge1`, `Judge2`, `Judge3` | Stored cards can disagree: one row is 18/18/19 and its opponent is 20/20/19. |
| `tblFightPBP.RoundPoints` | Present, but all 18 surviving rows are zero, so it cannot reveal the scoring formula. |
| `tblFighterAttribute.HeavyStrike`, `MediumStrike`, `EasyStrike`, plus the other event columns | WMMA5 retains severity and achievement categories from which a hidden score can be built. |
| `tblJudge.Accuracy`, `Bias` (column names recovered from embedded SQL) | Embedded documentation says each judge perturbs the hidden achievement total using personal accuracy and bias before deciding the round. This is documentation evidence, not a parsed-value finding. |
| `tblResults.Judge11`–`Judge13`, `Judge21`–`Judge23` (embedded SQL) | The persisted result has three scores for each side; split and majority decision strings are present in the executable. |
| `tblFightResult.Method`, `ControversialDecision`, `ControversialStoppage` and `tblReferee.Stoppages`, `StandUps`, `Style` (embedded SQL) | WMMA5 preserves method plus disputed-decision/stoppage state and gives referees behavioural parameters. Exact thresholds and distributions were not recoverable. |

**Finding.** The part worth stealing is not random verdict noise: it is a judge-specific, bounded interpretation layer over a detailed achievement record, plus explicit provenance for controversial decisions and stoppages. FightCamp already does the more important thing better by scoring severity through `striking_score`; R84's real-time panel cannot disagree because damage is its only non-zero criterion and every judge must weigh primary damage identically. WMMA5 proves disagreement is representable, not that FightCamp should violate that rule to manufacture it.

## What FightCamp should take, and what it should refuse

1. Apply `fatigue_fraction()` as a continuous penalty to performance-facing physical and technique reads, while leaving Conditioning and stable mental traits untouched.
2. Start calibration near WMMA5's observed shape—roughly 6% power loss and 14–20% movement/technique loss near the exhausted example—but refuse to copy a curve the database cannot expose.
3. Record failed and stalled actions for tactics, pacing and commentary, but refuse to turn stuffs, failed passes or dull phases into positive score.
4. Add bounded judge accuracy/bias only when real-time grappling gives judges multiple legitimate criteria; refuse fake disagreement made by perturbing primary damage.
5. Preserve controversial-decision and controversial-stoppage provenance, but refuse WMMA5's 88-field player-facing complexity and keep FightCamp's seven-attribute ruling intact.
