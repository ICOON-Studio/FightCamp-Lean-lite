# J35 - HOW THE GENRE MODELS A LIVING RIVAL PROMOTION

**Owner:** john. **Collected 2026-09-22 from the Grok Bot app by Tools/grokbots/collect_chat.py.**

**HOW THIS WAS COLLECTED, and it matters.** `grokbots.py read` returns the
SIDEBAR, not the message column - 1,677 characters for a chat holding
14616. On 2026-09-22 that made a finished delivery read as "the bot stopped
without replying", and it was reported to the operator that way before being
corrected. `Tools/grokbots/collect_chat.py` reads `main.sand-chat` and POLLS
until it stops growing, because a dump taken the instant a chat opens returns
16 characters. The raw capture is kept beside this file in `_collect/`.

---

1:57 AM
NEW

J35 is already mid-pass from the room ask. Checking whether it has closed; full memo text comes back here (Claude lands the file).

1:57 AM

Still digging TEW / FM / OOTP and the fight-side sims. I’ll post the full J35_RIVAL_PROMOTIONS.md text as soon as the pass exits — no separate land from me.

1:57 AM

J35 done — full text of J35_RIVAL_PROMOTIONS.md follows (Claude lands the file; I do not edit HANDOFF). Claude mailbox sent. Staging copy left for Claude to pick up.

J35 — How the Genre Models a Living Rival Promotion

Research date: 2026-09-22 (Asia/Nicosia, EEST)

Method: Live web (WebSearch/WebFetch/curl). Prefer manuals/wiki/dev journals over store fluff. Numbers not published = NOT FOUND.

Label key: DOCUMENTED / INFERRED FROM PLAY (with attribution) / NOT FOUND / MARKETING CLAIM, UNVERIFIED

STATUS (which games sourced / NOT FOUND)
Game	Status	Primary sources used
Total Extreme Wrestling (TEW 2020 / TEW IX)	CLOSED (strongest)	TEW 2020 Fandom wiki Companies + Running Your Company (handbook-derived); Adam Ryland TEW IX Dev Journal via TEWDB / BeTheBooker mirrors; community Reddit on bidding surfaces
Wrestling Empire (MDickie)	CLOSED	Official instruction manual PDF (mdickie.com/guides/wempire.pdf) Booking section
Football Manager	PARTIAL	Official FM feature pages (transfers/finance); SI manual page Cloudflare-blocked this pass; Reddit/community on rival-wake-up bidding
Out of the Park Baseball (OOTP)	CLOSED	Official OOTP Wiki Free Agents; OOTP Developments Forums free-agency threads; Reddit FA complaints
Promoter	IDENTITY VERIFIED; MECHANICS THIN	Two relevant Steam titles (see section). Released wrestling: Championship Wrestling Promoter. Boxing: PROMOTER: The Fight Game (Coming soon). No manuals found with rival state fields
MMA Sim King	STORE ONLY / NOT SHIPPABLE DOCS	Steam page (Coming soon). No manual, wiki, or patch notes with rival field lists
Believr Pro Wrestling	STORE + EA CLAIMS; MECHANICS THIN	Steam Early Access page (released Jan 29, 2026). Patch-note body not reliably fetched this pass

Could not source deeply: MMA Sim King internals; PROMOTER: The Fight Game playable mechanics; full Believr AI rival field list; SI FM24 HTML manual (Cloudflare); Grey Dog official TEW IX PDF handbook (not freely hosted — used wiki + published Dev Journal text); exact numeric bid formulas (dice vs deterministic) for TEW/FM/OOTP.

DECISIONS (evidence only)
A “living rival” in this genre is almost never a full second player-sim. It is shared competitive surfaces (talent market, ratings/league table, territory, news) plus enough rival state that those surfaces move without the player’s say-so.
The cheapest felt rivals reuse existing player loops (negotiate / shortlist / rankings / inbox) and inject rival names into them — TEW, FM, OOTP, Wrestling Empire all do variants of this.
Store phrases like “living world” / “world keeps moving” without named surfaces are MARKETING CLAIM, UNVERIFIED for FightCamp-adjacent titles that are unreleased or Early Access without manuals.
Bankruptcy / runaway AI / immortal rivals are the main failure modes players name; they are balance symptoms of the same systems that make rivals feel real.

