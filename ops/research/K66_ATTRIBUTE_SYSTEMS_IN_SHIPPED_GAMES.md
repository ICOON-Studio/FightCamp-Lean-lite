# K66 — Attribute systems in shipped games

**Kalli · 2026-09-21 · commissioned by S31 when the operator ruled seven stats inadequate**

**HOW THIS GOT HERE, because it matters for trusting it.** Kalli has no checkout
and cannot push. This memo was read out of the Grok Bot research room with
`Tools/grokbots/grokbots.py read --to Kalli` and landed verbatim; only the
chat's tab-separated tables were converted to markdown pipes. **Nothing was
added, removed or reworded.**

**WHAT IT IS AND IS NOT.** It is a survey of what SHIPPED games expose. Kalli was
explicitly forbidden from recommending an attribute list for us, and it closed
with "No attribute list recommended for FightCamp" — so nothing here is a
proposal. The decision is the operator's and the synthesis is Claude's, against
`Q119`'s engine-derived floor and `J33`'s sport-measured qualities.

**READ THE LABELS.** Several rows are honestly marked **NOT FOUND** (Title Bout
Championship Boxing 2, EA Sports UFC 5's full sub-attribute list, WWE 2K24's
official list) and two sources are marked **UNVERIFIED_SECONDARY** (OOTP forum
rating threads, Reddit/Smacktalks CAW threads). Do not quote those as counts.

---

Survey of visible fighter/player attribute systems in shipped management sims and action games with a career layer. No recommendations for FightCamp. Counts are of named numeric attributes the player can see on profile / create / edit screens (not traits, not overall alone, not move lists).

Summary table
| game + edition + year | how many attributes | grouping | scale | profile shows | hidden attributes | source |
|---|---|---|---|---|---|---|
| Football Manager 2024 (SI, 2023) | 36 outfield visible (14 Technical + 14 Mental + 8 Physical); GK replaces Technical with 13 Goalkeeping | 3 buckets (Technical / Mental / Physical); GK Technical separate | 1–20 | Full three-column list on Overview; Attribute Analysis spider; key attributes highlighted by role; scouting can mask unknown values as ranges | Yes — Consistency, Important Matches, Injury Proneness, Versatility, plus personality/pressure-type values revealed mainly via scouting | SI Players manual concept + FIFPlay / Passion4FM attribute tables mirroring in-game names |
| Undisputed (Steel City / Plaion, 2024 full release; Create-a-Fighter + roster) | ~30 named sub-stats under 6 category overalls (Vitality, Heart, Stamina, Strength, Speed, Defense) | 6 category overalls with sub-stats | 0–100 (patch notes quote integer ratings in that band) | Category overalls + expandable sub-stats on fighter card / CAF; traits separate (0–3) | Traits and some recovery behaviours sit beside the numbered list; no published “secret” numeric layer beyond what CAF/roster exposes | Official Undisputed “Fighter Stats Explained” + Plaion rating patch notes |
| World Championship Boxing Manager 2 (2023) | 7 | Flat list (no separate physical/mental tabs in training UI) | Appears 0–100 (training unlocks at thresholds e.g. 40 in a stat) | All seven on boxer / training screens | Stress / Energy / lounge systems affect training; not the same as the seven combat stats | WCBM2 Fandom Training page (stat names on training table); Finger Guns review (“seven stats”) |
| Title Bout Championship Boxing 2 (Alpha Omega / OOTP, 2005+) | NOT FOUND (complete verbatim official list this session) — Appendix A “How to Rate Your Own Fighters” exists in the official manual; community rating sheets list ~20+ named ratings | Manual buckets: Core / Strategies / Other / Conditioning | Mixed (many 0–10 / percentage-style ranges on community sheets) | Traits as colour bars on fight UI (Control, Hitting Power, Defense, Endurance, etc.) | Simulation uses many interrelated ratings; community editors expose the rating tab | Official TB2 Manual (Appendix A present; full category names not extracted cleanly from PDF); OOTP forum rating threads = UNVERIFIED_SECONDARY |
| Fire Pro Wrestling World (Spike Chunsoft, 2017) | 24 combat parameters (12 Offense + 12 Defense) + behaviour params (Showmanship, Discretion/Spirit, Flexibility, Cooperation) | Offense / Defense (+ behavioural) | 1–10 | Parameter Edit screens split Offense / Defense | Move slots and logic are separate from the 1–10 params | Official FPWW English manual (Steam / Spike Chunsoft PDF) |
| Wrestling Empire (MDickie, 2021+) | 6 | Flat | Not stated as letters; in-game numeric bars (manual does not print min–max) | Character inspect / roster sort by any of the six | Attitude drives betrayal/trouble beyond match damage | Official Wrestling Empire menus PDF (mdickie.com) |
| MMA Manager (Prey Studios, mobile, 2020+) | 17 fighting skills | Offense skills / Defense skills / Conditioning·Agility·Strength | Recruit custom within a point budget; levels not a single 1–20/0–100 stated in guide | Fighter / recruit skill list | Gameplan sliders separate from base skills | GamingOnPhone beginners guide (lists skill names) |
| EA Sports UFC 5 (2023) | NOT FOUND (complete named sub-attribute list) — Career/CAF use 3 groups: Stand-Up, Grappling, Health | 3 groups | Roster/public materials use star-style / high numeric bands; exact per-attribute scale not confirmed from primary docs this session | Fighter Evolution upgrades inside the three groups; roster hub shows overall categories | Move sets / perks / styles sit beside attributes | Dexerto Fighter Evolution (Stand-Up / Grappling / Health); EA Create-a-Fighter help (archetypes, not full list) |
| WWE 2K24 (2K, 2024) | NOT FOUND (official complete list) — community CAW lists cite ~20 named attributes | Community: Power / Offense / Reversals / Durability / Movement / Special | Community: mostly 0–100 with per-stat caps | Creation Suite attribute pages; Overall derived | Move-set / ability / entrance separate | Reddit / Smacktalks CAW threads = UNVERIFIED_SECONDARY |
Full attribute lists (verbatim where sourced)
Football Manager 2024 — outfield (36)

