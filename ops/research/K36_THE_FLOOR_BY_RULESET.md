# K36 — WHEN A FIGHTER GOES TO THE FLOOR: WHICH RULESETS LET THE FIGHT CONTINUE THERE, AND FOR HOW LONG

Kalli (Grok Bot), research, 2026-09-13, one pass. Task: `research/TASK_K36.md`. Written into the repo by
Claude from Kalli's reply; the tables are Kalli's, converted from tab-separated text.

## DECISIONS (Claude's reading)

1. **No ground fight at all under boxing (ABC, WBC), kickboxing (GLORY, K-1, WAKO, ISKA), muay thai (IFMA v3.0,
   Lumpinee), karate (WKF 2026) or taekwondo (WT).** A man on the floor is DOWN: the other is parked and the
   referee counts (K35) or calls YAME / Kal-yeo. Striking a grounded man is a foul in every one of them (WKF allows
   only an immediate hand follow-up). Submissions are not part of any of them.
2. **Throws and sweeps:** fouls in GLORY, K-1, ISKA and Lumpinee; WAKO allows an ankle-level foot sweep; IFMA: a
   throw without a strike does not score and hip throws / tackles are fouls. ONE Championship muay thai lists a
   "legal throw" among KO methods - ground continuation NOT FOUND there.
3. **The ground continues only in sambo (FIAS: sport - hold-downs and joint locks, no chokes, no strikes; combat -
   locks, chokes and ground strikes when both are down), wrestling (UWW: par terre, no submissions, stand-up after
   "a reasonable period" if the attack dies), BJJ (IBJJF) and MMA.** Numbered clocks: sambo hold-down 20 s, painful
   hold 60 s (combat: 1 min) then a standing restart. No empirical study of ground-spell length exists (NOT FOUND).
4. **For the engine (Q90):** muay thai reaches the ground in 22 of 60 legal bouts (13.3 s a bout, longest 93 s) and
   the extreme witness pair finishes 150 of 400 by submission - both illegal under IFMA and Lumpinee. Boxing and
   kickboxing never reach the ground (Q90). The rows above are what a fix copies.

## KALLI'S TABLES

### 1 — Continue on the ground?