(continued — per-game sections next)

1:58 AM
Per-game sections
1. Total Extreme Wrestling (TEW 2020 / TEW IX) — primary model
1) What state does a rival hold?

DOCUMENTED (TEW 2020 Fandom wiki Companies, handbook-derived; applies to AI and player companies):

Field / concept	Notes
Size	Seven tiers: Insignificant → Tiny → Small → Medium → Big → Large → Titanic. Criteria by home region; rise via popularity in key regions. Fall from Big → six-month “cooling down” before Big again. Optional max size.
Popularity by region	Per-region knowledge/willingness to watch/buy merch; spills across regions (see Game World).
Prestige	Importance/respect; driven by show quality and scandals/failed dirty tricks; weights how important stories about the company are.
Momentum	Popularity-direction visual; more sensitive than prestige.
Finances / bank balance	Observable on company profile / Companies screen (click funds). Misc costs, tax on profit months (wiki: 5%–40% by profit).
Bankruptcy clock	Consecutive months in negative bank balance (debt amount irrelevant). Survival window by size: 6 months to 3 years; older companies get more leeway. New companies: 1-year grace (TEW 2020 wiki). TEW IX Dev Journal / TEWDB: new companies get three-year bankruptcy grace (DOCUMENTED via published Dev Journal text). Child companies cannot bankrupt (parent absorbs balance).
Roster / hiring targets	AI maintains min/max workers by role; mins from size, product, owner roster preference; financial trouble → skeleton crew. Hire-check frequency rises with size.
Titles / belts	Companies have titles; optional Fixed Belts so AI never creates/retires belts. Figurehead (“ace”) is separate face-of-company state (attendance/merch bonuses after 1 year established).
Broadcasting / ownership	Company can be Property Of a Broadcaster/Media Group (easier related broadcast deals; closes if parent closes). Broadcasting deal structure expanded in TEW 2020 Dev Journal #29 (Company Pays / Broadcaster Pays / Revenue Split / Exclusive Rights) — DOCUMENTED as deal system for companies; per-rival live deal values = observe in-game, not invented here.
Backstage rating	Locker-room atmosphere % (personalities, relationships, other); affects morale/incidents.
Owner type / goals	Lifetime / purchased / etc.; owner goals constrain bookers.
Home arena, alliances, closed date	Editor + runtime state.
Champions as transferable assets	Titles belong to the company; poaching a champion does not automatically move the belt with them — INFERRED FROM PLAY (r/FantasyBookers threads on stealing exclusive champions; players report vacate/remain-with-company behavior). Exact belt rules: wiki titles systems exist; full transfer matrix partially NOT FOUND this pass.

TV deal as a single named rival field list: partially DOCUMENTED as system; specific published numeric table of every rival’s deal terms = NOT FOUND outside the game itself.

2) What decisions on what clock?

DOCUMENTED:

AI hiring: Roster checks and offers; frequency depends on company size (bigger = more often). Target choice: “literally hundreds of factors”. No published dice table or closed-form bid formula → exact random vs deterministic mix = NOT FOUND.
AI firing: Typically every 6–9 months for limit checks; rare if financially healthy; often needs ≥3 months losses OR debt.
Contract negotiation clock: Worker reviews all offers (AI and human same scoring). Written contracts become negotiable in final window — community cites final ~28 days / shortlist alerts (INFERRED FROM PLAY).
Bidding wars: Rival AI can raise offers over days — INFERRED FROM PLAY (r/FantasyBookers Jul 2024).
Shows / TV / events: Show Priority / Event Order / TV Order (DOCUMENTED). Full AI booking algorithm NOT FOUND as published numbers.
TEW IX: AI companies get same backstage incidents as player, with stories on the in-game website — DOCUMENTED (Adam Ryland Dev Journal).
3) How does the player FEEL the rival?
Surface	Evidence
Company profile / Companies list	Size, funds, roster, contracts of rivals viewable
Rival contract list	Companies → rival → Roster → Contracts (INFERRED FROM PLAY)
Shortlist notifications	Notified when negotiable (INFERRED FROM PLAY)
Negotiate / rival bids UI	Re-open Negotiate to see stack vs others (DOCUMENTED)
In-game website / news	Prestige-weighted; TEW IX AI backstage stories (DOCUMENTED)
Poach of your worker	Competing offers — dedicated “X poached Y” push string table NOT FOUND
4) What breaks?
Symptom	Where	Grade
AI escalates bids daily on contested talent	r/FantasyBookers Jul 2024	INFERRED FROM PLAY
Major AI companies historically too rich; TEW IX cut major profits / extended new-company grace	TEWDB / Dev Journal	DOCUMENTED
“Bankruptcy year 3” as fixed law	NOT FOUND — bankruptcy is consecutive-negative-months by size (6 mo–3 yr)	—
Player can’t compete by year 5	NOT FOUND as consensus TEW failure mode this pass	—
2. Wrestling Empire (MDickie) — Booking Mode
1) State (DOCUMENTED — official manual)

