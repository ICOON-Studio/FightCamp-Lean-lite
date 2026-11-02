# K35 — THE KNOCKDOWN COUNT: DOES THE ROUND CLOCK RUN, AND WHICH RULESETS COUNT AT ALL

Kalli (Grok Bot), research, 2026-09-13, one pass (~10 min). Task: `research/TASK_K35.md`. Written into the repo
by Claude from Kalli's reply; the tables below are Kalli's, converted from tab-separated text. Labels DOCUMENTED /
SECONDARY / NOT FOUND are Kalli's; "DOCUMENTED (implied)" means the rule text implies it without saying it.

## DECISIONS (Claude's reading, for THE COUNT engine slice)

1. **Boxing: the round clock RUNS during a knockdown count.** Explicit in USA Boxing 1.1.2026 (24.1(5)) and World
   Boxing Feb 2024 (10.12.6); implied by the bell being withheld in NAC 467.740(6), WBO 25(e), IBF 2025, BBBofC 3.40.
   ABC Unified / ABC Referee Manual / WBA / WBC state no clock sentence (NOT FOUND) - nothing says it stops.
2. **Boxing: never saved by the bell, in any round including the last** - uniform across every body listed. The
   bell is HELD while counting (NAC, ABC Manual); a man who fails to beat the count after the period ended is KO'd in
   that round (NAC 467.740(7)). So an engine count that runs past the round's end must hold the end of the round.
3. **Kickboxing counts too** (ISKA-ABC 2017, ISKA AU K-1 2023, WAKO Pro, GLORY Mar 2026, K-1): ten-count, mandatory
   eight; GLORY also a standing eight; three knockdowns in a round (or four in a bout) stop it, format-dependent;
   the gong is held through the count - the clock runs.
4. **Muay thai counts too** (IFMA v2.04 Rule 28, Lumpinee, WMC 2020): ten-count with mandatory eight; 3/round or
   4/bout limits common. Clock: IFMA 2016 said counting time is outside the round (STOPS); v2.04 no longer says so -
   NOT FOUND as a current sentence. Lumpinee's final round: the bell strikes at time even during a count.
5. **Taekwondo (WT 2026) counts to eight, with the match clock STOPPED** (Art. 10.4.6 / 18.1.1); fail by eight is
   RSC; no boxing-style three-knockdown rule found.
6. **MMA: no count** (already held, J14/J15). **No timed study of knockdown-pause durations exists** in any of these
   sports (NOT FOUND, again) - J15's 10-25 s stays an inherited range, not a measured distribution.
7. **Scope consequence:** the operator's COUNT ruling was written for boxing, where J15 had looked. K35 shows
   kickboxing, muay thai and taekwondo count as well. Recorded for the engine slice; see the HANDOFF block.

## KALLI'S TABLES

### 1 — Boxing: does the ROUND CLOCK keep running during a knockdown count?

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| USA Boxing Rev 1.1.2026 | Clock RUNS; stops only on referee “time” | 24.1(5): clock “must only stop … when instructed by the referee with the command ‘time’”; during KD timekeeper gives second signals while referee counts | DOCUMENTED | USA Boxing Rule Book 1.1.2026 Rules 19 & 24 |
| World Boxing Feb 2024 | Clock RUNS; “Time” stops clock | 8.1.1 “Time”=stop time; 10.12.6 stop clock only on “Time”; 10.12.7 sound during count; 10.12.8 hold gong if counting at round end | DOCUMENTED | worldboxing.org Competition Rules Feb 2024 |
| Nevada NAC 467.740 | Implied RUNS (period can expire while counting; bell withheld) | (6) if down & counting at end of period, bell must not sound until downed combatant regains feet; TK supplies 1-sec intervals; no “stop clock for KD” | DOCUMENTED (implied) | https://www.leg.state.nv.us/NAC/NAC-467.html §467.740 |
| WBO | Implied RUNS | §25(e): if down when round’s three-minute duration expired, TK shall not ring bell | DOCUMENTED (implied) | wboboxing.com WBO regulations PDF |
| IBF Bout Rules 2025 | Implied RUNS | Bell will not ring until boxer rises; count continues past scheduled end | DOCUMENTED (implied) | ibf-usba-boxing.com BoutRulesUpdate2025.pdf |
| BBBofC 2025 | Implied RUNS | 3.32 TK counts by watch; 3.40 “Time Off” only when referee says Stop Boxing and so instructs TK — KD procedure does not invoke Time Off | DOCUMENTED (implied) | bbbofc.com Rules_and_Regulations_2025.pdf 3.32, 3.40 |
| ABC Unified Rules 2016 | Explicit clock run/stop sentence | — | NOT FOUND (clock) | abcboxing.com unified_rules_boxing_rev_august2016.pdf |
| ABC Referee Manual Rev 08/2025 | Explicit clock during KD | — | NOT FOUND (clock) | ABC-BOXING-REFEREE-MANUAL-rev8-2025.pdf |
| WBA Rules 10–14 | Explicit clock | Count continues after bell (R14); no clock sentence | NOT FOUND (clock) | wbaboxing.com WBA-Rules-11.08.2023.pdf |
| WBC synthesized championship | Explicit clock | “bell will not save … in any round”; no clock sentence | NOT FOUND (clock) | wbcboxing.com RULESFORCHAMPIONSHIPFIGHTS-SYNTHESIZED |

