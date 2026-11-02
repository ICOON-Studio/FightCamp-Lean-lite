# G88 - THE CROWDED FLOOR

> Grok (Expert), reply to `G88_BRIEF.md`, collected verbatim by Claude in S70
> (2026-09-24) from https://grok.com/c/73e13e39-2230-445d-9725-7e728bd3afa9 .
> Page text; table cells are tab-separated as the page rendered them. 96 sources.

FightCamp research, 2026-09-24. No code. Answers the four questions S69 slice two needs before any crowding constant is treated as evidenced. Current authored values in Godot/assets/data/membership.json: crowd_peak_fraction 0.15, crowd_yield_slope 0.3, crowd_yield_floor 0.6. J8 N10 still holds for a published combat-gym utilisation table; the figures below are the closest published and owner-reported proxies.

## 1. Peak share

What we have, combat-specific

Source	What it actually measures	Number
Gymdesk platform, 2022 baseline	Average roster at a US martial-arts school	112 members (Canada 136, UK 143, EU 159). Not floor headcount.
Gymdesk Benchmark 2026	Visit frequency buckets vs churn (801k memberships)	Rarely / ~1× / ~2× / 3+ per week. No "share on the floor at 18:00".
r/bjj owner thread (2023)	Share of students at a typical night class	10–33%. Worked example: 30 of 100 on a Thursday night.
KL Judo "1/3 rule" (Oon Yeoh, 2022)	Share of members on the mat on a given day (working-adult recreational judo)	~33% per day, not per class. "Want 20 on the mat → need 60 members."
Sherdog / academy owner posts (recurring)	Observed night-class headcount	Slow 8–10, typical 15–25, packed 30–40.

Worked conversion at the Gymdesk mean: a 20-person evening class on a 112-member roster is 18%. A packed 30-person class is 27%. A slow 12-person class is 11%. That band is the only combat-gym peak-share evidence found.

What IHRSA / HFA transfers, and how far

HFA / IHRSA numbers are big-box and studio fitness, not a 1,500–4,000 sq ft fight gym.

- 2016 IHRSA Consumer Report: attendance held at ~101–103 visits/year (~2×/week).
- 2019 IHRSA: 109.5 visits/year.
- 2018 Profiles of Success (club-reported, not consumer survey): median 57 visits/member/year.
- HFA 2026 Consumer Report: 81 visits/year in 2025 (down from 109 in 2019); ghost members 4.6%.
- Rework 2025 peak-hour guide (citing IHRSA 2024 Consumer Report): peaks are 05:30–08:00, 12:00–13:00, 17:00–19:30; off-peak (09:00–16:00 weekdays) runs at 28% of peak-hour capacity; 41% of cancellations cite overcrowding at peak as a reason.
- Boutique / studio class fill (attendees ÷ class cap, not ÷ roster): industry average 52–58%; profit floor ~70%; peak evening slots 90%+ of class capacity (Fairview 2026, PulseRevOps, StudioStack, IHRSA studio performance cited at 62% average boutique fill).

Transfer rule. Evening clustering and "crowding kills retention" transfer. The percentage of the membership standing on the floor in one slot does not. A Planet Fitness with 1,400 members and open floor is a different machine from a class-capped BJJ academy. Do not import 52–70% class-fill as crowd_peak_fraction. Class-fill is occupancy of a capped slot. Peak share is occupancy of the roster.

Verdict on 0.15. It sits at the low end of the combat owner band (10–33%). A typical evening class at a 112-member school is closer to 0.15–0.22. 0.25 is a packed night, not a mean. 0.33 is the judo daily rule and overstates one class.

Vendors named in the brief (Gymdesk, Zen Planner, Mindbody, Glofox, PushPress, Spark) all track attendance, occupancy, waitlists. None publish a combat-gym "% of members on the floor at peak" table. Glofox documents occupancy = booked÷capacity and utilisation = attended÷capacity — class-cap metrics, not roster-share.

## 2. Class size and kit

Typical class size