| Sport | Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|---|
| Boxing | ABC Unified + Referee Manual 08/2025 | No. KD → mandatory 8; opponent farthest neutral corner; count to 10 = out. Slip: “No Knockdown”/“Slip”; still cannot be hit while down. Out of ring: 20s (mandatory 18 if earlier). | “When a knockdown occurs, the referee should direct the standing boxer to the farthest Neutral Corner… after giving the mandatory (8) count…” / “a boxer is not allowed to hit a fighter when they are considered down.” | DOCUMENTED | abcboxing.com Referee Manual rev8-2025 · Unified Rules 2016 |
| Boxing | WBC Championship | No. Mandatory 8 after KD (3 parts on canvas); opponent farthest neutral corner; 10 = KO; no standing 8; no auto 3-KD TKO; out of ring 20s; bell does not save. | “There will be a mandatory eight (8) count after a knockdown (when three (3) parts of the body touch the canvas).” | DOCUMENTED | WBC Synthesized Championship Rules |
| Kickboxing | GLORY Mar 16 2026 | No. “Down” → opponent farthest neutral corner; count to 8 then assess; 10 = KO. Standing 8 exists in this 2026 text. | “Continuing to fight if someone has any other part of his body other than his feet on the ground” is a foul. “The Referee is obliged to continue counting until the eighth count…” | DOCUMENTED | glory-rules-2026-v2.pdf |
| Kickboxing | K-1 WORLD GP (in force 2023-03-12) | No. Down = any part other than soles on mat from damage; opponent neutral corner; rise + fighting pose within 9s or KO; 3 downs/round (2 in non-final tournament). | Art.6(9) attack on fallen/rising; Art.10 down = soles-only rule | DOCUMENTED | img.k-1.co.jp/k-1wgp/rule |
| Kickboxing | ONE Kickboxing | Wins by punch/kick/knee or 3 KD/round / 4/bout. Ground-continue clause | — | DOCUMENTED (wins only); ground-continue NOT FOUND | onefc.com/martial-arts |
| Kickboxing | WAKO K-1 Style | No. Central ref counts 1–10; resume only at 8 when downed fighter on feet in fighting stance; opponent neutral corner. | “The Central referee will only continue the fight when kickboxer who is in knock down is ready to fight on count of 8.” | DOCUMENTED | WAKO Rules rev 25.10.2022 Ch.2 Art.10 + Ch.10 |
| Kickboxing | WAKO Low Kick | No. Same KD count. Ref must stop immediately when any body part except feet touches floor. | “stopping the fight immediately when one of the two kickboxers touches the floor with any part of the body apart from his feet.” | DOCUMENTED | WAKO Ch.9 Art.5 |
| Kickboxing | ISKA–ABC Unified Pro KB | No. Neutral corner + mandatory 8; slip that does not rise → count; 10 = TKO. | “In the event of a knockdown the referee shall send the standing fighter to a neutral corner and administer a Mandatory Eight (8) Count…” | DOCUMENTED | ISKA-ABC Unified Pro KB 2017 |
| Kickboxing | ISKA AMA Ring K-1 2025 | No. Throws/sweeps illegal; stand-up striking only. | Illegal: “Throwing. Sweeps.” | DOCUMENTED | AMA Ringsports Rules V02 2025 |
| Muay Thai | IFMA v3.0 (rev 2026-05-11) | No. YOOT + Thai count 1–10; opponent neutral corner; resume only on CHOCK after mandatory 8. “Down” without a strike can still be counted if difficulty rising. Out of ring: 20s. | “The opponent may only continue against the Athlete who is Knocked Down after the latter has gotten up and the Referee resumes the contest on the command ‘CHOCK’.” | DOCUMENTED | IFMA-Rules-and-Regulations-v3.057 Rule 32 |
| Muay Thai | Lumpinee | No. Fallen = count 1–10; opponent farthest corner; mandatory 8; both down → count while either is down. | 19.1–19.6; 18.4 fallen-opponent attack | DOCUMENTED | lumpineestadium.com/rules |
| Muay Thai | ONE Muay Thai | KO includes “legal throw”; 3 KD/round / 4/bout. Ground-continue | — | DOCUMENTED (wins); ground-continue NOT FOUND | onefc.com/martial-arts |
| Karate | WKF Kumite 2026 | No sustained ground bout. Fall/throw → YAME unless immediate scoring follow-up; wrestling on floor → YAME. | 7.10(f)(i) | DOCUMENTED | WKF_2026_Kumite_Competition_Rules |
| Taekwondo | World Taekwondo (2026-06-01) | No. Kal-yeo; clock stop; count 1–10; must finish to 8 if risen; fail by 8 = RSC. Falling = Gam-jeom (listed exceptions). | Art.18.1.1–1.4 | DOCUMENTED | WT Competition Rules 2026 |
| Sambo | FIAS Sport | Yes. Ground work continues (hold-down / painful hold). Ref stops if inactive / off-mat / time expired → standing restart. | Interrupt if not active enough on ground; 20s hold-down; 60s painful hold then middle restart | SECONDARY (2023 Sport PDF URL 404; matches FIAS snippet + reprint) | sambo.sport documents · fightencyclopedia FIAS-Sambo-Rules |
| Sambo | FIAS Combat | Yes. “Bout in a ground position.” Inactive ground → interrupt; KD/KO is a 10-count stop, not stand-and-box restart. | Art.14 interrupt; Art.23.A.4 ground continues | DOCUMENTED | fightencyclopedia FIAS-Combat-Sambo-Rules |
| Wrestling | UWW FS + GR Jan 2026 | Yes. Takedown → par terre continues; bottom may stand or counter. If attack dies, ref stops after “a reasonable period of time” → standing restart. No numbered seconds. | Art.44 | DOCUMENTED | cdn.uww.org wrestling_rules.pdf |
| BJJ | IBJJF v6.1 Jun 2024 | Yes. Entire match stand-or-ground; out-of-area restart standing or same ground position. No “stand after N seconds” of legal ground. | 1.3.7 | DOCUMENTED | IBJJF books · UFAF reprint |