Do not invent “stops” for ABC/WBA/WBC where no sentence exists. Where text speaks: clock runs unless the referee calls “Time.”

### 2 — Boxing: the bell rings during a count (saved by the bell?)

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| ABC Unified §10 | Never (any round) | Cannot be saved by the bell in any round | DOCUMENTED | ABC Unified 2016 |
| ABC Referee Manual Rev 08/2025 | Never; punch-at-bell: hold bell, finish mandatory 8, then ring | “no saving by the bell in any round” | DOCUMENTED | Manual Rev 08/2025 |
| NAC 467.740(6)–(7) | Bell withheld while counting; fail by 10 after period ended → KO that round | DOCUMENTED | NAC-467 |  |
| WBA R14 | Count continues even after the bell | DOCUMENTED | WBA Rules |  |
| WBC item 12 | Bell will not save in any round | DOCUMENTED | WBC synthesized |  |
| WBO §25(e) | May not be saved by bell in any round; inadvertent bell disregarded | DOCUMENTED | WBO regs |  |
| IBF 2025 | Bell will not save a boxer in any round | DOCUMENTED | IBF Bout Rules 2025 |  |
| BBBofC 3.35 | Bell interrupts count → contest & count continue until feet or full count (every round incl. final) | DOCUMENTED | BBBofC 2025 |  |
| USA Boxing 19.9 / 24.1(7) | Continue count irrespective of end of round; gong/bell will not save | DOCUMENTED | USA Boxing 1.1.2026 |  |
| World Boxing 8.6.8–8.6.9 | Same; “(The gong does not save the Boxer)” | DOCUMENTED | World Boxing Feb 2024 |  |

Uniform among listed bodies: never (every round including the last).

### 3 — Kickboxing / Muay Thai / Taekwondo

#### Kickboxing

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| ISKA–ABC Unified Pro Kickboxing 2017 | Count→10; mandatory 8; no standing 8; 3 head KD same round = TKO; clock run/stop not explicit; flash NOT FOUND | §§5–8 | DOCUMENTED | iskaworldhq.com ISKA-ABC-PROFESIONAL-UNIFIED-RULES-OF-KICKBOXING.pdf |
| ISKA AU K-1 Pro 2023 | Count from TK; mand. 8; KO at 10; 3/round or 4/bout → KO; AU text: bell cannot save except last-round terminate | DOCUMENTED | iska.net.au ISKA-AUSTRALIA-K1-PRO-RULES-2023.pdf |  |
| WAKO Pro (ring rules PDF) | Count 1–10; resume only after 8; mand. 8; 3 counts same round or 4 bout → RSC; if down at end of round, continue count (gong waits until Fight) | Counts During “Down”; Mandatory Eight; Compulsory Count Limits; Art.9.4 TK | DOCUMENTED | Wako-Pro Rules PDF (archive). Newer 2025 PDF fetch failed this pass |
| GLORY Rules as of Mar 16, 2026 | Eight count (obliged to 8 then assess); Standing Eight Count if weakened but standing; KO if count to 10; single/final: 3 KD same round or 4 match; tournament non-final: 2/round or 3/match; if round time ends during count, TK may not sound gong before 8 + Fight, then sound end — implies clock RUNS; flash NOT FOUND | §5.05 B.1–8; TKO §5.06 E.3.c | DOCUMENTED | https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf |
| K-1 (classics site) | Count to 10; DOWN call; flash/immediate rise may not be DOWN if ref judges damage not severe; 3 downs/round (2 in tournament except final)=KO; TK does not ring while counting | DOCUMENTED / archive | https://k-1.info/html/ruleofk1/ |  |
| ONE Kickboxing (site) | TKO via 3 KD in a round / 4 in a bout | Count procedure, mand. 8, clock, flash | DOCUMENTED for 3/4 KD only; count details NOT FOUND on marketing page; full Global Ruleset PDF not retrieved | onefc.com/martial-arts |

