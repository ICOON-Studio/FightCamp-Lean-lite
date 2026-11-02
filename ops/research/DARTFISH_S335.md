# Dartfish (combat sports) - what it is and whether it helps FightCamp (S335)

Operator ask: "find as much info on this as you can and if it can help us" (https://www.dartfish.com/combatsports/).
Read: the Dartfish combat-sports page, plans, features, game-analysis, Live S and terms pages, the dartfish.tv
knowledge base (tagging panel, CSV export, API articles), the public API release notes, and the boxing studies that
used Dartfish or the same tagging method. Static pages only; no account, no download, no form.

## Short answer

**Partly.** Dartfish is a Swiss video-analysis app that coaches use to film a bout, press buttons while watching
("tagging"), and get a list of clips and counts out of it. It gives a game developer **no data, no dataset and no SDK
we can use**: its API only reads a paying customer's own dartfish.tv channel, is switched on by a Dartfish account
manager, and the licence is for educational, non-commercial use. What it does give us:

1. **A proven design for a "film room" screen**: a panel of buttons (each = a keyword in a category column), an
   events list, filters, playlists and drawings. That is exactly how a real boxing coach studies a fight.
2. **A door to real numbers**: the published amateur-boxing studies coded in Dartfish (Thomson & Lamb, Booth) or the
   same way (Dunn 2017, French Boxing Federation 2023) give per-round punches, hit/miss/air splits and winner-vs-loser
   gaps we can check our fight model against.
3. **A real-world price ladder** (7 / 20-40 / 80 / 180 EUR a month) for a "video analysis" gym upgrade.

## What it is

- Dartfish SA is a Swiss company "with over 20 years in video analysis", used by "thousands of elite sport
  organizations" (combat-sports page). Named combat clients on that page: UFC, United World Wrestling, Fédération
  Française de Karaté, British Judo, USA Taekwondo, France Judo, Israel Taekwondo, Korea Wrestling Federation,
  Fujairah Martial Arts Club. Boxing appears only as a testimonial from John Dovi, manager of a French boxing team,
  who calls it "the ideal tool for observing and analyzing boxing" and uses it to send fights to club trainers.
  [1]
- The combat workflow is three steps [1]:
  - **Capture**: record or import fights; tag key actions live on a phone with *myDartfish Note*, then merge them
    into the desktop app (*360 S*).
  - **Analyze**: drawings, instant replay, annotations; classify highlights and filter the useful moments.
  - **Share**: cloud storage, fighter access from anywhere, playlists.
- **Tagging panel** (the core idea): "simply add a button, tell it which keyword to record and define which column
  (category) of the events list it will appear in"; buttons are grouped in boxes by category; there is also a zone
  tool (where on the body / ring). [5]
- **Live tagging** (Live S tier): "Tag, review and edit actions in real-time while continuing to record", actions
  qualified with "keywords, and zone tools"; "Export data easily and create interactive reports"; data is used to
  "create statistics". [4]
- Other named features: live tagging and post-tagging [3]; predefined tagging panels and custom panels, "Export
  events to CSV", "Import from CSV files", "Dynamic PowerBI reports automatically generated on the Cloud", "Import of
  external data streams" [2]; multi-video, 3D drawings, Simulcam and Stromotion (overlay of two takes) in the top
  tier [2][3].
- **No ready-made boxing stats**: Dartfish ships predefined panels and reports for soccer, tennis and
  baseball/softball [6], none named for boxing, judo or wrestling. Combat users build their own panel. It does not
  count punches by itself; a human presses the buttons.
- In combat sports its biggest official use is **video replay for judges** (taekwondo: judges tag events from an
  electronic judging panel; 9 Pro S laptops for 9 courts in 2022) [13][14], and as a video channel (British Judo's
  "Dartfish TV" workshop collection [17]; a judo study pulled its 2011 Worlds footage from Dartfish.tv's judo channel
  [16]).

## Price and licence

| Plan | Price (annual billing) | What it adds |
|---|---|---|
| myDartfish Mobile | from 7 EUR/month | Express + Note phone apps, 50 GB cloud |
| myDartfish 360 (plans page) / 360 S (combat page) | 20 EUR/month on the plans page; 40 EUR/month on the combat page | desktop editing, annotation, overlays |
| myDartfish Live S | 80 EUR/month | live feeds, **live tagging + tagging panels**, multi-video, 3D drawings |
| myDartfish Pro S | 180 EUR/month | 3D analysis, Simulcam and Stromotion, Live Collaboration |

Sources: plans page [2], combat page [1], Live S page [4]. The two pages disagree on the 360-tier price (20 vs 40
EUR); both show 15-day trials. Team/enterprise pricing is "contact us" [2].

Licence (terms [7]): software is "licensed, not sold"; named-user yearly licence through a dartfish.tv account, or a
per-device licence; auto-renews yearly unless cancelled 30 days before; no reverse engineering; the software is for
educational use and images derived from it may not be sold or broadcast; digital goods "only for your personal,
noncommercial use".

**For a game developer:**
- **API**: there is a dartfish.tv REST API (JSON or XML by the Accept header) that lists a channel's videos,
  collections and **events with their keywords** (`VideoInfoList`, `EventInfoList`, `CollectionInfoList`,
  `EventData`, `IncludeMatchKeywords`), now at v2.4 (2026-04-30) [8]. It reads only a customer's own channel, must be
  enabled per channel, and is activated through "your Key Account Manager at Dartfish" [9][10]. Useless to us: we
  have no tagged channel, and the data would be someone else's.
- **Export**: CSV out of the desktop app and out of myDartfish Note ("export tagging data into CSV format for
  reporting and further analysis") [2][11]. No XML schema is published. Again only useful on footage you tag yourself.
- **SDK, public dataset, published stats**: none found.

## Data we could use

Dartfish publishes no numbers itself. The numbers come from sport-science papers that coded bouts in Dartfish or with
the same button-panel method. Facts and figures, credited, are fine to use as targets.

**What a boxing analyst actually tags** (Thomson, Lamb & Nicholas 2013, J Sports Sci 31(5):516-528 [18]): offensive,
defensive and feint indicators. Our old repo already holds the detail (G54_WHAT_IS_DEFENCE.md, G86_FEINTS.md):
defences slip left / slip right, duck, block-or-parry lead, block-or-parry rear, foot defence; four feint types (foot,
head/trunk, lead hand, rear hand). Reliability: one analyst agrees with himself 80-100% of the time, two different
analysts only 33-100% - **tagging a fight is a skill, and two coaches read the same fight differently.**

**Output per minute** (Thomson & Lamb 2016, IJPAS 16(1):203-215, coded in **Dartfish TeamPro 4.0**, 92 English
amateurs, 11 weights) [19]: about **25 punches and 10 defences per minute**, changed by contest outcome, weight and
ability.

**Per round, winners vs losers** (Dunn et al. 2017, PLOS ONE, 26 elite amateurs, Australian Championships; coded in
SportsCode, same method) [20]:

| Per boxer per 3-min round | Winners | Losers |
|---|---|---|
| Punches thrown | 75.7-78.0 | 78.6-80.7 |
| Hit (on target) | 23.8-26.3 | 17.4-21.1 |
| % hit | 32-33% | 22-26% |
| % miss (touched outside target) | 49-54% | 55-56% |
| % air (no contact) | 13-18% | 19-24% |
| Defensive actions | 29.4-31.8 | 29.6-30.6 |

- Winners do **not** throw more; they **land a higher share**. %Hit alone predicted the winner 76.9% of the time;
  %Hit plus footwork style 84.6%.
- Across rounds: clinch time 11.1 -> 17.1 -> 19.8 s, guard-drop time 24 -> 31 -> 34 s, referee stoppage time
  9 -> 19 -> 25 s, bounce time falls 57 -> 45 s, fatigue rating 1.6 -> 2.2 -> 2.7 of 5. Punch counts stay flat.

**Head vs body and landing rate** (French Boxing Federation, Sauliere et al. 2023, ECSS abstract; 94 three-minute
elite rounds, punches found by glove sensors, then labelled by video analysts as **miss / hit / blocked**) [21]:
per round 144 head punches (56 landing) and 22 body punches (13 landing). These look like both boxers combined (my
reading of 21,474 detections minus 25% false positives over 94 rounds). Head about 39% landed, body about 59%. More
hits raised the odds of winning, more misses lowered them, **blocked punches made no difference**. Video tagging cost
**7.16 s per punch** (37 hours for the set).

**Volume by weight** (Booth poster, 2012 Olympic gold-medal bouts, Dartfish tagging board on the Thomson 2013
template) [12]: punch output light 353, middle 530, heavy 299 (the poster does not state the unit; probably per bout
per boxer). Middleweights threw the most.

Cross-check note: these agree with what the game already uses (G99 CompuBox averages, Thomson in G100/G53). New for
us: the **hit / miss / air / blocked** four-way split, the round-by-round drift in clinch and guard-drop time, and
"winners land a higher share, not more".

## How it helps FightCamp

**(a) Reference for our film study and fight stats.**
- Lean already has the pieces: `scripts/rules/TheRead.gd` (read an opponent habit over repeated looks),
  `scripts/ui/RoundGraphics.gd` (punches landed, 30-second strip, judges' cards), `scripts/rules/CallEvidence.gd`
  (evidence lines for corner calls). Dartfish shows how a real coach feeds those: watch tape, press "jab - head -
  landed", get a list, filter it.
- Stats to show after a bout, in the analyst's words: thrown, hit, miss, air, blocked; head vs body; per round; and
  **% hit** as the headline number (it is what predicts winners [20]). Round drift (more clinch, lower guard, more
  ref breaks in round 3) is a ready check for our fight model.

**(b) Design idea: how coaches tag and review.**
- **Tape room** (an office item or a coach skill): before a booked bout the player "studies tape" of the opponent.
  Each tape watched counts as looks for THE READ, so a coach who scouts arrives with the habit half-read. That puts
  the real expert-vs-novice reading gap (already sourced in TheRead.gd) into the management side.
- **The coach's eye differs**: two analysts agree only 33-100% [18]. A low-skill coach's scouting report can be
  wrong (a habit misread); a good analyst is a staff hire worth paying for.
- **Tagging costs time**: 7.16 s per punch [21], so a full amateur bout (~450 punches for two boxers) is about an hour
  of work. A staff analyst, or software, turns that hour into a report - a real reason to buy the upgrade.
- **Price ladder for a gym upgrade** (real numbers, per the benchmark rule): phone app ~7 EUR/month, desktop
  ~20-40, live tagging ~80, pro ~180 [1][2]. In game: "phone camera" (post-fight clips only), "analysis laptop"
  (tagged report after the bout), "live tagging" (corner gets evidence between rounds), top tier (side-by-side
  overlay of the boxer's own technique vs a model, the Simulcam idea, as a training-quality boost).
- **Panel = button grid with categories**: a clean UI pattern for our whiteboard look - categories as columns
  (punch, target, result, defence), one press = one event, events list underneath, filter by "AND across
  categories, OR inside one" (the API's own query rule `AndWithOrInSameCategory` [8]).

**(c) Things we may NOT use** - see next section.

## What we may not use

- The names and marks: "Dartfish", "myDartfish", "Note", "Express", "Live S", "Pro S", "Simulcam", "Stromotion",
  logos and icons are claimed trademarks [7]. In game we say "video analysis software" or our own invented brand.
- Their UI art, screenshots and icons (copyright Dartfish SA [7]). The concepts (button panel, events list,
  playlists, drawings) are common to every analysis tool and fine to use; draw our own screens in our own look.
- Any footage or data from dartfish.tv channels (federations' content, licence for personal non-commercial or
  educational use only [7]). No API use: it needs a customer channel and a Dartfish account manager [9][10].
- Reverse engineering the app (forbidden by section 8(b) [7]).
- Paper numbers are facts and fine with credit; do not copy the papers' tables or figures as images.

## Verdict and top 3 takeaways

**Partly helps.** No data source or tool for us, but a strong design reference and a pointer to real numbers.

1. **% hit decides bouts, not volume**: winners throw about the same (~77 a round) but land 32-33% vs 22-26% [20];
   blocked punches do not change the outcome [21]. Show % hit as the headline stat and check the fight model
   against it.
2. **Film study is a real coaching system we can turn into a mechanic**: tape room -> tagged events -> scouting
   report -> faster READ of the opponent's habits, with coach skill deciding how accurate the read is (analysts
   agree only 33-100% [18]).
3. **Real prices and real labour for a gym upgrade**: 7 / 20-40 / 80 / 180 EUR a month tiers [1][2] and 7 s of
   tagging per punch [21] give the "video analysis" upgrade and the analyst hire honest numbers.

## Sources

1. Dartfish combat sports page - https://www.dartfish.com/combatsports/
2. Dartfish plans and pricing - https://www.dartfish.com/plans
3. Dartfish features - https://www.dartfish.com/features/
4. Dartfish Live S - https://www.dartfish.com/live_s
5. KB: Create a tagging panel - https://support.dartfish.tv/en/support/solutions/articles/27000048169-create-a-tagging-panel
6. Dartfish game analysis - https://www.dartfish.com/game
7. Dartfish terms - https://www.dartfish.com/terms
8. dartfish.tv API release notes - https://api.dartfish.tv/ReleaseNotes
9. KB: dartfish.tv API and connectivity - https://support.dartfish.tv/en/support/solutions/articles/27000065082-dartfish-tv-api-and-connectivity-with-web-sites-ams-lms-etc
10. KB: Data integration tutorials (API v2.0, Power BI) - https://support.dartfish.tv/en/support/solutions/folders/27000062740
11. KB: Export your notebook CSV (myDartfish Note) - https://support.dartfish.tv/en/support/solutions/articles/27000085712-export-your-notebook-csv-file-mydartfish-note
12. Booth, punch output across weight categories (poster) - https://www.slideshare.net/slideshow/ebl-poster-final-pdf/50200050
13. Dartfish blog: instant replay for taekwondo judges - https://blog.dartfish.com/2014/10/27/case-study-instant-replay-for-taekwondo-judges-2
14. Dartfish blog: instant video replay for taekwondo (2022) - https://blog.dartfish.com/2022/02/21/instant-video-replay-for-taekwondo
15. Dartfish mobile - https://www.dartfish.com/mobile
16. Judo 2011 Worlds study using Dartfish.tv footage - https://core.ac.uk/download/228557757.pdf
17. British Judo, "Dartfish TV" workshop collection - https://www.britishjudo.org.uk/?p=32965
18. Thomson, Lamb & Nicholas 2013, amateur boxing performance analysis template - https://chesterrep.openrepository.com/handle/10034/335797 (record: https://lida.sport-iat.de/dbv/Record/4028534?lng=en)
19. Thomson & Lamb 2016, technical demands of amateur boxing (Dartfish TeamPro 4.0) - https://ideas.repec.org/a/taf/rpanxx/v16y2016i1p203-215.html
20. Dunn et al. 2017, winners vs losers in elite amateur boxing, PLOS ONE - https://pmc.ncbi.nlm.nih.gov/articles/PMC5747423
21. Sauliere et al. 2023, quantifying punches in elite boxing (French Boxing Federation, ECSS) - https://lida.sport-iat.de/dbv/Record/4085916?lng=en

Not found (searched): any GB Boxing or USA Boxing case study with Dartfish; any UFC Performance Institute statement
naming Dartfish (UFC appears only as a logo on [1]); a Dartfish public dataset or SDK; the CSV column layout (it is in
an attached PDF not opened).