Discipline	Typical	Packed / capped	Source
BJJ (adults)	10–25	30–40; owners then split or waitlist	Sherdog class-size thread; academy blogs (small academy 5–15, large 30+)
Boxing / Muay Thai skill class	8–20	20–24 hard cap common in 1,600 sq ft boutique boxes	H&G Boxing session plans; boutique-boxing layout video (20 max, stretch to 24)
Boxing-for-fitness / bag class	12–30	Rotation required above bag count	Century Kickboxing gym-owner note; school PE plan 24–30 on 8 bags
MMA mixed class	15–25	Same as BJJ when it hits the mat; bag-limited when it strikes	Owner reports; no vendor table

Members per station at a full class

Station	"Full" density	Source
Heavy bag, class format	1 person per bag (or 2 on a large bag, opposite sides)	Compound Fitness AU equipment guide; Century Kickboxing; TruFusion 10–16 bags, 2/bag; Life Time 8–10 bags, 1–2/bag
Heavy bag, open gym / peak period	1 bag per 15–20 members of the roster	Compound Fitness AU: "For an open gym with rotating users, 1 bag per 15–20 members (peak period)"
Ring / cage	NOT FOUND as simultaneous users. Observed pattern: 2 in the ring, rest of class on bags/pads. A 16–20 ft ring is one pair, not a class container.	Facility pages list ring count, never "N members per ring at capacity"
Mat, drilling	4–6 m² / person (~43–65 sq ft)	MatGoat tatami calculator
Mat, rolling / randori	8–10 m² / person (~86–108 sq ft); owner rule 50–75 sq ft/person; Gymdesk scheduling post 64 sq ft per rolling pair (8×8)	MatGoat; Member Solutions BJJ open-gym guide; Gymdesk "BJJ Class Scheduling"; r/bjj 50 sq ft/student, 100 sq ft/pair
Mat, COVID Grapplearts rec (not normal ops)	100 sq ft/person, or 12×12 per pair	Grapplearts academy reopening guide, 2020

Worked mat cap: 1,500 sq ft of mats → Gymdesk 64 sq ft/pair → ~23 pairs / 46 people as a sparring ceiling. Member Solutions 50–75 sq ft/person → 20–30 people. That is the point owners cap the class.

When owners add a class or kit

- Persistent waitlist. Gymdesk: "Monday evening fundamentals waitlist of 12 every week → add a session."
- Class hits the mat/bag cap and quality drops (see §3). They cap and waitlist rather than overfill.
- Martial Arts Wealth / academy-growth posts treat a 2,400 sq ft school at 680 actives as "a zoo"; practical rule of thumb they quote is ~7 sq ft of building per active member (roster, not simultaneous). That is a business-density number, not a training-quality number. Do not use it as station capacity.

## 3. What crowding costs

Coach attention. Qualitative only. Large-academy writeups: 30+ students → "easy to get overlooked"; small academy selling point is 5–15 and a low student:coach ratio. No published "minutes of coach time per student vs class size" curve.

Rounds per bag. Implied by kit: if the class is 20 and bags are 8, a bag-block gives each person ~40% of the bag minutes unless the coach rotates stations (the 24–30-person PE plan does exactly that: three groups, bags / circuit / partner). Magnitude of stat-yield loss: NOT FOUND.

Injury vs mat density. NOT FOUND as a function of people per m². What exists:

- Hinz et al. 2021 (OISM, 1,140 athletes, 62 countries): 77.6% of BJJ injuries during sparring; submissions 29.7%, takedowns 26.4%. Risk factors: competing, age, belt — not class size.
- BMJ Open SEM 2025 (881 athletes): training incidence 5.5 / 1,000 hours; 70% of detailed training injuries during free sparring.
- BJJ Notes digest of Hinz: regular class 6.3% per-session injury report vs private 5.1% vs competition 15.9%. The private-vs-class gap is small and is not a density study.
- Mechanism talk (collisions on a packed mat) is owner folklore. No paper plots injury rate against m²/person.

Pros leaving busy gyms. Anecdote-grade. Scheduling evidence is stronger than exit evidence:

- Pros run AM + afternoon double days (12–18 sessions/week). Member classes sit on the evening peak the fight team would otherwise use.
- Common real pattern: morning fighter S&C / technical, midday open-mat or fighter-only, evening member classes. Open mat is the shared slot; it is not the fight team's quality session.
- No published "pros leave when evening class exceeds N" figure.

