# G90 - OFFICIALS AS PEOPLE, AND COACHES RANKED

> Grok (Expert), reply to `G90_BRIEF.md`, collected verbatim by Claude in S70
> (2026-09-24) from https://grok.com/c/585f8d3a-7e47-4d92-b821-a8e234b6a745 .
> innerText of the reply; source-link chips (e.g. "Web.archive", "Boxrec")
> were stripped; table cells tab-separated as rendered. Feeds S74 (officials +
> coach board).

FightCamp, 2026-09-24. Research only. Existing baseline: JudgePanel.gd seats N judges with a small anonymous per-bout multiplier on secondary criteria only; damage and knockdowns are never perturbed (J1 §3.2). J14 / G35: referee is scenery except count, announced deductions, stoppage reason — "not a ref AI." Coaches already exist as staff (technical_teaching / tactical_rating / youth_development / capacity); rival gyms seed one coach each.

## 1. Judges as people — measured

Yes, individual judges have stable, public records. No, there is no official public rating that a commission publishes as a leaderboard.

### Where the records live

- MMADecisions.com keeps a page per judge: decision count, split/majority share, media-agreement rate, and bout-level cards. Volume is extreme and concentrated: Sal D'Amato ~1,302 decisions; Derek Cleary ~774; Chris Lee ~751; Michael Bell ~707 (MMADecisions "Most Decisions"). D'Amato worked 101 UFC decisions in 2025 alone.
- BoxRec stores official boxing cards per official (judge and referee as separate IDs). Adalaide Byrd: 1,000+ boxing bouts across 1982–2026. Cards are public; tendencies are not summarised by BoxRec into a rating.
- SCORE Sports Data Repository (Skinner et al., 2024): ~5,000 MMA decisions with per-judge scores, deviations from colleague average, and agreement flags. Built for reliability / dissent work.
- Scott Fontana / Couchside Judges (2022 chart): 20 judges with ≥50 UFC/Bellator/PFL rounds in one year. Per-judge round-winner dissent %, plus lone 10-8 vs lone 10-9. That is the closest public "personality" table in MMA.

### Between-judge spread vs within-judge noise

Measured, not folklore:

Signal	Size	Source
Exact same score on a UFC round	76.9% of 5,238 rounds (2011–2020)	AgentMMA / LiteralFightNerd
At least one judge differs on a round	23.1%	same
Consensus scoring changes the winner	2.47% of 4,129 decisions (standard vs round-by-round consensus)	Berthet
Unanimous 10-8 among judges, when a 10-8 is in play	8.7% (2001–12) → 26.1% (by 2017, after ABC liberalised 10-8)	Gift 2018 / 2021
Share of all UFC judge-rounds that are 10-8	~3.8% since 2015; peaked ~6% in 2017, down to 2.17% in 2024	Fight Algorithm
10-7s	9 times in 11 years of UFC cards	Fight Algorithm

Read: judges disagree on margin far more than on winner. Between-judge spread is real on 10-8 frequency and on secondary criteria. It is small on "who won a clean 10-9." That matches the current JudgePanel.gd design (perturb secondary only).

Holmes, McHale & Żychaluk (EJOR 2024; Liverpool thesis 2022) go further: a Bayesian hierarchical model of individual judges finds stable per-judge weights on actions (strikes vs control vs aggression). Preferences can flip a close bout. Same papers also find home-crowd bias and rank/reputation bias, after controlling for betting odds. Gift (J. Sports Econ. 2018): no titleholder or deduction bias; yes bias toward large betting favorites, fighters with an insurmountable lead, and the previous-round winner.

Boxing home-country / crowd: Balmer, Nevill & Lane (J. Sports Sci. 2005) — for equally matched boxers, P(home win) ≈ 0.57 KO / 0.66 TKO / 0.74 points. Fumarco, Ahmed & Sivec (SSRN 2025 preprint): White boxers score higher from White judges in US boxing; effect grows with White city share. Olympic amateur is a different animal (see below).

### Damage vs volume

