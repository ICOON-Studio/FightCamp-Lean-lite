# G92 - Submission attempts by style (Grok, VERBATIM)

Collected S72 2026-09-25 from https://grok.com/c/68654a01-8a66-46a1-90ee-252aa18d0bce
(innerText of the reply container, 10,484 chars). Brief: `G92_BRIEF.md`.

## Claude's reading (S72) - not part of Grok's text

- **Q168/Q170's "1.65 attempts per fighter-fight" was PER BOUT.**
  `tools/q168_submission_baseline.gd` counts every `submission_attempt` event,
  both actors, and divides by bouts. Per fighter-fight it is **0.83**, inside
  J20 D6's 0.5-1.0. Per bout, 1.65 sits inside G92's grappler-v-striker sample
  (grappler mean 1.48 / median 2, striker ~0) and Fightnomics' "1-2 attempts in
  the average 15-minute fight". **Not a defect. Nothing handed to Qwen.** The
  tool now prints both units (S72).
- Per-pairing band for J20 D6 (per bout, both men): grappler v striker
  **1.0-2.5**; per fighter-fight 0.5-1.25.
- Caveat on the evidence: the 25 matchup rows are famous bouts of champions and
  contenders (Oliveira, Khabib, Makhachev, Maia...), a selected sample, and 13 of
  20 career conversions use the league-mean fight time because the fighter's own
  AFT was NOT FOUND. The career Sub.Avg rows are the stronger evidence.

---

G92 — Submission attempts by style
Read date: 2026-09-24 / 2026-09-25. Source of fighter rows: UFCStats fighter-details pages. No invented figures.

Note on the unit. UFCStats Sub. Avg. is attempts per 15 minutes, not per fight. Converted att/fight = Sub.Avg × (AFT minutes / 15). Fighter-specific AFT is taken from UFCStats matchup “Average Fight Time” where found. Where AFT is missing, conversion uses the published league mean fight time 10:37 (10.62 min) and is marked as such.

Definition (what counts)

UFCStats glossary line, on every fighter page:
“Sub. Avg. — Average Submissions Attempted per 15 minutes.” SOURCED http://ufcstats.com/fighter-details/07225ba28ae309b6

UFCStats itself does not publish a longer public glossary of the counting rule. NOT FOUND on ufcstats.com beyond that label.

Official FightMetric glossary (UFC’s stats vendor), MMA Fighting, 9 May 2011:
“Submission Attempts — This reflects the number of actual submission holds applied. It does not count movements that only seek a submission, e.g., a fighter on bottom who swings his hips for an armbar but does not lock the arm and apply force.” SOURCED https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary

Fightnomics (Reed Kuhn; FightMetric research fellow), on the same rule:
“For a submission attempt to be counted … the technique must be ‘fully employed.’ That means an arm bar can’t just be grabbing an arm; the recipient’s arm must be extended to tally a real attempt.” And: “any time a technique is fully administered, FightMetric accounts for the attempt.” SOURCED http://eamm.mex.tl/uploads/s/w/3/c/w3cpq5bbb729/file/jYrvOJmz.pdf

So: threatened-but-not-locked does not count. Completed tap is an attempt that finished. Near-miss that is fully locked does count.

Population mean / median

UFCStats published mean or median of Sub. Avg. across all UFC fighters: NOT FOUND.

Published fight-level analog (both fighters combined, not a roster mean of Sub. Avg.):
Fightnomics: “In the average 15-minute UFC fight there will be 1-2 submission attempts, with an overall success rate of about 20%.” SOURCED same Fightnomics PDF / Fightnomics summary https://cdn.bookey.app/files/pdf/book/en/fightnomics.pdf

League mean fight duration 10:37; median 13:48 (8,591 UFC bouts, GrapplerHQ, snapshot to 2026). SOURCED https://www.grapplerhq.com/mma/ufc-statistics/

Implied: if 1–2 attempts occur in a 15-minute fight across both men, that is about 0.5–1.0 attempts per fighter per 15 min — the same band as the engine anchor. That is a fight-population statement, not a UFCStats roster median.

Career Sub. Avg. tables
All Sub. Avg. and records SOURCED from the linked UFCStats pages, read 2026-09-24.

Specialist grapplers (BJJ / sambo / wrestling-submission)