### 2 — Strikes to a grounded opponent

| Sport | Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|---|
| Boxing | ABC | Illegal | “not allowed to hit a fighter when they are considered down.” | DOCUMENTED | ABC Referee Manual 08/2025 |
| Boxing | WBC | Illegal by procedure (neutral corner during count). Explicit “hitting downed” sentence | — | DOCUMENTED (procedure) / NOT FOUND (explicit foul line in synthesized PDF) | WBC championship PDF |
| Kickboxing | GLORY 2026 | Illegal | 5.07.B.1 continuing to fight if any body part other than feet on ground | DOCUMENTED | glory-rules-2026-v2.pdf |
| Kickboxing | K-1 WGP | Illegal | Art.6(9) attack on fallen or rising | DOCUMENTED | K-1 official |
| Kickboxing | ONE KB | — | — | NOT FOUND | onefc.com/martial-arts |
| Kickboxing | WAKO K-1 | Illegal as soon as one hand or knee touches floor | Ch.10 Art.5 | DOCUMENTED | WAKO + 2026 K-1 Style change PDF |
| Kickboxing | WAKO Low Kick | Illegal + stomps = minus or DQ | Ch.9 Art.5 | DOCUMENTED | WAKO Low Kick |
| Kickboxing | ISKA-ABC Pro | Illegal | Foul F: down = any part other than soles on canvas | DOCUMENTED | ISKA-ABC Unified Pro |
| Muay Thai | IFMA | Illegal | 31.2.12–14; 31.6 striking while on ground | DOCUMENTED | IFMA v3.0 |
| Muay Thai | Lumpinee | Illegal | 18.4–18.5 | DOCUMENTED | lumpineestadium.com/rules |
| Muay Thai | ONE MT | — | — | NOT FOUND | onefc.com/martial-arts |
| Karate | WKF 2026 | Immediate hand follow-up legal (IPPON); kicking a flat-down opponent is a foul (new 2026) | 8.6 IPPON; 9.1.1(16); Bulletin: only hand techniques toward downed | DOCUMENTED | WKF 2026 + Bulletin V2 |
| Taekwondo | WT | Illegal — Gam-jeom for attacking fallen (intent enough) | 14.4.1.10 | DOCUMENTED | WT 2026 Art.14 |
| Sambo | FIAS Sport | Strikes prohibited entirely | Art.34 strike/scratch/bite (older); news: no direct impact to face | SECONDARY | FIAS reprint / news |
| Sambo | FIAS Combat | Legal only if both on ground, or grounded strikes standing; standing→grounded illegal; no elbow/head on ground | Art.23.F.5–6 | DOCUMENTED | FIAS Combat |
| Wrestling | UWW | No strikes in the sport | — | DOCUMENTED | UWW Jan 2026 |
| BJJ | IBJJF | Illegal — DQ traumatic blows | 6.1.3 punches/elbows/knees/kicks etc. | DOCUMENTED | IBJJF v6.1 |

### 3 — Submissions