ABC Unified Rules rank effective striking/grappling (impact) over volume, then aggression, then cage control. Gift's 10-8 paper and the Holmes preference model both say judges do not share one damage/volume weight. Some lean impact; some lean activity. CompuBox vs cards is a weak instrument: CompuBox itself says the fighter who out-lands wins ~90% of the time, and also says the clicker "in no way determines a winner." Quality of punch is invisible to the clicker. Do not treat CompuBox-card residual as a judge's "volume preference" without video coding.

### Commissions assign by grade / experience — internally

- Nevada: license + written exam + video scoring + 6–12 month mentorship under a Senior Judge. Assignments are commission-side, not a public grade. Ideal applicant is already working another commission or ABC/USA Boxing / ISKA etc. Eye exam required annually.
- ABC Ring Officials Certification: assignments should use experience, recent performance, reliability, attitude, bout difficulty, and ABC seminar attendance (recommended yearly). No public score.
- Title fights pull a small travelling pool (D'Amato, Bell, Cleary, Lee, Colon, Cartlidge, Kamijo, Lethaby). That is de-facto grade, not a published Elo.

Public judge rating: NOT FOUND as an official product. Fan/media proxies exist (MMADecisions media-agreement; Fontana dissent %). Commissions review internally (e.g. NSAC called a session after Mike Bell's 10-8 in Grasso–Shevchenko 2; ED Jeff Mullen: "one of the very best… I do not agree with this round"). Byrd was sat after Canelo–GGG 118–110, then relicensed. That is discipline, not a leaderboard.

### Amateur / Olympic caveat (do not copy into pro sim)

Rio 2016: AIBA removed officials mid-Games; later sidelined all 36 Rio R&Js and killed the "five-star" program. McLaren (2021) found an appointment system that put compliant or incompetent officials on specific bouts — "in the vicinity of 11" manipulated or suspicious Olympic/qualifier bouts. That is corruption of assignment, not a measurable scoring taste. FightCamp pro panels should not inherit Olympic "star grades."

## 2. Referees as people — measured

Workload is counted. Style is mostly anecdote plus one thin outcome-rate scrape. There is no public early/late-stoppage clock per referee.

### What is counted

Fight Encyclopedia (8,457 UFC fights): Herb Dean 1,217; Marc Goddard 588; John McCarthy 517; Dan Miragliotta 504; Mark Smith 463… 237 unique refs. That is assignment volume, not timing.

Yahoo / Tapology 2025 UFC workload: Goddard led the year (incl. 10 title fights); Dean 51 fights / 5 titles. Confirms a travelling elite pool, same as judges.

Shurzy (claims a 10,187-fight scrape; method not peer-reviewed):

- McCarthy: 12% lower decision rate than average (stops more).
- Leon Roberts: 10% higher decision rate (lets more go).
- Goddard: near league average.

Treat as directional, one source. If baseline decision rate is ~50%, McCarthy ~44% / Roberts ~55% is a real band — but it is finish-rate, not "seconds late." Shurzy's own betting note admits: "There is no publicly maintained metric showing early vs late stoppages by referee." That sentence is the state of the art.

### What is NOT FOUND as a dataset

- Seconds-from-unanswered-shots-to-wave-off, per ref.
- Warning count / deduction rate per ref (commission bout sheets exist; nobody has published a panel).
- MMA stand-up frequency per ref (anecdote only: Goddard's two stand-ups in Chimaev–Du Plessis at UFC 319, defended by Dean).
- Amateur boxing standing-count habits per referee.

### Anecdote that changed practice (not a stat)

Late: Dean–Dollaway/Murtazaliev; Dean–Trinaldo/Herbert (Hardy confrontation); Goddard–Perry/Roberts (Goddard admitted it); Yamasaki-era ground-and-pound; Falcao–Mineev (Goddard/McCarthy called it "shameful"). Early: Herzog and MacDonald draw "too soon" piles; Dean is high-variance both ways, which is why a single "early/late" slider on Dean would be false. After enough blow-ups, ABC language on "intelligent defense" and ref seminars tightened; that is institutional, not a named-ref stat.

J14 still holds. Engine-worthy referee facts remain: the count, the announced deduction, the stoppage reason. A named ref with a small stoppage-threshold and foul-strictness band is optional flavour on top of that — not a ref AI.

## 3. Coaches ranked — what the real world actually uses

No Elo of "coaching skill." Every public honour is pupils' year.

Honour	Who votes	What it rewards
BWAA Eddie Futch–John F.X. Condon Trainer of the Year (since 1989)	Boxing writers	A champion or breakout year attached to that corner. 2024: Robert Garcia (2nd). Nominees are always "who rode the best horse."
The Ring Trainer of the Year	Magazine / industry	Same. 2024 Garcia; 2025 nominees Garcia, Robles, Rudy Hernandez, Shingo Inoue, BoMac — each cited for specific title wins that year.
World MMA Awards — Shawn Tompkins Coach of the Year	Fighters Only / industry	"Most successful coach at top-level MMA." 2024–25 John Wood; 2023–24 Plinio Cruz (Pereira year); prior: Wittman, Bareman, Mike Brown, Kavanagh, Jackson.
World MMA Awards — Trainer of the Year	same	Specialist (S&C / nutrition / physio), not the head coach. Linden, Daru, Curson, Dolce, Larios. Do not mix this with head-coach rank.
World MMA Awards — Gym of the Year	same	Roster success plus "helped develop the sport outside the elite." ATT has won it repeatedly; Fighting Nerds 2023–24 on four rising contenders.

Gym rankings that look like numbers: Combat Edge ranks 66 gyms by mean active-roster Elo (min 5 rated fighters). 2026 snapshot: Eagles MMA 1813 (n=5, Makhachev), ATT 1709 (n=47), Jackson-Wink 1662, City Kickboxing 1653. Explicit disclaimer: this is roster strength, not coaching quality. Tapology's new fighter rankings are last-six-bouts performance, not gyms. Media "best gym" lists (LowKick, MMA Explained) are notable-alumni + current champions.

Metric that actually gets used: title-winning or ranked pupils in the last 12–18 months. Secondary: depth of the active roster. Not: session quality, teaching hours, or youth pipeline — those are invisible except as future champions.

That maps onto FightCamp staff fields without invention: tactical_rating / technical_teaching produce the pupils; the leaderboard should count what the pupils did, not the hidden stat.

## 4. How games do it

Football Manager (the only mature named-official sim). Officials are database people with reputation + strictness / allowing fouls / cards. A strict ref + an aggressive tactic = more yellows/reds. Players plan around the named official. Attributes are 1–20 internally; FM26 staff-side display is words (Unsuited → Elite). There is no "this ref hates your club" RNG robbery. Manager reputation tables and Manager of the Year exist; they track league position / trophies, not a mystical aura.

EA FC / FIFA: a match setting (Very Lenient → Very Strict), not named officials with careers.

Undisputed (2024): licensed coaches, cutmen, managers as career staff with fees and training/heal effects. Devs stated ringside judges "weigh performances differently" (split cards, mid-fight score predictions that can be wrong) and promised real referees. Officials are flavour + slight scoring drift, not a scouting puzzle. Fight Night Champion: generic ref/judges, no scouting layer.

No fight-management game exposes a judge panel the way FM exposes a referee. Closest analogue is FM's pre-match official check.

## 5. Propose for FightCamp

Keep J1: damage and knockdowns never perturbed. Named people sit on top of that, with small, evidenced bands. A judge who "robs you" as pure RNG is the thing that would feel unfair and is the thing the data does not support (winner flips on ~2.5% of decisions when you swap to consensus).

Ranked by evidence

### A. Model — evidenced

- Judge consistency / dissent rate (band ~10–30% round-dissent among busy judges; Fontana / MMADecisions). Visible as "agrees with panel" on a scout sheet. Source: public cards.
- Judge 10-8 appetite (tight band: most judges 10-8 on ~2–6% of rounds; a few sit higher). Source: Gift + Fight Algorithm + Fontana lone-10-8 counts. Use this, not a "damage vs volume" cartoon, unless you later fit Holmes-style weights.
- Judge secondary-criteria weight (already in JudgePanel.gd). Keep it small. Optionally persist it on the person instead of redrawing every bout — that is the only change needed to make judges "people." Redraw = noise; persist = personality. Evidence favours persist-with-noise, not persist-as-destiny.
- Home / crowd lean (small). Balmer boxing points P(home) ~0.74 when quality is equal; Holmes MMA home-crowd + rank bias after odds control. Cap it. Never let it flip a 10-8 damage round.
- Commission grade as assignment filter, not a stat the player edits. Junior / carded / championship. Matches NSAC mentorship + ABC "experience + recent performance." Title fights draw from the championship pool. Player sees names; player does not pick the panel.

### B. Model — thin but usable (ref)

- Ref stoppage threshold (early / average / late). Band should be small: Shurzy's ±10–12% decision-rate is the only counted spread; there is no seconds-late table. Default = average. Famous names can sit one tick off centre. Do not simulate a ref AI, stand-up brain, or "Herb Dean paradox" randomiser. J14 remains: count, deduction, stoppage reason.
- Ref foul strictness (warn vs take a point). Invented band, FM-shaped. Real deduction-per-ref table: NOT FOUND. Keep it visible and mild so dirty styles have a scouting reason to care.

### C. Stay invented or out

- A judge who steals a fight as personality. Unreal at the rate fans imagine; poisonous as game feel.
- Per-judge racial / national "bias" sliders. Evidenced in papers; toxic and unusable as a player-facing trait.
- Olympic-style star-judge corruption.
- Ref stand-up AI, ground-stall personality, amateur standing-count habits. Anecdote only.
- Public official Elo. Does not exist; don't fake one.
- Coach "overall rating" as a published number. Real world ranks pupils, not the coach's soul.

### How the player SEES and USES it

Officials (opt-in depth, championship cards first).

- Bout sheet lists three named judges + one ref, each with two chips: e.g. 10-8: high / dissent: low; ref stop: late / fouls: strict.
- Scout a panel the way FM scouts a ref: if two judges are low-10-8, a "won every round narrowly" volume night is safer than a one-round blow-up plan. If the ref is strict, clinch-foul and fence-grab styles pay a tax.
- Do not let the player hire or bribe officials. Commission assigns from a graded pool. Player influence = choose venue / org whose pool you have scouted, and choose a fight style that matches the panel you drew.
- After the bout, show the three cards and one line of dissent ("J2 10-8 in R2; panel 10-9"). That teaches the trait without a tutorial.

Coach leaderboard.

- Rank coaches (and separately gyms) by a 12-month pupils index, not by tactical_rating:
  - weighted title wins and defences by fighters on that coach's books
  - plus ranked / featured pupils (active roster depth)
  - plus a small youth term if youth_development produced a debut that won
- That is BWAA / Ring / World MMA Awards + Combat Edge roster-Elo, compressed into one table the player already understands.
- Reward: reputation, hire cost, rival-gym poaching heat. Do not let the leaderboard rewrite a coach's teaching stats; those stay inputs, the board is the output.

### What would be unfair or unreal

- A named judge who systematically gifts the house fighter a round. Gift found favorite/lead/previous-round drift, not a robber. If you model drift, cap it under one round on a 3×5 card.
- Using CompuBox-style volume as ground truth the judges "fail." Judges are hired to score impact; the clicker is not the answer key.
- A late-stoppage ref who lets your prospect get destroyed as comedy. That's not a trait; that's a trust break. Late-tick must still respect the existing stoppage reason rules in G35.
- Ranking coaches by hidden teaching numbers the player can't audit. Rank what happened in the last year.

Existing code already has the right skeleton: anonymous secondary jitter, inviolable damage/KDs, ref as reason-codes, coaches as staff with four skills. G90 is "put a name and a small persistent band on the jitter, grade the assignment pool, and hang a pupils-based coach table next to the gym." Everything louder than that is either unevidenced or a robbery simulator.

Still unknown: a published per-referee early/late timing dataset, and a commission-issued public judge rating.