Fighter	Style	Listed record	Sub.Avg /15	AFT	Conv. att/fight	Page
Charles Oliveira	BJJ	37-11-0 (1 NC)	2.6	7:58 SOURCED matchup	2.6×7.97/15 = 1.38	http://ufcstats.com/fighter-details/07225ba28ae309b6
Jim Miller	BJJ / wrestle	38-19-0 (1 NC)	1.7	AFT NOT FOUND; league 10:37	1.20	http://www.ufcstats.com/fighter-details/d1941565abf50b16
Paddy Pimblett	BJJ	24-4-0	1.4	AFT NOT FOUND; 10:37	0.99	http://ufcstats.com/fighter-details/7826923b47f8d72a
Paul Craig	BJJ	17-10-1 (1 NC)	1.3	8:01 SOURCED	0.70	http://ufcstats.com/fighter-details/eabf206b162b3b83
Dennis Bermudez	wrestle-sub	17-9-0	1.1	AFT NOT FOUND; 10:37	0.78	http://ufcstats.com/fighter-details/6f242453c91a5af0
Demian Maia	BJJ	28-11-0	1.0	AFT NOT FOUND; 10:37	0.71	http://www.ufcstats.com/fighter-details/427b5953ac8e3a27
Gunnar Nelson	BJJ	19-6-1	1.0	AFT NOT FOUND; 10:37	0.71	http://ufcstats.com/fighter-details/fd55393021a8c255
Mackenzie Dern	BJJ	17-5-0	1.0	AFT NOT FOUND; 10:37	0.71	http://ufcstats.com/fighter-details/7447e9f28508106a
Islam Makhachev	sambo / wrestle	29-1-0	0.9	11:45 SOURCED	0.71	http://www.ufcstats.com/fighter-details/275aca31f61ba28c
Brian Ortega	BJJ	16-5-0 (1 NC)	0.9	13:49 SOURCED	0.83	http://www.ufcstats.com/fighter-details/def8166ff24bd237
Allan Nascimento	BJJ	22-7-0	0.9	AFT NOT FOUND; 10:37	0.64	http://ufcstats.com/fighter-details/253076a23d03dcd0
Khabib Nurmagomedov	sambo / wrestle	29-0-0	0.8	AFT NOT FOUND; 10:37	0.57	http://ufcstats.com/fighter-details/032cc3922d871c7f
Royce Gracie	BJJ	15-2-3	0.8	AFT NOT FOUND	0.57	http://ufcstats.com/fighter-details/429e7d3725852ce9
Renzo Gracie	BJJ	13-7-1 (1 NC)	0.8	AFT NOT FOUND	0.57	http://ufcstats.com/fighter-details/aae0897825336b1a
Rogerio Nogueira	BJJ	23-10-0	0.8	AFT NOT FOUND; 10:37	0.57	http://ufcstats.com/fighter-details/73e09f837f3b5ecc
Kron Gracie	BJJ	5-3-0	0.7	AFT NOT FOUND; 10:37	0.50	http://www.ufcstats.com/fighter-details/242d36d241b43c12
Raoni Barcelos	BJJ / wrestle	22-5-0	0.7	AFT NOT FOUND; 10:37	0.50	http://ufcstats.com/fighter-details/b9f28e7045fdfce7
Renato Moicano	BJJ	21-7-1	0.6	9:24 SOURCED	0.38	http://ufcstats.com/fighter-details/b6452706b373eea1
Gilbert Burns	BJJ	22-10-0	0.4	AFT NOT FOUND; 10:37	0.28	http://ufcstats.com/fighter-details/23024fdfc966410a
Brandon Moreno	wrestle-BJJ	24-10-2	0.4	AFT NOT FOUND; 10:37	0.28	http://www.ufcstats.com/fighter-details/792be9a24df82ed6

Ivan Salaverry (BJJ, older UFC): Sub. Avg. 2.5. SOURCED http://ufcstats.com/fighter-details/394f55ebca199124 — included as a ceiling case, not a modern volume sample.

Recognised strikers

Fighter	Style	Listed record	Sub.Avg /15	AFT	Conv. att/fight	Page
Justin Gaethje	wrestle-box / pressure	28-5-0	0.0	AFT NOT FOUND; 10:37	0.00	http://ufcstats.com/fighter-details/9e8f6c728eb01124
Stephen Thompson	karate	17-9-1	0.0	AFT NOT FOUND; 10:37	0.00	http://ufcstats.com/fighter-details/4a28cb716c19157a
Jamahal Hill	kickbox	12-4-0 (1 NC)	0.0	10:22 SOURCED vs Craig	0.00	http://ufcstats.com/fight-details/3f7c14c7eca7195d
Rafael Fiziev	kickbox	14-5-0	0.0	11:32 SOURCED	0.00	http://ufcstats.com/fight-details/73e614be7a3aeb89
Israel Adesanya	kickbox	24-6-0	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/1338e2c7480bdf9e
Conor McGregor	box / karate	22-7-0	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/f4c49976c75c5ab2
Jose Aldo	Muay Thai	32-10-0	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/d0f3959b4a9747e6
Edson Barboza	Muay Thai	24-15-0	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/64a50dad704d1d49
Kelvin Gastelum	box	21-11-0 (1 NC)	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/8c0580d4fff106c1
Bill Algeo	striker	18-9-0	0.1	AFT NOT FOUND; 10:37	0.07	http://ufcstats.com/fighter-details/9abc648e76c4493a
Alex Pereira	kickbox	13-4-0	0.2	AFT NOT FOUND; 10:37	0.14	http://ufcstats.com/fighter-details/e5549c82bfb5582d
Sean O'Malley	box	20-3-0 (1 NC)	0.2	AFT NOT FOUND; 10:37	0.14	http://ufcstats.com/fighter-details/b50a426a33da0012
Max Holloway	box / volume	28-9-0	0.3	AFT NOT FOUND; 10:37	0.21	http://ufcstats.com/fighter-details/150ff4cc642270b9
Ilia Topuria	box-first (has one sub win)	17-1-0	0.9	AFT NOT FOUND	0.64	http://www.ufcstats.com/fighter-details/54f64b5e283b0ce7 — mixed, not a clean striker
Cub Swanson vs Ortega (striker row only): Ortega Sub 2, Swanson 0 in that fight. Career Swanson Sub.Avg: NOT PULLED THIS PASS.