Retention cost of crowding (fitness, not combat). IHRSA 2024 via Rework: 41% of cancellations name peak overcrowding. That is the strongest numeric crowding-cost in the fitness literature. It is about membership loss, not training yield.

## 4. How games model it

Game	Mechanism	Transfers to FightCamp?
Football Manager	Training-ground tier (Poor → State of the Art, 0–20) multiplies development rate. Staff count scales with facility level. No "members on the pitch eat first-team reps."	Tier-as-multiplier yes. Crowding-as-ratio no.
Punch Club 2	Home kit and paid gym sessions have time/energy/food costs and gear efficiency. No shared floor, no members.	Station quality yes. Crowding no.
Gym Simulator / Tycoon	Queues at machines; unserved demand walks.	Queue-at-station is the right kind. Published formulas for yield loss: NOT FOUND.
Two Point Hospital	Queue length + room capacity + staff; throughput falls when rooms overflow. Happiness/reputation take the hit, not a published % yield curve.	Same shape as S69 crowding: over cap → output and satisfaction drop. Magnitudes are authored.
Youth-soccer crowding writeups (not a game)	Touches/session cited as falling from 200–500 to 20–50 on a packed field.	Useful analogy for "reps per athlete," not a combat citation.

No management game publishes a combat-gym peak-share or a measured yield slope. S69's shape (ratio > 1.0 → yield falls to a floor) matches FM-tier + Two Point-queue. The 0.3 slope and 0.6 floor remain authored.

## 5. What the engine should gate

Figures the sim may treat as sourced. Everything else stays labelled invented.

Gate	Band	"Full"	Overload where quality drops	How much it drops	Source
Peak share of roster on the floor in the busiest evening class	0.10–0.33	0.15–0.22 typical at ~112 members / 15–25 in class	Packed night ~0.25–0.33	n/a (this gate is headcount, not yield)	r/bjj 10–33%; Gymdesk 112 × observed class 15–25; judo 1/3 is daily, not per class
Heavy bags, class	—	1 person/bag (2 on a large bag)	Class size > bag count without a rotation	Reps fall ~bags/heads. Yield % NOT FOUND	Compound Fitness; Century Kickboxing; TruFusion / Life Time layouts
Heavy bags, open-gym peak	—	1 bag / 15–20 roster members	Above that, wait-for-bag	NOT FOUND	Compound Fitness AU
Ring / cage	—	1 pair	Second pair waits	NOT FOUND	Observed scheduling, not a table
Mat, drilling	—	4–6 m² / person	Tighter than 4 m²	Comfort, not injury data	MatGoat
Mat, live rolling	—	8–10 m² / person or 64 sq ft / pair	Persistent waitlist; owners cap rather than pack	Injury-vs-density NOT FOUND. Coach attention NOT FOUND as a curve	MatGoat; Gymdesk; Member Solutions 50–75 sq ft
Class cap / add-session trigger	—	Class at mat or bag cap	Recurring waitlist (owner example: 12/week)	They add a class, they do not publish a yield penalty	Gymdesk scheduling guide
Fight-team isolation	—	Pros train off the evening member peak (AM / fighter-only)	Sharing the evening class	Quality loss NOT FOUND as %	Pro schedule writeups (Sweet Science, Grounded MMA)
Yield slope / floor	—	Ratio 1.0 = stations full	Ratio > 1.0	NOT FOUND. 0.3 / 0.6 remain invented. Fitness transfer: overcrowding → churn (41% of cancellations), not a stat-gain multiplier	IHRSA 2024 via Rework; membership.json
IHRSA peak-hour share of membership	—	—	—	NOT FOUND	HFA/IHRSA publish visits/year and peak clock, not % of roster on the floor

Slice-two recommendation (evidence, not a balance patch). Keep crowd_peak_fraction inside 0.15–0.22. 0.15 is defensible as a quiet night; treat 0.20 as the mean evening class at a Gymdesk-sized school. Do not raise it to 0.33 unless the slot is modelled as "whole day's attendees," which it is not. Leave slope and floor invented. Gate "full" off bags and mat m², not rings. Model fight-team yield loss only when the team is marked as sharing the member evening slot; the real world usually does not.

Still unknown: a vendor-published combat-gym peak-hour roster share, and any measured drop in training quality or injury rate as a function of people per bag or per mat m².