| Sport | Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|---|
| Boxing / Kickboxing / IFMA / Lumpinee / WT | Listed bodies | Illegal / not part of sport | GLORY 5.07.A.9 strangulation/submissions; K-1 Art.6(5); ISKA Foul P; IFMA 31.2.10 | DOCUMENTED | cited PDFs |
| Kickboxing / MT | ONE KB / ONE MT | Official pages do not list submissions | — | NOT FOUND | onefc.com/martial-arts |
| Karate | WKF | Not a scoring/legal win; clinch/grab only to score or takedown immediately | 9.1.1(11)–(13) | DOCUMENTED | WKF 2026 |
| Sambo | FIAS Sport | Joint locks (painful holds) legal on ground; choke/strangle prohibited | Art.34(b); 20s hold-down; painful-hold clock then stand | DOCUMENTED (news) + SECONDARY (older Art / 2023 snippet) | FIAS |
| Sambo | FIAS Combat | Painful holds + chokes legal, standing or ground; 1 minute each | Art.23.C–D | DOCUMENTED | FIAS Combat |
| Wrestling | UWW | No submissions. Tapping in danger can be treated as a fall, not a tap-win | Art.42 | DOCUMENTED | UWW Jan 2026 |
| BJJ | IBJJF | Legal (belt/age table restricts some); win by tap/verbal/scream/unconsciousness | Art.2.1; Art.6 illegal table | DOCUMENTED | IBJJF v6.1 |

### 4 — Does the throw / dump / sweep itself SCORE?

| Sport | Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|---|
| Boxing | ABC / WBC | No throw/sweep in the sport; KD from a legal punch scores the round (10-8 typical), not a throw | Unified mandatory 8 | DOCUMENTED | ABC Unified 2016 |
| Kickboxing | GLORY 2026 | Throws/sweeps do not score — fouls | 5.07.A.10 | DOCUMENTED | glory-rules-2026-v2.pdf |
| Kickboxing | K-1 WGP | Throws banned — do not score | Art.6(5) | DOCUMENTED | K-1 official |
| Kickboxing | WAKO K-1 | Hip/torso/hand throws illegal; ankle-level foot sweep legal to unbalance (setup, not a listed point value); KD from a strike scores | Art.4.4 / Art.5 | DOCUMENTED | WAKO Ch.10 |
| Kickboxing | WAKO Low Kick | Same ankle sweep legal; wrestling illegal | Art.4.3 + Art.5 | DOCUMENTED | WAKO Ch.9 |
| Kickboxing | ISKA-ABC Pro | Throws/sweeps/reaps/takedowns fouls — no score | Foul P | DOCUMENTED | ISKA-ABC Unified Pro |
| Kickboxing | ISKA AMA K-1 | Throws and sweeps illegal | Illegal Techniques | DOCUMENTED | AMA 2025 — disagrees with WAKO on sweeps |
| Muay Thai | IFMA | Throw without a strike does not score; off-balance from a scoring MT skill can count as that skill; hip throw / non-MT trip / tackle = foul | 29.2.2; 31.2.7; 29.1.2 | DOCUMENTED | IFMA v3.0 |
| Muay Thai | Lumpinee | Judo/wrestling/throw-down = foul; scoring = fist/kick/knee/elbow | 18.2, 18.5, 17.7 | DOCUMENTED | lumpineestadium.com/rules |
| Muay Thai | ONE MT | Legal throw can win by KO; whether a non-KO throw scores points | KO list includes legal throw | DOCUMENTED (KO); point-score NOT FOUND | onefc.com/martial-arts |
| Kickboxing | ONE KB | KO list has no “legal throw” (unlike ONE MT) | punch/kick/knee only | DOCUMENTED (no throw-KO); sweep score NOT FOUND | onefc.com/martial-arts |
| Karate | WKF | Throw is a setup; score is the immediate technique (IPPON if opponent down). Throw alone without follow-up → YAME, no score | 7.10; 8.6; 9.1.1(5) | DOCUMENTED | WKF 2026 |
| Taekwondo | WT | Fall usually Gam-jeom on the fallen, not a throw score | 14.4.1.2 | DOCUMENTED | WT 2026 |
| Sambo | FIAS Sport + Combat | Yes — throws score 1/2/4; clean throw can be total victory | Combat Art.23.B / 25; Sport hold-downs 4 pts (20s) / 2 pts (10–19s) | DOCUMENTED (Combat) / SECONDARY (Sport) | FIAS |
| Wrestling | UWW FS + GR | Yes — 2/4/5-pt throws; fall wins | Art.37–38, 42 | DOCUMENTED | UWW Jan 2026 |
| BJJ | IBJJF | Yes — takedown 2 pts; sweep 2 pts after 3s stabilize | Art.3.1 | DOCUMENTED | IBJJF v6.1 |

