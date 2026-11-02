# J48 - WHO BECOMES A COACH, AND HOW SOON

Research memo for FightCamp (Godot), Stage S72. Compiled 2026-09-25 (Asia/Nicosia). **All sources below were read 2026-09-25 unless a different date is given.** This file has no game code.

This memo replaces the earlier result, which marked both questions NOT FOUND. It uses **three counted samples with fixed rules** (95 people in total). Each person was checked one by one. Three things to know first:

- BoxRec (https://boxrec.com) requires a login. Rosters and last-bout dates therefore come from Wikipedia list and record tables.
- Coaching status comes from Wikipedia, the press, gym and club pages, and council and hall-of-fame pages.
- A Grok CLI research pass was used **only to find leads**. Every claim cited as evidence was re-checked with a direct fetch or search. Claims that were not re-checked are marked "grok lead, unverified" and are **not** counted.

---

## 0. Headline answers

### Coding scheme (used everywhere below)
- **P**: documented training or cornering of a **professional** fighter.
- **G**: coaching or instructing at a **named gym, club, team or program**. This covers amateur, youth, national-team, white-collar and fitness boxing.
  - **G-weak**: informal, mentor-only, actor training, unsourced Wikipedia text, or an undated listing.
- **T**: coaching on a TV or league reality show only (TUF, Fight Master, Road to UFC). Reported separately and **not counted** as coaching. IFL team coaching **does** count as P, because IFL coaches ran real pro teams.
- **O**: owns or fronts an academy, but there is no evidence they teach. Counted as **not a coach**.
- **N**: no evidence found after the searches listed. Counted as not a coach, with the caveat that absence of evidence is not evidence of absence.
- **k_pro** = P. **k_any** = P + G. **k_strict** = P + G, minus the G-weak cases.

### Headline table

| Sample (rule in its section) | n | k_pro (P) | k_any (P+G) | k_strict | T-only | N (no evidence) |
|---|---|---|---|---|---|---|
| S1 Boxing: WBA/WBC/IBF/WBO heavyweight champions, reign began 1985-2005 | 31 | 9 (29%) | 19 (61%) | 14 (45%) | 0 | 10 (+2 O) |
| S2 MMA: UFC champions (undisputed or interim), last MMA bout 2005-2019 | 32 | 14 (44%) | 22 (69%) | 19 (59%) | 9 | 1 |
| S2b MMA subset, last bout 2005-2016 | 21 | 11 (52%) | 17 (81%) | 15 (71%) | 3 | 1 |
| S3 Boxing journeymen: Wikipedia boxers, 20+ losses, born 1960-1985, losses ≥ wins | 32 | 2 (6%) | 11 (34%) | 10 (31%) | 0 | 21 |
| S3r journeymen minus 4 still recently active (last bout 2023 or later) | 28 | 2 (7%) | 10 (36%) | 9 (32%) | 0 | 18 |

(S2b = the 21 members of S2 whose final MMA bout was 2005-2016; list in section 2.3.)

### Plain answers
1. **Share who coach.**
   - Among elite boxers (heavyweight world champions), about **3 in 10 are documented training pros** and **about 6 in 10 do some named coaching**.
   - Among UFC champions, **44% train pros** and **69% do some coaching**. Counting TUF, the figure is 31/32.
   - Among journeymen, only **2/32 (6%)** have documented pro training, but **about a third** do some coaching (gym, white-collar, fitness or amateur).
   - So **pro-level coaching is rare among journeymen**. Low-level coaching is not rare, and among journeymen it is about as common as pro coaching is among champions.
2. **Lag** (first coaching year minus year of final pro bout; player-coaches set to 0), n = 46 dated coaches across all samples:
   - Median **0 years**. **65%** within 1 year, **72%** within 3 years, **22%** more than 5 years.
   - Counting **only post-retirement starters** (n = 20): median **5.5 years**, **20%** within 1 year, **35%** within 3 years, **50%** more than 5 years.
   - The boxing-only split is very different from MMA (section 4).
3. **Player-coaches** (dated coaching before the final pro bout): **26 of the 46 dated coaches** (6 heavyweights, 16 MMA champions, 4 journeymen).
   - After dropping weak or borderline cases (Witherspoon, Berbick, Tito Ortiz, Butlin) and cross-sport or comeback-only cases (Byrd, Jones, Barnett, Mir), the strict count is **18**: 2 heavyweights, 13 MMA champions, 3 journeymen.
   - MMA champions are overwhelmingly player-coaches. Boxers mostly are not.

---

## 1. Boxing champion sample (S1)

### 1.1 Rule (fixed before counting)
The sample is **every man whose reign as WBA, WBC, IBF or WBO world heavyweight champion began between 1 Jan 1985 and 31 Dec 2005**:
- Full titles only (no interim titles).
- Taken from the champion table in Wikipedia, "List of world heavyweight boxing champions": https://en.wikipedia.org/wiki/List_of_world_heavyweight_boxing_champions
- Pinklon Thomas and Greg Page are excluded because their reigns began in 1984.
- **n = 31.** Last-bout dates come from each fighter's Wikipedia record table (https://en.wikipedia.org/wiki/<Name>).
- The heavyweight division was chosen because it is the best documented and the rule gives a complete, closed list.

### 1.2 Per-person table

| # | Fighter | Final pro bout | Class | Evidence (first dated coaching) | Player-coach? |
|---|---|---|---|---|---|
| 1 | Tony Tubbs | 4 Nov 2006 | **P** | 2003: described as the "respected trainer" of pro Preston Hartzog. boxing247.com/news/tubbs2908.php (29 Aug 2003) | **Y** (2003 < 2006) |
| 2 | Michael Spinks | 1988 | G-weak | Wikipedia (https://en.wikipedia.org/wiki/Michael_Spinks) says he was "training fighters" with Butch Lewis. Undated, no source given | lag NOT FOUND |
| 3 | Tim Witherspoon | 15 Mar 2003 | **P** | Trainer and cornerman for Clinton Woods, a "12-month association" by Feb 2004. He was in Woods's corner for the Nov 2003 draw (The Independent, 4 Feb 2004). Wikipedia: trains boxers, including his son | borderline (start c. Feb 2003, same year) |
| 4 | Trevor Berbick | 26 May 2000 | G-weak | Wikipedia (unsourced): trained young boxers in New Westminster, BC, late 1990s-early 2000s; later at Kenny Barrett's gym, Tamarac, FL. https://en.wikipedia.org/wiki/Trevor_Berbick | weak Y |
| 5 | Mike Tyson | 15 Nov 2024 (pro, vs Jake Paul) | N | No evidence of coaching found | – |
| 6 | James "Bonecrusher" Smith | 1999 | N | Ran the Champion for Kids nonprofit (2004). That is mentoring, not coaching | – |
| 7 | Tony Tucker | 7 May 1998 | **G** | "I help train boxers at the Boy's Club" (boxinginsider.com interview, 7 Aug 2008; also tss.ib.tv, 30 Jul 2008) | lag 10 (first-seen) |
| 8 | Francesco Damiani | 23 Apr 1993 | **G** | Italy national / Olympic team coach, Athens 2004 through Rio 2016 (dartortorromeo.com, 15 Aug 2016). Grok lead: Italian federation technical director from 2007 | lag 11 (first-seen) |
| 9 | James "Buster" Douglas | 19 Feb 1999 | **G** | Joined Columbus Recreation & Parks in 2014 as boxing coach at Thompson Community Center (Columbus City Council legislation file 0042X-2015, columbus.legistar.com; columbusrecparks.com boxing page) | lag 15 |
| 10 | Evander Holyfield | 7 May 2011 | N | 2014: adviser to Zhang Zhilei, and said he was not the trainer (grok lead, tss.ib.tv) | – |
| 11 | Ray Mercer | Sep 2008 (boxing); MMA Jun 2009 | N | Talks about mentoring only (boxingnews24, 20 Nov 2020) | – |
| 12 | Michael Moorer | 8 Feb 2008 | **P** | Trainer of pro JD Chapman from Oct 2005, during a layoff before his 2006-08 return (boxingtalk.com, 22 Oct 2005; boxing247.com/weblog/archives/106830, 21 Dec 2005). Assistant to Freddie Roach at Wild Card, 2009 (philstar.com, 9 May 2009). Also Mariusz Wach, Rod Salka | **Y** |
| 13 | Riddick Bowe | 13 Dec 2008 | G-weak | Mentor to pros at the Heavyweight Factory (blog.seminolehardrockhollywood.com, 9 May 2019) | lag 11 |
| 14 | Lennox Lewis | 21 Jun 2003 | N | Youth camp claim is a grok lead, unverified | – |
| 15 | Tommy Morrison | Feb 2008 | N | Died 2013 | – |
| 16 | Michael Bentt | 19 Mar 1994 | G-weak | Assistant trainer and sparring partner to actor Will Smith for *Ali*, c. 2000-01. https://en.wikipedia.org/wiki/Michael_Bentt ; michaelbentt.com | lag ~6 |
| 17 | Herbie Hide | 2010 | G-weak | Informal help for his amateur son (EDP24, 11 Feb 2019) | lag 9 |
| 18 | Oliver McCall | 3 Jun 2025 | N | Shared a 2009 card with his son; no evidence he coached him (reviewjournal.com, 22 May 2009) | – |
| 19 | George Foreman | 22 Nov 1997 | **P** | Trained and cornered son George Foreman III at his pro debut (New York Times, 5 Jun 2009). He founded a Houston youth center in 1984, during his 1977-87 retirement; his personal instruction there is not dated | lag 12 (pro); unclear for G |
| 20 | Bruce Seldon | 24 Jul 2009 | **P** | Trains son Isiah Seldon, a pro (NJ Boxing Hall of Fame, njboxinghof.org, 2014 induction). Helps train gym clients (Hudson County / hudpost, 30 Jul 2022) | lag 5 (first-seen) |
| 21 | Frank Bruno | 16 Mar 1996 | O | Frank Bruno Boxing Academy, Northampton, opened 2020, closed 2024 (BBC News, 16 Nov 2024). No evidence he taught personally | – |
| 22 | Henry Akinwande | 4 Jul 2008 | N | – | – |
| 23 | Vitali Klitschko | 8 Sep 2012 | **P** | In Wladimir's corner vs Joshua, 29 Apr 2017 (Sky Sports retrospective, 29 Apr 2020). Grok lead: Pulev's corner, 2014 (unverified) | lag 5 |
| 24 | Chris Byrd | 27 Jun 2026 (comeback, KO1 loss to Anthony Welsh, Luanshya, Zambia; talkSPORT / worldboxingnews / boxingnewsandviews 8 Jul 2026). Previous retirement 2009 | **P** | Gym announced Sept 2012 (mlive.com). Co-trainer of Shannon Briggs c. 2014 (boxingscene). In Andre Dirrell's corner, Dec 2014 (PBC). Trains fighters in San Diego (TSS, 13 Jul 2017). Trainer of Mike Lee from Feb 2026 (boxingscene) | **Y** under the final-bout rule; lag 3 vs 2009 |
| 25 | Wladimir Klitschko | 29 Apr 2017 | N | – | – |
| 26 | John Ruiz | 3 Apr 2010 | **G** | Owner and chief instructor, Quietman Sports gym, Medford MA. LinkedIn dates it Mar 2011; Las Vegas Review-Journal, 26 Apr 2010, reported the plan; Wikipedia says 2013. No named pro pupil | lag 1 |
| 27 | Hasim Rahman | 4 Jun 2014 | **P** | "Head trainer" of son Hasim Rahman Jr. (Getty Images caption, 26 Jul 2022). Only an adviser in 2017 (ESPN, 14 Mar 2017). Grok lead: 2026 comeback, unverified | lag 8 |
| 28 | Roy Jones Jr. | 1 Apr 2023 (pro, vs Anthony Pettis). Previous pro bout 8 Feb 2018 | **P** | Trainer of Chris Eubank Jr. from spring 2020 (boxing247; talkSPORT; Sky Sports) | **Y** under the final-bout rule; lag 2 vs 2018 |
| 29 | Corrie Sanders | 2 Feb 2008 | N | Killed 2012 | – |
| 30 | Lamon Brewster | 30 Jan 2010 | **G** | "Running a boxing gym and helping fighters" (boxingnews24, 1 Mar 2012). Later women's classes, Indianapolis (IndyStar, 25 Mar 2025) | lag 2 |
| 31 | Nikolai Valuev | 7 Nov 2009 | O | Youth school "Lider" and a 2009 master class (grok lead, ko-news). No verified personal instruction | – |

### 1.3 Count
- n = 31.
- **P = 9**: Tubbs, Witherspoon, Moorer, Foreman, Seldon, V. Klitschko, Byrd, Rahman, Jones. **k_pro = 9/31 = 29%.**
- **G = 10**: Spinks, Berbick, Tucker, Damiani, Douglas, Bowe, Bentt, Hide, Ruiz, Brewster. **k_any = 19/31 = 61%.**
- **k_strict** (dropping G-weak Spinks, Berbick, Bowe, Bentt, Hide) = **14/31 = 45%**.
- O = 2 (Bruno, Valuev). N = 10.
- Pattern: a son or family member is the pro pupil in 4 of the 9 P cases (Foreman, Seldon, Rahman, and Witherspoon also trains his son). Pro coaching by champions is often family coaching.

---

## 2. MMA sample (S2)

### 2.1 Rule
The sample is **every man listed as UFC champion (undisputed or interim) in the men's championship history of Wikipedia's "List of UFC champions" whose final professional MMA bout took place in 2005-2019**:
- Source list: https://en.wikipedia.org/wiki/List_of_UFC_champions
- Final bouts come from each fighter's Wikipedia MMA record table.
- Excluded for final bouts after 2019: Pat Miletich (2023 comeback), Rashad Evans (2022), Anderson Silva (2020), Khabib Nurmagomedov (2020), Carlos Condit, Frankie Edgar, Dominick Cruz, and other still-active or later-retired champions.
- Champions whose last bout was before 2005 are also excluded.
- **n = 32.** A 2005-2016 subset (S2b) is reported as well.

### 2.2 Per-person table

| Fighter | Final MMA bout | Class | Evidence | Player-coach? |
|---|---|---|---|---|
| Mark Coleman | 2010 | **P** | Cornered Kevin Randleman's pro debut, Oct 1996 (https://en.wikipedia.org/wiki/Kevin_Randleman). Team Hammer House. TUF 19 assistant, 2013 (Toronto Sun / FOX Sports, 20 Nov 2013) | **Y** |
| Maurice Smith | 2013 | **P** | IFL Seattle Tiger Sharks coach, 2006-07 (https://en.wikipedia.org/wiki/Maurice_Smith) | **Y** |
| Randy Couture | 2011 | **P** | Xtreme Couture from 2005-06. Coached Kim Couture's pro career. Bellator Fight Master coach, 2013. (https://en.wikipedia.org/wiki/Randy_Couture) | **Y** |
| Bas Rutten | 22 Jul 2006 | **P** | IFL Los Angeles Anacondas coach, 2006. Trained Kimbo Slice. (https://en.wikipedia.org/wiki/Bas_Rutten) | **Y** |
| Kevin Randleman | 2011 | **G** | Monster Wrestling Academy (youth wrestling) after his career, undated. Died 2016. (Wikipedia) | lag NOT FOUND |
| Josh Barnett | Sep 2016 (MMA); bare-knuckle bout 23 Oct 2020 | **P** | Founded UWF USA in 2017 and is its head coach (https://en.wikipedia.org/wiki/Josh_Barnett). T: Road to UFC Japan, 2015 | Y vs 2020 bout; lag 1 on MMA alone |
| Ricco Rodriguez | Feb 2019 | **G** | Moved to Dubai to coach full time at Glory MMA (The National, 16 Aug 2013) | **Y** |
| Tim Sylvia | Oct 2013 | N | Grok lead: said in 2018 he never went into coaching (unverified) | – |
| Frank Mir | 2019 (MMA); boxing 2021 | **P** | Cornered daughter Bella Mir's pro MMA debut, Oct 2020 (https://en.wikipedia.org/wiki/Frank_Mir). T: TUF 8 | Y vs 2021 boxing bout; lag 1 on MMA alone |
| Antônio Rodrigo Nogueira | 2015 | **G** | Team Nogueira prospects (mmafighting.com, 2 Aug 2014). T: TUF 8, TUF Brazil | **Y** |
| Brock Lesnar | 2016 | T | TUF 13 only | – |
| Shane Carwin | Jun 2011 | G-weak | Volunteer wrestling coach, Univ. of Northern Colorado, undated (Wikipedia). T: TUF 16 | lag NOT FOUND |
| Cain Velasquez | Feb 2019 | **P** | Coaching at AKA (mmajunkie.usatoday.com, 10 Mar 2023) | lag 4 (first-seen) |
| Frank Shamrock | 2009 | **P** | Shamrock Martial Arts Academy, Dec 2005. IFL San Jose Razorclaws coach, 2006 (https://en.wikipedia.org/wiki/Frank_Shamrock) | **Y** |
| Tito Ortiz | 2019 | G-weak | Punishment Training Center (LA Times, 9 Mar 2011; not read directly). T: TUF 3, TUF 11 | weak Y |
| Vitor Belfort | 2018 | T | TUF Brazil only | – |
| Chuck Liddell | 2018 | T | TUF 1, TUF 11 only | – |
| Quinton "Rampage" Jackson | 2019 | T | TUF 7, TUF 10. Co-owned a gym; no evidence he taught | – |
| Forrest Griffin | 2012 | T | TUF 7. Later UFC Performance Institute executive (not coaching) | – |
| Dave Menne | 2012 | G-weak | Menne Combat Academy listed as his team (Wikipedia / Sherdog), undated | lag NOT FOUND |
| Murilo Bustamante | 2012 | **P** | Co-founded and runs Brazilian Top Team, 2000 (https://en.wikipedia.org/wiki/Murilo_Bustamante) | **Y** |
| Evan Tanner | Feb 2008 | **G** | Coaching residents at his Oregon camp by Mar 2007 (Wikipedia; mmamania, 11 May 2007). Died 2008 | **Y** |
| Rich Franklin | 2012 | T | TUF 2. Later ONE Championship executive | – |
| Michael Bisping | Nov 2017 | T | TUF 9, TUF 14, TUF 34 (2026) only | – |
| Carlos Newton | 2010 | **P** | IFL Toronto Dragons co-coach, 2005-06. Later Warrior MMA, then Newton MMA (https://en.wikipedia.org/wiki/Carlos_Newton) | **Y** |
| Matt Hughes | 2011 | **P** | Co-founded the H.I.T. Squad, 2007 (https://en.wikipedia.org/wiki/Matt_Hughes). T: TUF 2 | **Y** |
| B.J. Penn | 11 May 2019 | T | TUF 5, TUF 19 only | – |
| Matt Serra | 2010 | **P** | Serra BJJ from about 2001. Coached Chris Weidman from 2008. Serra-Longo head coach (https://en.wikipedia.org/wiki/Matt_Serra) | **Y** |
| Johny Hendricks | 2017 | G then **P** | High-school wrestling coach on retiring (mmajunkie, 27 Jun 2018). Training UFC fighter Kevin Holland (mmajunkie, 16 Aug 2021) | lag 1 (G) / 4 (P) |
| Jens Pulver | Nov 2013 | **G** | "Two guys I've started coaching", Miletich camp (mixedmartialarts.com, 9 Jul 2014). T: TUF 5 | lag 1 |
| Sean Sherk | 2010 | **P** | "Currently coaches a team of fighters" at Minnesota Martial Arts Academy (c. 2008 Wikipedia snapshot via en-academic; grok lead: archived MMAA staff page, 2008) | **Y** |
| Georges St-Pierre | 2017 | T | TUF 12 only | – |

### 2.3 Count
- n = 32.
- **P = 14**: Coleman, M. Smith, Couture, Rutten, Barnett, Mir, Velasquez, Shamrock, Bustamante, Newton, Hughes, Serra, Hendricks, Sherk. **k_pro = 14/32 = 44%.**
- **G = 8**: Randleman, Rodriguez, Nogueira, Carwin, Ortiz, Menne, Tanner, Pulver. **k_any = 22/32 = 69%.**
- **k_strict** (dropping Carwin, Ortiz, Menne) = **19/32 = 59%**.
- **T-only = 9**: Lesnar, Belfort, Liddell, Jackson, Griffin, Franklin, Bisping, Penn, GSP. N = 1 (Sylvia).
- **Counting TUF as coaching gives 31/32.** This shows how misleading "famous fighter coached on TV" evidence is.

**S2b subset (final MMA bout 2005-2016), n = 21:**
- Members (21): Coleman 2010, M. Smith 2013, Couture 2011, Rutten 2006, Randleman 2011, Barnett 2016, Sylvia 2013, Nogueira 2015, Lesnar 2016, Carwin 2011, Shamrock 2009, Griffin 2012, Menne 2012, Bustamante 2012, Tanner 2008, Franklin 2012, Newton 2010, Hughes 2011, Serra 2010, Pulver 2013, Sherk 2010. The other 11 (Rodriguez, Mir, Velasquez, Ortiz, Belfort, Liddell, Jackson, Bisping, Penn, Hendricks, St-Pierre) had final bouts in 2017-2019.
- Counts:
  - P = Coleman, Smith, Couture, Rutten, Barnett, Shamrock, Bustamante, Newton, Hughes, Serra, Sherk = 11.
  - G = Randleman, Nogueira, Carwin, Menne, Tanner, Pulver = 6.
  - T = Lesnar, Griffin, Franklin = 3. N = Sylvia = 1.
  - **n = 21: k_pro 11/21 = 52%, k_any 17/21 = 81%, k_strict 15/21 = 71%.**

---

## 3. Journeymen sample (S3)

### 3.1 Rule
- Start from every English Wikipedia article using `Infobox boxer` whose infobox shows **20 or more professional losses**. CirrusSearch query `hastemplate:"Infobox boxer" insource:/losses *= *[2-9][0-9]/` returned 527 hits (read 2026-09-25).
- Filter to **born 1960-1985** and **losses ≥ wins**. Articles where the loss figure is an amateur record were dropped.
- **n = 32** (30 men, 2 women).
- This is a reproducible "losing-record journeyman" definition. It is biased toward journeymen notable enough to have a Wikipedia page (record-setters, former title holders who became journeymen, British "300-fight" types).
- Last-bout years come from the Wikipedia record tables and lead text (https://en.wikipedia.org/wiki/<Name>).
- Four members have fought in 2023 or later (Long, Boone, Gerula, Nascimento), so the S3r row in section 0 excludes them.

### 3.2 Per-person table

| # | Boxer (born, W-L) | Final pro bout | Class | Evidence | Player-coach? |
|---|---|---|---|---|---|
| 1 | Craig Payne (1961, 11-20) | 2001 (Wikipedia lead: "competed from 1985 to 2001") | N | Died 2017; obituaries mention only his own trainer, Paul Soucy (fightnews via web.archive.org, 2017) | – |
| 2 | Kevin Pritchard (1961, 22-22) | 1991 (retired after losing to McMillan, Sept 1991; Wikipedia) | N | – | – |
| 3 | Verdell Smith (1963, 46-63) | 2006 (Examiner-Enterprise) | **G** | "Consistent contributor the past decade-plus as a trainer, sparring partner and coach" of Team Rouse fighters, Bartlesville OK (Examiner-Enterprise, 24 Dec 2017: https://eu.examiner-enterprise.com/story/news/local/2017/12/24/verdell-smith/16771353007/) | lag ≤1 (decade-plus before Dec 2017 means ≤2007) |
| 4 | Juan Polo Pérez (1963, 46-46) | 2007 | N | Former IBF super-flyweight champion; no evidence of coaching found | – |
| 5 | Steve Larrimore (1963, 25-27) | 2001 | N | Bahamas coaching references name other people | – |
| 6 | Orlando Malone (1963, 10-22) | 1994 (Wikipedia table; one search summary says 2007) | N | – | – |
| 7 | Julius Francis (1964, 23-24) | 2006 (Wikipedia table) | **G** | "In early 2009 ... began a new career with Fightfit Training ... as a personal trainer and boxing coach" (https://en.wikipedia.org/wiki/Julius_Francis) | lag 3 |
| 8 | Eric Crumble (1966, 0-31) | 2003 | N | – | – |
| 9 | Sugar Gibiliru (1966, 16-32) | Mar 1995 | N | – | – |
| 10 | Louis Monaco (1968, 16-39) | 2014 per his site ("1996-2014"); Wikipedia table shows 1999 | G-weak | "Championship Boxer & Personal Trainer", Big RED Fitness (louismonacoboxing.wixsite.com/bigredfitness, © 2023). Fitness only, undated | lag NOT FOUND |
| 11 | Reggie Strickland (1968, 66-276) | 15 Oct 2005 (Wikipedia table) | N | Matchmaking and adviser role only (Indianapolis Monthly longform) | – |
| 12 | Peter Buckley (1969, 32-256) | 31 Oct 2008 | **P** | Held a trainer's licence and trained fighters for Errol Johnson's Black Country Boxing; stopped to care for his mother (fightcity.uk, 11 Mar 2019) | lag NOT FOUND (between 2009 and 2019) |
| 13 | Chris Saunders (1969, 23-23) | c. 2000s (not resolved) | N | – | – |
| 14 | Tony Booth (1970, 52-105) | 2008 | **G** | Jan 2019 interview: "I'm training a young kid now... since August [2018] I can get my trainer's license. I've just started doing some White Collars" (Hannibal Boxing, 2 Jan 2019: https://hannibalboxing.com/when-they-was-all-calling-me-fat-bastard-tony-booth-looks-back/). He was jailed 2011-18 | lag 10 |
| 15 | Rubin Williams (1976, 29-33) | 2018 | N | – | – |
| 16 | Paul Butlin (1976, 16-24) | 2016 | **G** | Opened the Hardknocks boxing gym, Melton Mowbray (https://en.wikipedia.org/wiki/Paul_Butlin; the article places it before his Oct 2013 fight with Joshua). A ringnews24 piece of 24 Feb 2014 is indexed as reporting him training at his own gym (Cloudflare-blocked, not read). Grokipedia says 2010 (unverified) | Y (weakly dated) |
| 17 | Lee Swaby (1976, 25-29) | 2010 (Wikipedia table) | **G** | Coaching at Lincoln Fight Factory: "coaching from top ex pros such as Lee Swaby" (LSJ News, 11 Dec 2018: https://www.lsjnews.co.uk/boxing-on-the-rise-in-lincoln/). Search summary: also founded TKO White Collar Boxing (not read) | lag 8 (first-seen) |
| 18 | Julius Long (1977, 18-30) | 2026 (still active) | N | Sparring partner for David Tua, 2013 (scoop.co.nz), which is not coaching | – |
| 19 | Peter McDonagh (1977, 28-28) | c. 2019 (brain tumour diagnosis ended career; Irwin Mitchell, Mar 2023) | N | – | – |
| 20 | Belinda Laracuente (1979, 26-28, F) | 2013 | **G** | Girlboxing interview conducted while she was still active: "Aside from your work as a professional boxer, you are one of the premier trainers at Gleason's Gym teaching men and women" (girlboxing.org, belinda-laracuente tag page, 2012-2014 posts) | **Y** |
| 21 | Johnny Greaves (1979, 4-96) | Sept 2013 | **P** | "Spending his time out of the ring training the next generation of professional boxers at ... the Peacock Gym". Got his BBBofC manager's licence Nov 2015; "London-based trainer and manager" of George Hennon (1-0) (World Boxing News, 17 Nov 2015: https://www.worldboxingnews.com/johnny-greaves-granted-manager-s-license-begins-new-chapter/) | lag 2 |
| 22 | Luke Simpkin (1979, 11-32) | 2008 | N | – | – |
| 23 | Kevin McCauley (1979, 15-224) | Jul 2022 (retirement announced) | **G** | Ran "a little gym in Lye" coaching white-collar boxers while still active (fightcity.uk). Trains his amateur stepson (Boxing News, 30 Jul 2022) | **Y** |
| 24 | Olivia Gerula (1979, 19-21, F) | 2024 (still active recently) | **G** | Certified personal trainer; "runs classes for the city as a boxing and kickboxing trainer" (Winnipeg Free Press, 30 Apr 2016: https://www.winnipegfreepress.com/arts-and-life/life/health/2016/04/30/olivia-gerula-training-basket) | **Y** |
| 25 | Marcelo Nascimento (1980, 18-23) | 2023 | N | – | – |
| 26 | Charles Davis (1980, 19-23) | 2021 | N | – | – |
| 27 | Kristian Laight (1980, 12-279) | Sept 2018 | N | Only a stated **plan** to get a trainer/second's licence at Eastside Gym (bbcolumn.com, 3 Sep 2018). No confirmation found | – |
| 28 | Darnell Boone (1980, 24-28) | 2025 | N | – | – |
| 29 | Carlos Melo (1982, 22-22) | 2017 | N | – | – |
| 30 | Arturo Gómez (1984, 20-25) | 2016 | N | – | – |
| 31 | Demetrice King (1985, 15-20) | 2011 | N | – | – |
| 32 | Juan Santiago (1985, 16-24) | NOT FOUND (Wikipedia table undated; BoxRec walled) | N | – | – |

### 3.3 Count and answer
- n = 32.
- **P = 2** (Buckley, Greaves). **k_pro = 2/32 = 6%.**
- **G = 9** (V. Smith, Francis, Monaco-weak, Booth, Butlin, Swaby, Laracuente, McCauley, Gerula). **k_any = 11/32 = 34%.**
- **k_strict** (dropping Monaco) = **10/32 = 31%**.
- N = 21.
- Excluding the 4 members active in 2023 or later (S3r, n = 28): k_pro 2/28 = 7%, k_any 10/28 = 36%.
- **Is coaching rare among journeymen?**
  - **Pro-level coaching: yes.** 6% vs 29% for heavyweight champions and 44% for UFC champions.
  - **Any coaching: no.** About a third coach, mostly white-collar, fitness or amateur classes. Much of this starts **while they are still fighting**.
- Search depth: the 21 journeymen marked N had 1-2 English web searches each (Spanish or Portuguese for the Latin American members), plus a read of their Wikipedia page. US and Latin American journeymen are much less documented than British ones: 7 of the 11 coaches are UK-based. N here is weak evidence.

---

## 4. Lag distribution

**Definition.** Lag = first dated year of coaching (P or G) minus the year of the final pro bout in any combat sport.
- Player-coaches (dated coaching before the final bout) are given lag 0 in the "all" series and left out of the "post-retirement" series.
- "First-seen" means the earliest dated source found, so the true start could be earlier. **All positive lags are therefore upper bounds.**
- Undated coaches (Spinks, Randleman, Carwin, Menne, Buckley, Monaco) are excluded: lag **NOT FOUND**.

### 4.1 Per-coach table (dated coaches, n = 46)

| Sample | Coach | Final bout | First coaching (yr, level) | Lag | Flag |
|---|---|---|---|---|---|
| S1 | Tubbs | 2006 | 2003 P | PC (0) | |
| S1 | Witherspoon | 2003 | 2003 P | 0 | borderline PC |
| S1 | Berbick | 2000 | late 1990s G | PC (0) | weak, unsourced |
| S1 | Moorer | 2008 | 2005 P | PC (0) | |
| S1 | Byrd | 2026 (prev. 2009) | 2012 G / 2014 P | PC (0) | 3 vs 2009 retirement |
| S1 | Jones | 2023 (prev. 2018) | 2020 P | PC (0) | 2 vs 2018 |
| S1 | Ruiz | 2010 | 2011 G | 1 | |
| S1 | Brewster | 2010 | 2012 G | 2 | |
| S1 | Seldon | 2009 | 2014 P | 5 | first-seen |
| S1 | V. Klitschko | 2012 | 2017 P | 5 | 2 if 2014 Pulev lead confirmed |
| S1 | Bentt | 1994 | c. 2000 G-weak | 6 | actor training |
| S1 | Rahman | 2014 | 2022 P | 8 | |
| S1 | Hide | 2010 | 2019 G-weak | 9 | informal |
| S1 | Tucker | 1998 | 2008 G | 10 | first-seen |
| S1 | Damiani | 1993 | 2004 G | 11 | first-seen (2007 per grok lead) |
| S1 | Bowe | 2008 | 2019 G-weak | 11 | mentor |
| S1 | Foreman | 1997 | 2009 P | 12 | youth centre 1984 not counted |
| S1 | Douglas | 1999 | 2014 G | 15 | |
| S2 | Coleman | 2010 | 1996 P | PC (0) | |
| S2 | M. Smith | 2013 | 2006 P | PC (0) | |
| S2 | Couture | 2011 | 2005 P | PC (0) | |
| S2 | Rutten | 2006 | 2006 P | PC (0) | |
| S2 | Rodriguez | 2019 | 2013 G | PC (0) | |
| S2 | Nogueira | 2015 | ≤2014 G | PC (0) | |
| S2 | Shamrock | 2009 | 2005 P | PC (0) | |
| S2 | Bustamante | 2012 | 2000 P | PC (0) | |
| S2 | Tanner | 2008 | 2007 G | PC (0) | |
| S2 | Newton | 2010 | 2005 P | PC (0) | |
| S2 | Hughes | 2011 | 2007 P | PC (0) | |
| S2 | Serra | 2010 | 2001 P | PC (0) | |
| S2 | Sherk | 2010 | c. 2008 P | PC (0) | |
| S2 | Ortiz | 2019 | ≤2011 G-weak | PC (0) | weak |
| S2 | Barnett | 2020 BKB (MMA 2016) | 2017 P | PC (0) | 1 on MMA alone |
| S2 | Mir | 2021 boxing (MMA 2019) | 2020 P | PC (0) | 1 on MMA alone |
| S2 | Hendricks | 2017 | 2018 G | 1 | P from 2021 (4) |
| S2 | Pulver | 2013 | 2014 G | 1 | |
| S2 | Velasquez | 2019 | 2023 P | 4 | first-seen |
| S3 | Laracuente | 2013 | ≤2013 G | PC (0) | |
| S3 | McCauley | 2022 | pre-2022 G | PC (0) | |
| S3 | Gerula | 2024 | ≤2016 G | PC (0) | |
| S3 | Butlin | 2016 | ≤2013 G | PC (0) | weakly dated |
| S3 | V. Smith | 2006 | ≤2007 G | 1 | "decade-plus" before 2017 |
| S3 | Greaves | 2013 | 2015 P | 2 | |
| S3 | Francis | 2006 | 2009 G | 3 | |
| S3 | Swaby | 2010 | 2018 G | 8 | first-seen |
| S3 | Booth | 2008 | 2018 G | 10 | jailed 2011-18 |

### 4.2 Distribution (computed from the table; PC = player-coach)

| Series | n | Median lag (yrs) | ≤1 yr | ≤3 yrs | >5 yrs |
|---|---|---|---|---|---|
| **All samples, PC=0** | 46 | **0** | 30 (65%) | 33 (72%) | 10 (22%) |
| All samples, post-retirement starters only | 20 | **5.5** | 4 (20%) | 7 (35%) | 10 (50%) |
| Boxing (S1+S3), PC=0 | 27 | 2 | 12 (44%) | 15 (56%) | 10 (37%) |
| Boxing (S1+S3), post-retirement only | 17 | **8** | 2 (12%) | 5 (29%) | 10 (59%) |
| S1 heavyweight champions, PC=0 | 18 | 5 | 7 (39%) | 8 (44%) | 8 (44%) |
| S1, post-retirement only | 12 | 8.5 | 1 (8%) | 2 (17%) | 8 (67%) |
| S2 UFC champions, PC=0 | 19 | 0 | 18 (95%) | 18 (95%) | 0 (0%) |
| S2, post-retirement only | 3 | 1 | 2 (67%) | 2 (67%) | 0 |
| S3 journeymen, PC=0 | 9 | 1 | 5 (56%) | 7 (78%) | 2 (22%) |
| S3, post-retirement only | 5 | 3 | 1 (20%) | 3 (60%) | 2 (40%) |

**Reading the numbers:**
- **MMA:** coaching is part of the career. 16/19 dated coaches coached before their last fight. The few who started after retiring did so within about 1-4 years.
- **Boxing champions:** those who start after retiring usually start **late**. The median is 8.5 years, and 2/3 start more than 5 years later. Often the trigger is a son turning pro (Foreman, Seldon, Rahman) or a public job (Douglas).
- **Journeymen:** they coach sooner, often at white-collar or fitness level, and a large share start while still fighting.
- Caveat: first-seen dating inflates the boxing lags. Obscure early coaching goes unreported and the earliest article is often a later profile.

---

## 5. Player-coaches

"Player-coach" means dated evidence of training or cornering others **before** the final pro bout.

| Sample | Player-coaches (dated) | Strict subset |
|---|---|---|
| S1 heavyweights | 6: Tubbs (2003 < 2006, pro Preston Hartzog), Moorer (2005 < 2008, pro JD Chapman), Byrd (2012-26 < 2026 comeback), Jones (2020 < 2023), Witherspoon (2003 = 2003, borderline), Berbick (weak) | **2** (Tubbs, Moorer) |
| S2 UFC champions | 16: Coleman, M. Smith, Couture, Rutten, Rodriguez, Nogueira, Shamrock, Bustamante, Tanner, Newton, Hughes, Serra, Sherk, Ortiz (weak), Barnett (vs 2020 BKB), Mir (vs 2021 boxing) | **13** (dropping Ortiz, Barnett, Mir) |
| S3 journeymen | 4: McCauley (white-collar gym, Lye), Laracuente (Gleason's), Gerula (city classes, 2016), Butlin (Hardknocks, weakly dated) | **3** |
| **Total** | **26 of 46 dated coaches (57%)**; 26 of 95 sample members (27%) | **18** |

- Among all coaches (dated or not; S1 19 + S2 22 + S3 11 = 52), **26/52 = 50%** were player-coaches.
- Among UFC champions who coach, 16/22 (73%) started while still fighting. Among heavyweight champions it is 6/19 (32%), or 2/19 (11%) strict.

---

## 6. Game gate table for Stage S72

Tags:
- **SOURCED**: directly counted in this memo.
- **NOT FOUND**: no counted number.
- **JUDGEMENT**: a design choice derived from the counts, not a measured fact.

| # | Parameter | Value for S72 | Tag | Basis |
|---|---|---|---|---|
| 1 | P(retired elite boxer trains pros) | 0.29 | SOURCED | S1: 9/31 |
| 2 | P(retired elite boxer does any named coaching) | 0.61 (0.45 strict) | SOURCED | S1: 19/31, 14/31 |
| 3 | P(retired elite MMA fighter trains pros) | 0.44 (0.52 if final bout ≤2016) | SOURCED | S2: 14/32; S2b: 11/21 |
| 4 | P(retired elite MMA fighter does any coaching) | 0.69 (0.59 strict) | SOURCED | S2: 22/32, 19/32 |
| 5 | P(journeyman trains pros) | 0.06 | SOURCED | S3: 2/32 |
| 6 | P(journeyman does any coaching) | 0.34 (0.31 strict) | SOURCED | S3: 11/32, 10/32 |
| 7 | P(mid-card/regional fighter coaches) | interpolate 0.15-0.25 pro / 0.45 any | JUDGEMENT | No sample of mid-tier fighters was drawn: NOT FOUND as a count |
| 8 | TV-reality coaching (TUF-style) counts as coach? | No; treat as a separate "celebrity coach" flag | JUDGEMENT | S2: 9/32 were T-only, and would inflate the rate to 31/32 |
| 9 | P(coach starts while still active), MMA | 0.73 of MMA coaches | SOURCED | 16/22 |
| 10 | P(coach starts while still active), boxing | 0.32 champions (0.11 strict); 0.36 journeymen | SOURCED | S1 6/19 (2/19); S3 4/11 |
| 11 | Delay after retirement, boxing, post-retirement starters | median 8 yrs; 12% ≤1 yr; 29% ≤3 yrs; 59% >5 yrs | SOURCED (upper-bound dates) | Section 4.2, n = 17 |
| 12 | Delay after retirement, MMA, post-retirement starters | median 1 yr (n = 3, too small) | SOURCED but n too small; JUDGEMENT to use 0-2 yrs | Section 4.2 |
| 13 | Delay, all dated coaches incl. player-coaches | median 0; 65% ≤1 yr; 72% ≤3 yrs; 22% >5 yrs | SOURCED | Section 4.2, n = 46 |
| 14 | Suggested delay model | 50% "immediate" (already coaching); remainder: boxing uniform 1-15 yrs, peak 5-12; MMA 1-4 yrs | JUDGEMENT | Shape of the section 4 tables |
| 15 | Family trigger (son or daughter turns pro, parent becomes trainer) | 5 of 23 P-level coaches across S1+S2 (Foreman, Seldon, Rahman, Mir, Couture/Kim) plus Witherspoon's son | SOURCED (count); JUDGEMENT to model it as an event | S1, S2 tables |
| 16 | Level of first coaching for journeymen | mostly white-collar, fitness or amateur; pro trainer rare (2/11) | SOURCED | S3 |
| 17 | Coaching income (money) | NOT FOUND | NOT FOUND | No salary figure was counted in this task |
| 18 | Share who own a gym but do not teach | 2/31 heavyweights (Bruno, Valuev) | SOURCED | S1 |
| 19 | Share of coaches who later quit coaching | NOT FOUND (anecdotes: Buckley stopped to care for his mother; Bruno's academy closed 2024) | NOT FOUND | Not counted |
| 20 | Women fighters | S3 has only 2 women (both coach, both player-coaches); no separate rate | NOT FOUND as a rate | n too small |

---

## Sources index (all read 2026-09-25 unless noted)

**Rosters**
- Wikipedia, List of world heavyweight boxing champions: https://en.wikipedia.org/wiki/List_of_world_heavyweight_boxing_champions
- Wikipedia, List of UFC champions: https://en.wikipedia.org/wiki/List_of_UFC_champions
- Wikipedia CirrusSearch, `hastemplate:"Infobox boxer" insource:/losses *= *[2-9][0-9]/`, via https://en.wikipedia.org/w/api.php (527 hits)
- Individual Wikipedia biographies and record tables, https://en.wikipedia.org/wiki/<Name>, for all 95 members (last bouts, and the Wikipedia-sourced coaching claims noted in the tables)
- BoxRec (https://boxrec.com): login-walled, not used for counting

**Boxing champions (S1)**
- boxing247.com/news/tubbs2908.php (Tubbs trains Hartzog, 29 Aug 2003)
- The Independent, 4 Feb 2004 (Witherspoon / Clinton Woods)
- boxinginsider.com, Tony Tucker interview (7 Aug 2008); tss.ib.tv (30 Jul 2008)
- dartortorromeo.com (Damiani, Italy Olympic coach, 15 Aug 2016)
- columbus.legistar.com file 0042X-2015; columbusrecparks.com boxing page (Douglas)
- boxingtalk.com (22 Oct 2005) and boxing247.com/weblog/archives/106830 (21 Dec 2005) (Moorer / JD Chapman); philstar.com (9 May 2009; Moorer at Wild Card)
- blog.seminolehardrockhollywood.com (9 May 2019; Bowe)
- EDP24 (11 Feb 2019; Hide)
- New York Times (5 Jun 2009; Foreman III debut)
- njboxinghof.org (Seldon, 2014 class); hudpost (30 Jul 2022)
- BBC News (16 Nov 2024; Bruno academy closure)
- Sky Sports (29 Apr 2020; Vitali in Wladimir's corner, 2017)
- mlive.com (Sept 2012; Byrd gym); boxingscene (Byrd / Briggs, Mike Lee 2026); TSS (13 Jul 2017); talkSPORT, worldboxingnews, boxingnewsandviews.com (8 Jul 2026) on the Byrd comeback of 27 Jun 2026
- Las Vegas Review-Journal (26 Apr 2010; Ruiz gym plan; 22 May 2009; McCall)
- Getty Images caption (26 Jul 2022; Rahman); ESPN (14 Mar 2017)
- boxing247, talkSPORT, Sky Sports (2020; Jones trains Eubank Jr.)
- boxingnews24 (1 Mar 2012; Brewster; 20 Nov 2020; Mercer); IndyStar (25 Mar 2025)

**MMA (S2)**
- Wikipedia biographies: Coleman, Randleman, M. Smith, Couture, Rutten, Barnett, Mir, Shamrock, Bustamante, Newton, Hughes, Serra, Carwin, Menne, Tanner, Sherk (en-academic snapshot)
- Toronto Sun / FOX Sports (20 Nov 2013; TUF 19)
- The National (16 Aug 2013; Ricco Rodriguez, Dubai)
- mmafighting.com (2 Aug 2014; Nogueira)
- mmajunkie (10 Mar 2023, Velasquez; 27 Jun 2018 and 16 Aug 2021, Hendricks)
- mixedmartialarts.com (9 Jul 2014; Pulver)
- mmamania (11 May 2007; Tanner)
- LA Times (9 Mar 2011; Ortiz, indexed only)

**Journeymen (S3)**
- https://hannibalboxing.com/when-they-was-all-calling-me-fat-bastard-tony-booth-looks-back/ (2 Jan 2019)
- https://www.lsjnews.co.uk/boxing-on-the-rise-in-lincoln/ (11 Dec 2018)
- https://www.worldboxingnews.com/johnny-greaves-granted-manager-s-license-begins-new-chapter/ (17 Nov 2015)
- https://eu.examiner-enterprise.com/story/news/local/2017/12/24/verdell-smith/16771353007/ (24 Dec 2017)
- https://www.winnipegfreepress.com/arts-and-life/life/health/2016/04/30/olivia-gerula-training-basket (30 Apr 2016)
- https://www.winnipegfreepress.com/our-communities/herald/2015/04/14/predator-on-the-hunt-for-title (14 Apr 2015)
- https://girlboxing.org/tag/belinda-laracuente/ (posts 2012-2016)
- https://tss.ib.tv/boxing/belinda-laracuente-boxing-is-all-i-ve-got/ (10 Jul 2006; sparring at Gleason's only)
- louismonacoboxing.wixsite.com/bigredfitness/louis-monaco (© 2023)
- fightcity.uk (11 Mar 2019, Buckley; McCauley feature)
- Boxing News (30 Jul 2022; McCauley)
- bbcolumn.com/post/2018/09/03/laight-calls-it-a-day-on-300-fights
- Indianapolis Monthly, "Almost Infamous" (Strickland)
- web.archive.org snapshot of fightnews.com, Craig Payne obituary (2017)
- irwinmitchell.com (Mar 2023; McDonagh retirement)
- scoop.co.nz (Aug 2013; Julius Long as Tua's sparring partner)

---

## Still unknown / caveats

1. **Fame and documentation bias.**
   - Champions (S1, S2) are far better documented than journeymen (S3). N counts in S3, especially for US and Latin American members, are weak evidence.
   - UK journeymen dominate the S3 coaches (7/11) partly because British boxing media profile journeymen.
2. **Search depth.**
   - Roughly 1-3 targeted web searches per person, plus the Wikipedia page, with direct fetches for the key evidence.
   - English-language only, except brief Spanish and Portuguese checks for Latin American members.
   - No BoxRec trainer fields (login wall), and no Sherdog or Tapology coach listings in bulk.
   - A second Grok pass on the journeymen produced no output and was stopped. No journeyman claim relies on Grok.
3. **Dating.** Every positive lag is a *first-seen* upper bound. True lags, especially the long boxing ones, are probably shorter.
4. **Wealth confound.** Heavyweight champions are richer than most fighters and may not need coaching income. UFC champions of 2005-2019 mostly came from gym-team cultures where fighters coach as a matter of course. Neither sample represents the median pro.
5. **Comebacks.** The final-bout rule turns Byrd, Jones, Barnett and Mir into player-coaches because of late comebacks or cross-sport bouts. Alternative lags are given in section 4.1.
6. **Not counted (NOT FOUND):**
   - Coaching rate for mid-tier / regional pros (no sample drawn).
   - Coaching income (no figures, so no currency or year).
   - Rate of quitting coaching.
   - A separate rate for women.
   - Coaching start dates for Spinks, Randleman, Carwin, Menne, Buckley, Monaco.
   - Final bouts for Chris Saunders and Juan Santiago.
7. **Unverified grok leads (not counted):** Vitali in Pulev's corner, 2014; Damiani as FPI technical director from 2007; Valuev's "Lider" school; Lennox Lewis youth camp; Holyfield-Zhang adviser quote; Sylvia's 2018 quote; Hasim Rahman's 2026 comeback.