Technical (14): Corners, Crossing, Dribbling, Finishing, First Touch, Free Kick Taking, Heading, Long Shots, Long Throws, Marking, Passing, Penalty Taking, Tackling, Technique.

Mental (14): Aggression, Anticipation, Bravery, Composure, Concentration, Decisions, Determination, Flair, Leadership, Off the Ball, Positioning, Teamwork, Vision, Work Rate.

Physical (8): Acceleration, Agility, Balance, Jumping Reach, Natural Fitness, Pace, Stamina, Strength.

Goalkeeping technical (13, replaces outfield Technical): Aerial Reach, Command of Area, Communication, Eccentricity, First Touch, Handling, Kicking, One On Ones, Passing, Punching (Tendency), Reflexes, Rushing Out (Tendency), Throwing.

Hidden (commonly listed for FM24): Consistency, Important Matches, Injury Proneness, Versatility (plus scouting-revealed personality / pressure-type values).

Undisputed — from official “Fighter Stats Explained”

Defense / durability: Chin Resistance, Body Resistance, Cut Resistance, Bruise Resistance, Guarding, Courage, Block Health, Block Regen.

Speed / movement: Agility, Move Speed, Punch Speed, Accuracy.

Stamina: Stamina, Stamina Regen, Stamina Recovery, Conditioning, Endurance.

Power: Left Hand Power, Right Hand Power, Power Punch Modifier, Jab Modifier, Hook Modifier, Uppercut Modifier, Straight Modifier, Counter Punch Modifier.

Vitality / health: Head Health, Body Health, Health, Health Regen, Health Recovery.

UI grouping (Create-a-Fighter / career materials): Vitality, Heart, Stamina, Strength, Speed, Defense as category overalls over those sub-stats. Plaion patch notes also name Overall Strength / Speed / Vitality / Stamina / Defense, Heart, Courage, Swelling Resistance, Block Regeneration as edited fields.

World Championship Boxing Manager 2 (7)

Strength, Speed, Accuracy, Blocking, Footwork, Technique, Endurance.

(Niche preview text also mentioned training “intelligence”; that name does not appear on the Fandom training table — treat Intelligence as NOT FOUND on the documented seven.)

Title Bout Championship Boxing 2