### 5 — How long may a ground exchange last? (+ timed studies)

| Sport | Body | Finding | Rule text or number | Label | Source |
|---|---|---|---|---|---|
| Boxing / Kickboxing / IFMA / Lumpinee / WT | Listed | No ground exchange. Numbered item is the count: mandatory 8; 10 = out (K-1 text: 9s to rise). Out-of-ring 20s (ABC/WBC/IFMA). | See §1 | DOCUMENTED | cited |
| Kickboxing / MT | ONE | No published ground-time or stand-up clock | — | NOT FOUND | onefc.com/martial-arts |
| Karate | WKF | Immediate follow-up only; no numbered ground seconds | 7.10(f) “immediately” | DOCUMENTED | WKF 2026 |
| Sambo | FIAS Sport | Hold-down 20s (4 pts at 20; 2 pts at 10–19). Painful hold 60s then standing restart. No overall max ground-spell with n | 2023 Sport snippet | SECONDARY | FIAS 2023 snippet |
| Sambo | FIAS Combat | Hold-down 20s (2 pts; one scored hold-down/bout). Painful or choke 1 min then standing restart. Inactive ground → whistle, standing restart | Art.23.E / C / Art.14 | DOCUMENTED | FIAS Combat |
| Wrestling | UWW | No numbered par-terre clock. “Reasonable period of time” then stand-up if attack dies. FS passivity activity period 30s (not a ground-spell study) | Art.44; Art.38 | DOCUMENTED | UWW Jan 2026 |
| BJJ | IBJJF | No numbered stand-up for a live ground exchange. 3s stabilize to score | Art.3.1 | DOCUMENTED | IBJJF v6.1 |
| All | Empirical timed study of ground-spell length with sample size n | — | — | NOT FOUND | — |

#### GAPS

| Gap | Notes |
|---|---|
| Live FIAS Sport / Combat PDFs on sambo.sport | Upload 404 on access day; used reprints + snippets |
| ONE KB / ONE MT full foul list + grounded-strike + stand-up timer | Marketing page only — do not invent “no ground” as a ONE quote |
| WBC explicit “hitting downed” foul sentence | Procedure documented; standalone foul line NOT FOUND in synthesized PDF |
| Empirical ground-spell duration study with n | NOT FOUND |
| ISKA AMA vs WAKO on sweeps | Kept as separate disagreeing rows |

#### Closing — what a simulated bout should do when someone hits the floor
Boxing (ABC / WBC): Stop the exchange, park the standing man, run the mandatory eight / ten-count — never wrestle or submit.

Kickboxing (GLORY / K-1 / WAKO / ISKA): Same — count, not ground fighting; treat throws/sweeps as fouls except WAKO’s ankle sweep (still no ground fight after the fall).

Muay Thai (IFMA / Lumpinee): Count and stand them up; no submissions; a dump without a strike does not score at IFMA. ONE MT may allow a KO by legal throw, but published rules do not authorize continuing on the ground.

Karate (WKF 2026): Brief window for an immediate hand IPPON only; then YAME — no wrestling, no kicks to a flat-down opponent.

Taekwondo (WT): Kal-yeo + recovery count (clock stopped); attacking the fallen is a Gam-jeom — never a ground bout.

Sambo (FIAS): Continue on the ground — Sport: hold-downs and joint locks, no chokes/strikes; Combat: hold-downs, locks, chokes, and ground strikes only when both are down.

Wrestling (UWW FS + GR): Continue in par terre; throws score; no submissions; stand up after a “reasonable period” if the attack dies.

BJJ (IBJJF): Stay on the ground; score takedown/sweep; finish by submission; never by strikes.

End K36. The 150/400 muay thai submission finishes are illegal under IFMA/Lumpinee — fix the engine to the rows above.