Roster; contracts (buyouts); TV/promotion rating; territory ownership; champions as face of brand; finances. Prestige as TEW-like field: NOT FOUND. TV deal as broadcast-rights contract: NOT FOUND (ratings war, not network negotiation).

2) Clock (DOCUMENTED)

Weekly TV tapings + PPVs; ratings update on broadcast; rival promoters bid to buy your talent (escalating; formula numbers NOT FOUND); territory invasion → inter-promotional war (6 matches).

3) Feel (DOCUMENTED)

TV ratings ladder after each broadcast; territory map; buyout/bid interactions; weekly news; interpromotional war cards.

4) Breaks

Cannot permanently kill rivals (INFERRED FROM PLAY, r/WrestlingEmpire); Booking Mode economy punishing / sell stars to stay afloat (INFERRED FROM PLAY); spreading thin weakens brand (DOCUMENTED manual warning).

(continued)

1:59 AM
3. Football Manager (rival clubs — mature analogue)
1) State

DOCUMENTED at feature level: finances / transfer & wage budgets, reputation, squad, contracts, league position, facilities, ownership/board, broadcasting/commercial income. Exact published “rival AI brain” field dump = NOT FOUND (SI HTML manual Cloudflare-blocked this pass).

2) Clock

Transfer windows; daily/inbox negotiation; SI “Smarter Transfers” design intent (DOCUMENTED feature pages, not a formula). Guaranteed “your bid wakes AI” = INFERRED FROM PLAY (r/footballmanagergames), not an official dice table.

3) Feel

Inbox/news; shortlist alerts; transfer centre rival-interest labels; league table / fixtures / scouting; Deadline Day UI.

4) Breaks

Piggyback interest when you bid (INFERRED FROM PLAY); SI iterates “smarter AI” acknowledging past randomness (DOCUMENTED framing).

4. Out of the Park Baseball (OOTP)
1) State (DOCUMENTED)

Payroll/budgets, roster, farm, media/market, FA/extension funds. Rival GM fully controls those teams.

2) Clock (DOCUMENTED)

FA mainly offseason; Pending Offers tracks your offers only — “Offers that other teams have made are not displayed here” (OOTP Wiki). Bid formula dice-vs-number = NOT FOUND.

3) Feel

Negotiation text naming other offers (INFERRED FROM PLAY); news/email; standings/transactions. No public rival-offer board (DOCUMENTED).

4) Breaks

Bid cascade the moment you offer (INFERRED FROM PLAY, r/OOTP); FA vacuum until you touch a name; overpays near spring training in long wars.

5. Promoter — identity check
Title	Status	Rival framing
Championship Wrestling Promoter (1918440)	Released	TV ratings war; monthly 4× TV + 1× PPV — STORE; AI field list NOT FOUND
PROMOTER: The Fight Game (4448300)	Coming soon (boxing)	MARKETING CLAIM, UNVERIFIED — Q1–4 NOT FOUND

Championship Wrestling Promoter feel = ratings war (STORE); talent-poach UI NOT FOUND; breaks corpus NOT FOUND.

6. MMA Sim King

Entirely MARKETING CLAIM, UNVERIFIED. Answers 1–4: NOT FOUND beyond store promises.

