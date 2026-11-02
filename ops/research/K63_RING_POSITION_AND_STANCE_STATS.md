# K63 — RING AND CAGE POSITION, STANCE AND DEFENCE: THE STATISTICS THAT ACTUALLY EXIST

**Kalli · delivered 2026-09-20 · research only (no code, no repo access)**

> **Provenance.** Collected by Claude from the Grok Bot chat with
> `Tools/grokbots/grokbots.py read --to Kalli --out`, which is Kalli's only delivery channel — it
> has no checkout and cannot push. The text below is Kalli's answer as posted; the chat transcript
> flattens markdown tables into tab-separated lines and they are left that way rather than
> re-typed, because re-typing a sourced table is how a DOI gets attached to the wrong number.
> Every LABEL and DOI is Kalli's own. **Nothing here has been checked against the papers by Claude**
> — a DOCUMENTED label means Kalli opened a source, not that this repo verified it.

K63_RING_POSITION_AND_STANCE_STATS.md
Q1 — Position (cage / fence / ropes vs open)
Quantity	Sport & sample	Number (spread)	LABEL	Source
Share of match time with one or both athletes engaging the cage/fence	MMA (UFC); 91 bouts, Flyweight + Bantamweight + Featherweight; UFC Fight Night 2014–2015 and UFC 168–194 (2015); sex not stratified in the paper (lower-weight sample of that era)	20.91% of total match time (12,977 s cage/fence time)	DOCUMENTED	Anne (Roy) & Antoine (Murphy), 2026, Cambridge Sport Science; DOI 10.62852/css/2026/243; PDF cambridgepublish.com
Mutual stand-up share of bout time (both standing; open or cage-embedded)	Same 91 UFC lower-weight bouts	49.63%	DOCUMENTED	Same DOI 10.62852/css/2026/243
Mutual ground share of bout time	Same	36.17%	DOCUMENTED	Same
Mutual clinch share of bout time	Same	13.36%	DOCUMENTED	Same
Open-space share (not on cage/fence)	Same	79.09% (= 100 − 20.91)	SECONDARY	Derived: 100 − documented cage share from DOI 10.62852/css/2026/243
Mean duration of a single cage/fence spell	MMA / boxing / KB / MT	—	NOT FOUND	Searched Anne & Antoine 2026 full text; Miarka/Coswig UFC time-motion series (DOI 10.1080/24748668.2015.11868861 and related); no spell-length distribution published
Cage/fence entries (or “put on the fence”) per round	MMA	—	NOT FOUND	Same searches; counts of fence entries not reported — only total embedded cage time
Share of bout time in ring centre vs ropes vs corner	Boxing (amateur/Olympic)	—	NOT FOUND	Olympic notational work codes action location (CENT / ROPE / CORN) and reports most actions in the centre (e.g. DOI 10.3390/app142210683, 73 men’s Olympic bouts / 80 boxers, Tokyo 2020 cycle) but does not publish % of bout clock in each zone
Ring-zone time share (centre / ropes / corner)	Kickboxing, Muay Thai	—	NOT FOUND	JHSE Muay Thai/KB time-motion (DOI 10.4100/jhse.2011.63.02) and related MT papers: effort/pause only; no centre-vs-ropes occupancy
Separate men’s vs women’s cage-time %	UFC	—	NOT FOUND	Anne & Antoine do not split by sex; Miarka gender papers compare standing/ground activity times, not cage/fence occupancy
Q2 — Control and pressure
Quantity	Sport & sample	Number (spread)	LABEL	Source
League-wide mean “control time” as % of UFC bout (FightMetric/UFCStats control clock)	UFC	—	NOT FOUND	UFCStats/FightMetric publish control time per fight/round; no peer-reviewed or UFC.com aggregate mean control-% across a named multi-year sample was found. Excluded: Bloody Elbow / blog “~1:54 ground control per 5 min” (not peer-reviewed)
Official UFC judging “octagon control” as a published numeric share	UFC	—	NOT FOUND	Unified Rules list Octagon Control as a judging criterion; no governing-body table of scored control minutes or %
Forward-pressure / “who advances vs retreats” share of bout time	MMA, boxing	—	NOT FOUND	No peer-reviewed or federation aggregate of advance vs retreat time
Ring generalship as a scored numeric rate	Boxing	—	NOT FOUND	Judging criterion only; ECSS/abstract ring-occupancy tracking (e.g. French elite sample, n=32 fights) reports distance travelled / heatmaps, not a published generalship % usable as a rule
Winners vs losers: more successful grappling / positional actions raise win probability	UFC; 1,752 rounds from 584 bouts, 67 events, 2013–2014	Logistic model performance probability 69.6% overall; head strikes landed at distance, offensive passes, and takedowns landed were the strongest win predictors (Wald) — not a control-time %	DOCUMENTED	Miarka et al., 2017, Int J Perform Anal Sport; DOI 10.1080/24748668.2017.1360103
Q3 — Striking by position (distance / clinch / ground)
Quantity	Sport & sample	Number (spread)	LABEL	Source
Peer-reviewed aggregate share of all significant strikes that are distance vs clinch vs ground (one % trio for a named UFC sample)	UFC	—	NOT FOUND	Miarka et al. 2017 (DOI 10.1080/24748668.2017.1360103) record attempts/landed by phase (distance, clinch, ground) over 1,752 rounds / 584 bouts, but the open abstract/results accessed here do not publish a single sample-wide % split of all strikes by phase. UFCStats lists distance/clinch/ground per fight; blogs/Kaggle aggregates excluded
Per-fight positional strike totals available as official data product	UFC (FightMetric era onward)	Per-fight and per-round distance / clinch / ground landed & attempted (no single league % in-source)	DOCUMENTED	ufcstats.com (FightMetric methodology); coverage described in third-party API docs summarising the same fields
Stand-up vs ground vs clinch as time shares (not strike shares)	Same Anne & Antoine sample	Stand 49.63% / ground 36.17% / clinch 13.36% of bout time	DOCUMENTED	DOI 10.62852/css/2026/243 — use for position time, not strike mix
Accuracy (landed/attempted) by phase, sample-wide means	UFC	—	NOT FOUND	Same Miarka series compares winners/losers by phase actions; no verified published table of mean accuracy % for distance vs clinch vs ground across the full sample was retrieved
Women-only positional strike mix	UFC women	—	NOT FOUND	Miarka female MMA papers exist (e.g. DOI 10.1080/24748668.2016.11868907, 174 rounds) but no verified aggregate distance/clinch/ground strike-share % pulled for this pack
Q4 — Stance
Quantity	Sport & sample	Number (spread)	LABEL	Source
Southpaw share of elite professional boxers	Boxing, men; top 20 active pros in each of 17 weight classes (n = 340)	25% southpaw (85/340); 75% orthodox	DOCUMENTED	Czyż et al., 2014, Anthropological Review; DOI 10.2478/anre-2014-0025
Southpaw share, broader ranked pro sample	Boxing, men; top 2,549 highly ranked pros	20% southpaw (522/2,549); among top 50: 24% southpaw	DOCUMENTED	Same DOI 10.2478/anre-2014-0025
Win ratio orthodox vs southpaw (elite pros)	Same n=340	Orthodox mean win ratio 0.88 (SD 0.12); southpaw 0.87 (SD 0.11); no significant stance effect on win %	DOCUMENTED	Same
Both stances win more often vs orthodox than vs southpaw opponents	Same	Reported as higher victory % against orthodox than against southpaws for both groups	DOCUMENTED	Same
Southpaw / orthodox / other share in MMA	MMA; n = 1,468 fighters with stance data (from FightMetric-sourced scrape; authors treat source as validated)	17.4% southpaw; 80.3% orthodox; 2.3% other (switch/open combined)	DOCUMENTED	Baker & Schorer, 2013, PLOS ONE; DOI 10.1371/journal.pone.0079793
Win % by stance (MMA)	Same	Southpaw 64.0% (SD 20.4) vs orthodox 62.6% (SD 21.3); not significant (p = .33)	DOCUMENTED	Same
Stance associated with career length (fight count)	Same	Southpaws more fights on average (22.01 vs 19.69); small effect (d ≈ 0.15)	DOCUMENTED	Same
Switches of stance per round or per bout (event rate)	Boxing / MMA	—	NOT FOUND	Baker & Schorer’s 2.3% is a career-labelled “other” stance category, not switches counted inside bouts. No peer-reviewed switches-per-round rate found. Betting-site stance tables excluded
Separate elite women’s southpaw %	Boxing / MMA women	—	NOT FOUND	Czyż and Baker/Schorer samples are not women-stratified
Left-hand preference and success (national sample)	Boxing, Turkey; n = 22 boxers	Left-handers significantly more successful (p < 0.01) — handedness, not stance %	DOCUMENTED	Gursoy, 2009, Br J Sports Med 43:142–144; DOI 10.1136/bjsm.2007.043547; small-n, treat cautiously
Q5 — Defence
Quantity	Sport & sample	Number (spread)	LABEL	Source
Striking defence rate = share of opponent significant-strike attempts that miss	UFC official fighter pages	Defined and published per fighter as Str. Def. %; no peer-reviewed or UFC.com league-wide mean for a named multi-year sample	DOCUMENTED (definition + per-fighter); league mean = NOT FOUND	ufcstats.com fighter detail / stat leaders; methodology: opponent misses ÷ opponent attempts
Sample-wide mean UFC striking accuracy (implies defence ≈ 1 − accuracy if mirrored)	UFC analytics blogs	—	NOT FOUND	Blog claims (~40% accuracy ⇒ ~60% defence) excluded; no peer-reviewed sample mean confirmed here
Share of evasive defensive actions that are dodges vs blocks	Boxing, men; Welter, London 2012 Olympics; 8 boxers, 42 rounds	Of evasions: 52.20% ± 13.08 dodges (trunk/neck/foot); 47.80% ± 13.08 blocks (guard/hands)	DOCUMENTED	Puchol Devesa & Caparrós Pons, 2020, J Phys Educ Sport; DOI 10.7752/jpes.2020.s3277
Time share of round spent dodging vs blocking	Same	%T dodges 15.44% ± 5.04; %T blocks 6.35% ± 3.13; also %T travel 55.78% ± 5.85, %T blows 16.07% ± 5.63, %T null 6.35% ± 2.50	DOCUMENTED	Same DOI 10.7752/jpes.2020.s3277
Defensive actions credited per minute (UFC or boxing federation rate)	MMA / boxing	—	NOT FOUND	No governing-body “defences per minute” leaderboard; notational papers report counts per round in small Olympic samples, not a standard per-minute rate
Move-defence vs block-defence split in MMA	UFC / MMA	—	NOT FOUND	UFCStats does not split significant-strike defence into slip/roll vs cover; no peer-reviewed MMA dodge/block share found
Women-only dodge vs block share	Boxing / MMA women	—	NOT FOUND	Puchol sample is male welter only
What I could not find