Jacare Souza, Rousimar Palhares, Joe Lauzon, Nate Diaz career Sub. Avg.: NOT FOUND in this pull (pages not retrieved).

Matchup rows: specialist grappler vs clear striker
Grappler’s Sub att from the UFCStats fight table. Times = last-round clock, converted to total fight minutes.
Bout	Grappler att	Fight time	Grappler att per fight	Source
Oliveira vs Gaethje, UFC 274	2	R1 3:22 = 3:22	2	http://ufcstats.com/fighter-details/07225ba28ae309b6
Oliveira vs Poirier, UFC 269	3	R3 1:02 = 11:02	3	http://ufcstats.com/fight-details/b22eab3aa1522f40
Oliveira vs Ferguson, UFC 256	3	15:00	3	http://ufcstats.com/fight-details/b7b867eb3c3cf163
Oliveira vs Holloway, UFC 326	4	25:00	4	http://ufcstats.com/fighter-details/07225ba28ae309b6
Oliveira vs Chandler, UFC 309	2	25:00	2	same Oliveira page
Oliveira vs Chandler, UFC 262	0	R2 0:19 = 5:19	0	http://ufcstats.com/fight-details/fef29aa73bd5b907
Oliveira vs Topuria, UFC 317	0	R1 2:27	0	http://ufcstats.com/fight-details/7a64d63e12618ba7
Khabib vs McGregor, UFC 229	1	R4 3:03 = 18:03	1	http://ufcstats.com/fighter-details/032cc3922d871c7f
Khabib vs Poirier, UFC 242	2	R3 2:06 = 12:06	2	same
Khabib vs Gaethje, UFC 254	1	R2 1:34 = 6:34	1	same
Khabib vs Barboza, UFC 219	0	15:00	0	same
Makhachev vs Poirier, UFC 302	2	R5 2:42 = 22:42	2	http://www.ufcstats.com/fighter-details/275aca31f61ba28c
Makhachev vs Hooker, UFC 267	2	R1 2:25	2	same
Makhachev vs Dober, UFC 259	2	R3 1:37 = 11:37	2	same
Makhachev vs Volkanovski I, UFC 284	0	25:00	0	same
Maia vs Condit, UFC on FOX	1	R1 1:52	1	http://www.ufcstats.com/fighter-details/427b5953ac8e3a27
Maia vs Matt Brown, UFC 198	2	R3 4:31 = 14:31	2	same
Maia vs Masvidal, UFC 211	0	15:00	0	same
Maia vs Anderson Silva, UFC 112	0	25:00	0	http://www.ufcstats.com/fight-details/63f744d672fbb8b4
Ortega vs Swanson	2	R2 3:22 = 8:22	2	Ortega fighter page
Ortega vs Volkanovski, UFC 266	3	25:00	3	same
Craig vs Jamahal Hill, UFC 263	3	R1 1:59	3	http://ufcstats.com/fighter-details/eabf206b162b3b83
Pimblett vs King Green, UFC 304	2	R1 3:22	2	Pimblett page
Pimblett vs Gaethje, UFC 324	0	25:00	0	same
Pimblett vs Jared Gordon, UFC 282	0	15:00	0	same

Counted sample n=25. Grappler attempts per fight: 0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,4.

Mean of those 25 = 1.48. Median = 2. SOURCED from the rows above; arithmetic is from those rows only.

Per-fighter-fight (both men / 2): in these bouts the striker’s att is almost always 0 (Poirier vs Khabib is the exception at 1). So per-fighter-fight ≈ grappler att / 2, sample mean ≈ 0.74, with outliers at 2.0 when Oliveira hunts for 25 minutes.

Verdict

1.65 is not a counting defect if it is the grappler’s own attempts per fight: the 25-bout specialist-vs-striker sample sits at mean 1.48 / median 2, Oliveira’s career conversion is 1.38 att/fight, and single bouts reach 3–4. It is a defect if 1.65 is per-fighter-fight (both men averaged). That reading implies ~3.3 total attempts in the pairing; real grappler-vs-striker totals cluster at 0–3, with 4 only in a 25-minute Oliveira hunt. Career Sub.Avg of specialists is usually 0.4–1.7 per 15 min (Oliveira 2.6 is the modern ceiling). Recognised strikers sit at 0.0–0.3. The 82-vs-34 pairing should sit in grappler 1.0–2.5 attempts per fight, striker ~0, which is 0.5–1.25 per fighter-fight. 1.65 per fighter-fight is above that band; 1.65 grappler-only is inside it.