DOCUMENTED: Official Manual Appendix A exists with sections Core Categories, Strategies, Other Ratings, Conditioning Ratings. Fight UI shows trait bars for major traits including Control Factor, Hitting Power, Defense, Endurance.

Complete official name list: NOT FOUND this session (PDF Appendix A body not recovered as a clean extract).

UNVERIFIED_SECONDARY (OOTP forum rating sheets — same names recur): Control vs Boxer, Control vs Slugger, Hitting Power, Chin vs Knockdown, Chin vs Knockout, Recovery, Resistance to Cuts, Absorb Punishment, Killer Instinct, Aggressiveness, Endurance, Defense, Fast Starter, Fight on Ropes, Conditioning, Intellect, Proficiency, Fight Inside, Fight Outside, Cover Up, Go for Knockout, Clinching, Punching, Counterpunching, Punches Missed, Overall Rating, Fouls, Draw Power, plus punch-type % splits (2-pt / 3-pt Jab, Hook, Cross, Combination, Uppercut).

Fire Pro Wrestling World

Offense (12): Punch, Kick, Throw, Joint, Stretch, Power, Agility, Arm, Technical, Rough, MMA Overall, Entertain.

Defense (12): Punch, Kick, Throw, Joint, Stretch, Power, Body, Lariat, Technical, Rough, MMA Overall, Entertain.

Behaviour (manual): Showmanship, Discretion (winning vs damage emphasis), Flexibility, Cooperation.

Wrestling Empire (6)

Popularity, Strength, Skill, Agility, Stamina, Attitude.

MMA Manager (Prey) — 17 skills from guide

Punches, Elbows, Knees, Low Kicks, High Kicks, Takedowns, Submission, Ground Grappling, Clinch work, Strike Defense, Submission Defense, Takedown Defense, Knees Defense, Kick Defense, Conditioning, Agility, Strength.

EA Sports UFC 5

DOCUMENTED groups: Stand-Up (aka Striking), Grappling, Health.

Complete sub-attribute names: NOT FOUND from EA primary docs this session. Secondary guides name examples (e.g. Accuracy under stand-up; Body Strength under health) but not a verified full roster.

WWE 2K24

NOT FOUND from 2K official docs this session.

UNVERIFIED_SECONDARY (community CAW lists): Arm Power, Leg Power, Grapple Offense, Running Offense, Aerial Offense / Range, Submission Offense, Strike Reversal, Grapple Reversal, Aerial Reversal, Body Durability, Arm Durability, Leg Durability, Submission Defense, Pin Escape, Strength, Stamina, Agility, Movement Speed, Recovery, Special, Finisher.

The three questions
1. Is there a usable range?
| band | games |
|---|---|
| Low (6–7) | Wrestling Empire (6), World Championship Boxing Manager 2 (7) |
| Mid (~17–24) | MMA Manager (~17), Fire Pro World (24 params) |
| High (~30–36) | Undisputed (~30 numbered + 6 roll-ups), Football Manager (36 outfield) |
| Incomplete this pass | Title Bout (deep but list not verified primary), UFC 5 (3 groups, sub-list incomplete), WWE 2K (community-only) |

Cluster: management/action fighters people actually play sit in two clusters: a small flat set (~6–7) and a large set (~24–36) behind groups. There is no popular mid-career boxing/MMA sim in this survey that parks at “about twelve” as the only model — either a handful of axes, or dozens under buckets.

Seven (FightCamp’s current count) matches the low cluster (WCBM2, Wrestling Empire), not the deep-sim cluster (FM, Undisputed, Fire Pro).

2. How do 30+ attribute games display without drowning the player?

Football Manager 2024 (best-documented deep layout):

Overview: three columns Technical / Mental / Physical (or GK / Mental / Physical).
Numbers 1–20 with role-key highlighting.
Attribute Analysis: spider / radar of summary axes (e.g. Defending, Physical, Speed, Vision, Attacking, Technique, Aerial, Mental) so the wall of 36 collapses to ~8 spokes.
Scouting masks unknown attributes as ranges until knowledge rises — the UI never dumps every number for a stranger.

Undisputed:

Six category overalls (Vitality, Heart, Stamina, Strength, Speed, Defense) on the card.
Detail behind those overalls (hand power, punch-type modifiers, chin/body resistance, stamina regen, etc.).
Traits as a short separate list (few per fighter), not mixed into the 30 numbers.

Fire Pro Wrestling World:

Parameter Edit is explicitly two tabs: Offense and Defense (12 + 12), scale 1–10 — browsing stays inside one tab at a time.

Common pattern among the 30+ systems: group first → show roll-up or tab → detail on demand. None of the verified deep systems present thirty flat numbers with no buckets.

3. What do they do about weakness?
| game | how weakness shows |
|---|---|
| Football Manager | Low 1–20 cells are obvious in the column; Attribute Analysis spider dents on weak axes; scouting Pros/Cons call out hidden weaknesses (injury, consistency); comparison views make red/green gaps visible |
| Undisputed | Category overalls make a soft Chin / Stamina / Speed hole obvious before opening sub-stats; traits can advertise glass-chin or stamina flaws |
| WCBM2 / Wrestling Empire | With only 6–7 numbers, the lowest bar is the weakness — no burial possible |
| Fire Pro | Offense vs Defense tabs; a 3 next to 8s on the same tab is readable |
| UFC 5 | Three-group Evolution screen — a weak Health or Grappling block is visible at group level even without a full public sub-list |
| Title Bout | Trait colour bars on the fight screen degrade from green toward red as a trait fails in-bout — weakness is temporal as well as static |

Games that bury weakness are the ones that only show a single Overall. Every deep system above either highlights lows, dents a radar, or keeps the count small enough that lows cannot hide.

What I could not find
Title Bout Championship Boxing 2: full Appendix A name list as a clean primary extract.
EA Sports UFC 5: complete official sub-attribute name list (only the three group names confirmed).
WWE 2K24: official 2K attribute table (community lists only).
Undisputed CAF vs roster: no evidence the Create-a-Fighter attribute set differs from the roster set; same named stats, different starting values.
A shipped MMA management PC sim with a Football Manager–depth published attribute bible beyond mobile MMA Manager’s skill list.
World Championship Boxing Manager 2: confirmed “Intelligence” as an eighth combat attribute (training table shows seven).
SOURCES
FIFPlay — Football Manager 2024 Player Attributes — https://www.fifplay.com/football-manager-2024-player-attributes/
Passion4FM — Football Manager Player Attributes Explained — https://www.passion4fm.com/football-manager-player-attributes/
Sports Interactive community manual concept: Players / Attributes (FM24) — https://community.sports-interactive.com/sigames-manual/football-manager-2024/players-r4958/
Undisputed official — Fighter Stats Explained — https://playundisputed.com/news/fighter-stats-explained
Plaion — Undisputed Update 1.3 / April 2025 rating change notes (named fields) — playersupport.plaion.com / playundisputed.com news
Xbox Wire — Undisputed career / character creator (category framing) — https://news.xbox.com/en-us/2024/10/08/how-undisputed-enables-you-to-forge-your-own-boxing-path/
World Championship Boxing Manager 2 Fandom — Training — https://world-championship-boxing-manager-2.fandom.com/wiki/Training
Finger Guns — WCBM2 review (seven stats) — https://fingerguns.net/reviews/2023/05/16/world-championship-boxing-manager-2-review-ps4-raging-bulls/
Title Bout Championship Boxing 2 Manual — http://www.titleboutboxing.com/TB2%20Manual.pdf (and mirror PDFs); Appendix A referenced
OOTP Developments Forums — “Rating Fighters for the New Guys” / boxer ratings threads (secondary) — forums.ootpdevelopments.com
Fire Pro Wrestling World English manual — Steam CDN / Spike Chunsoft FPWW PDF
Wrestling Empire menus PDF — https://www.mdickie.com/guides/wempire.pdf
GamingOnPhone — MMA Manager Beginner’s Guide (skill list) — https://gamingonphone.com/guides/mma-manager-beginners-guide/
Dexerto — How to upgrade fighters in UFC 5 (Stand-Up / Grappling / Health) — https://www.dexerto.com/gaming/how-to-upgrade-fighters-in-ufc-5-2352989/
Community WWE 2K24 CAW attribute threads (secondary) — Reddit / Smacktalks