7. Believr Pro Wrestling

STORE / EA copy: AI promotions, news, ratings, rival list in GM Mode Head Office. “World that keeps moving” = MARKETING CLAIM, UNVERIFIED. Exact rival state / bid math / failure modes = NOT FOUND. Patch-body fetch failed this pass.

(judgement + sources next)

1:59 AM
Cross-cutting failure modes
Failure mode	Games	Pattern
Reactive piggyback bidding	FM, OOTP, TEW handshake echoes	Fake quiet → sudden unfair
Runaway rich AI / immortal majors	TEW (IX cut profits); Wrestling Empire (can’t kill brands)	Never die or never starve
Player economy death spiral while AI floats	Wrestling Empire Booking	Rival living; player hunted
Hidden rival offers	OOTP (by design)	Felt only at negotiation punchline
Marketing “living world” with no surfaces	MMA Sim King, PROMOTER Fight Game, Believr EA	Promised motion; no documented loop
Three cheapest felt mechanisms (ranked)

Cheapest = least new state + fewest new screens.

1) Inbox / news line that names a rival action (cheapest)

Needs: rival id + verb + optional object. Reuse existing news/inbox. No new screen.

Evidence: TEW website stories; TEW IX AI backstage → website; FM inbox; Wrestling Empire weekly news + ratings.

2) Competing offer / buyout ping on talent you already care about

Needs: on existing negotiate/contract UI: rival_id, offer_value (or buyout), status. Optional shortlist.

Evidence: TEW Negotiate + rival bids; Wrestling Empire buy bids; OOTP “other team offered”; FM rival interest.

3) One shared ladder with rival champion (or rating) on it

Needs: per rival one comparable score + optional champion_name; one list UI; weekly/monthly update.

Evidence: Wrestling Empire ratings table; Championship Wrestling Promoter ratings war; TEW Companies list; FM league table.

Explicitly more expensive (not top three): full AI show booking, broadcast-rights auctions, territory wars, bankruptcy sim for every rival.

WHAT I COULD NOT FIND

Numeric bid formulas (TEW/FM/OOTP); Grey Dog TEW IX PDF handbook freely hosted; SI FM24 Transfers HTML (Cloudflare); MMA Sim King non-store docs; PROMOTER Fight Game playable mechanics; Believr primary patch body; TEW “can’t compete year 5” consensus; exact TEW champion-belt transfer matrix; whether Championship Wrestling Promoter AI poaches or only ratings-wars.

SOURCES (grade A/B/C)
URL	Who	Year	What	Grade
https://tew2020.fandom.com/wiki/Companies	TEW 2020 wiki	TEW 2020	Size, AI hire/fire, prestige, finances, bankruptcy	A
https://tew2020.fandom.com/wiki/Running_Your_Company	TEW 2020 wiki	TEW 2020	Hiring, offer evaluation	A
https://tewdb.com/whats-new-in-tew-ix-every-new-feature-announced-so-far/	TEWDB / Ryland journal	2024	TEW IX AI backstage, economy	A/B
https://www.mdickie.com/guides/wempire.pdf	MDickie manual	2020s	Booking rivals, bids, territories, ratings	A
https://wiki.ootpdevelopments.com/…/Free_Agents	OOTP Wiki	ongoing	FA screens; other offers hidden	A
https://www.footballmanager.com/features/smarter-transfers-squad-building-and-finance	SI	FM24/26	Smarter AI recruitment	B
Reddit FantasyBookers / TEW / FM / OOTP / WrestlingEmpire threads cited in memo	Players	2019–2024	Bid escalation, piggyback, immortal rivals	B
Steam pages: Championship Wrestling Promoter, PROMOTER Fight Game, MMA Sim King, Believr	Steam	2024–2026	Store/marketing only	C

End of J35 memo. Claude: please land the full file from staging / this chat and write HANDOFF.

1:59 AM
J35_RIVAL_PROMOTIONS
.md
28kB
1:59 AM
Messaged
John Research, Koxar
1:59 AM

Full memo is in the messages above plus the attached .md. Claude has the mailbox ping to land it and write HANDOFF.

1:59 AM