Searches that came back empty (peer-reviewed / governing-body / fight-DB aggregate only; blogs, YouTube, and coaching sites excluded):

Cage/fence spell length (mean or distribution of continuous fence engagements) and fence entries per round — not in Anne & Antoine 2026 or Miarka UFC time-motion series.
Boxing / kickboxing / Muay Thai % of bout clock in centre vs ropes vs corner — location-of-action codes exist; time-in-zone shares do not.
Sex-stratified cage-time % (men’s row and women’s row).
League-mean UFC control time % and any numeric octagon-control / ring-generalship rate from judges or UFC.com.
Published sample-wide % of significant strikes that are distance vs clinch vs ground (and accuracy by phase) as one DOCUMENTED triple — phase counts exist in methods; the aggregate % table was not available in sources opened for this pack.
Stance switches per round/bout (event rate) — only career stance labels.
Elite women’s southpaw prevalence.
UFC-wide mean Str. Def. % and MMA move-vs-block defence split; defences per minute as a standard published rate.

Usable anchors for rules right now: cage/fence 20.91% of match time (91 UFC lower-weight bouts, DOI 10.62852/css/2026/243); stand/ground/clinch time 49.63 / 36.17 / 13.36% (same); elite boxing southpaw 20–25% (Czyż 2014); MMA southpaw ~17% (Baker & Schorer 2013); Olympic welter defence mix ~52% dodge / ~48% block of evasions (Puchol 2020). Everything else in the five questions is NOT FOUND or only per-fight raw fields.

1:23 PM




Kalli replied