#### Muay Thai

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| IFMA v2.04 (rev Apr 10, 2023) | Count Thai 1–10; mandatory 8 (BAED); KO at SIB(10); count continues at end of round; CCL Senior/U23: 3/round or 4/bout; flash NOT FOUND | Rule 28; 26.2.5 | DOCUMENTED | muaythai.sport IFMA-Rules-and-Regulations-v2.04-1.pdf |
| IFMA 2016 (superseded) | Clock: stopping for counting “is not included in the period of round” → STOPS | Rule VIII / rounds | DOCUMENTED (older) | IFMA-Rules-Regulations.pdf (2016) |
| IFMA v2.04 clock | Rule 4 list dropped the word “counting”; still holds gong if counting at round end (15.1) | Explicit KD clock stop/run | NOT FOUND as clear current sentence — do not carry 2016 “stops” forward without note | v2.04 |
| Lumpinee (stadium English) | Count; must reach 8 before BOX; KO at 10; 3rd fall same round after two counts = TKO; non-final: hold bell while counting; final round: strike bell when time finishes even if counting | §§15–20 | DOCUMENTED | lumpineestadium.com/rules |
| WMC 2020 | Mand. continue to 8; KO at 10 | Rule 16 | DOCUMENTED | wmcmuaythai.org WMC-Rules-Regulations-2020.pdf |
| ONE Muay Thai | 3 KD/round or 4/bout = TKO (site) | Full count procedure | DOCUMENTED (3/4); procedure NOT FOUND on page | onefc.com/martial-arts |
| SAT / Rajadamnern primary English PDF | — | — | NOT FOUND this pass | — |
| Wisconsin SPS 192.79(2) | Flash KD (rises immediately): (3)–(6) do not apply (skips neutral corner/count/mand 8); count continues even if bell; pro: no stop solely for 3 KD | DOCUMENTED (held, confirmed) | docs.legis.wisconsin.gov SPS 192.79 |  |

#### World Taekwondo (in force 1 Jan 2026)

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| World Taekwondo | KD def Art.17: floor contact / stagger / ref judges cannot continue from legitimate scoring technique | DOCUMENTED | WT Competition Rules & Interpretation 2026-01-01 |  |
| World Taekwondo | Procedure Art.18: Kal-yeo → recorder stops match clock; count Ha-nah→Yeol 1-sec; if stands, continue to Yeo-dul (8) then assess; fail will by 8 → RSC | DOCUMENTED | Art. 18.1.1–1.6 |  |
| World Taekwondo | Clock STOPS on Kal-yeo during KD | DOCUMENTED | Art. 10.4.6 / 18.1.1 |  |
| World Taekwondo | Recovery count to 8; boxing-style 3-KD rule NOT FOUND; flash exception NOT FOUND | DOCUMENTED / NOT FOUND | Art. 18 |  |

### 4 — Timed measurement of real knockdown pauses

| Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|
| Any sport | Dedicated video/thesis/broadcast study measuring canvas-down (or ref “down”) → fight resume with sample size n | — | NOT FOUND | Kickboxing/MT/TKD time-motion papers time general referee pauses, not KD-specific distributions. Fan stopwatches of single bouts are not studies. Parent ~10–25 s estimate remains unsupported by timed primary |

#### GAPS

| Gap | Notes |
|---|---|
| Explicit ABC / WBA / WBC sentence “clock runs/stops during KD” | Only USA Boxing / World Boxing state it clearly; others imply via gong-hold |
| ONE Championship full KD count procedure PDF | Marketing page has 3/4 KD only |
| Rajadamnern / SAT English primary PDF | Not retrieved |
| IFMA v2.04 explicit KD clock stop/run | 2016 said stops; current text dropped “counting” from Rule 4 |
| Timed canvas→resume distribution with n | Still NOT FOUND |
| WAKO Pro 2025 PDF | Fetch failed this pass; older archive used |

#### Closing — simulate a count?
Boxing: Yes — pause striking for a continuing knockdown count (mandatory eight even if he rises at once; opponent farthest neutral corner). Round clock should keep running where bodies speak (USA Boxing / World Boxing explicit; NAC/WBO/IBF/BBBofC implied by gong-hold). Never saved by the bell under the listed bodies.

Kickboxing: Yes under ISKA / WAKO Pro / GLORY / K-1-class rules — ten-count with mandatory eight (GLORY also has standing eight); three-knockdown / four-bout limits common (format-dependent). Treat the round clock as running where GLORY/WAKO hold the gong through eight; ONE’s full count procedure remains NOT FOUND beyond the 3/4 KD TKO.

Muay Thai: Yes under IFMA / Lumpinee / WMC — count to ten with mandatory eight (BAED); multi-knockdown stoppages common. Clock: IFMA 2016 said counting time is outside the round (stops); current IFMA v2.04 does not clearly repeat that — do not hard-code “stops” without a parent call. Wisconsin flash knockdown skips the count. ONE MT: 3/4 KD known; procedure NOT FOUND.

Taekwondo (WT): Yes — a recovery count to eight after Kal-yeo, with match clock STOPPED for the count; fail by eight → RSC. This is not a boxing ten-count to KO; there is no documented boxing-style three-knockdown rule in WT 2026.

MMA (parent): No ten-count — do not pause for a count.

End K35.

