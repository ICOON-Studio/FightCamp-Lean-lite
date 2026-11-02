# K37 — ABSOLVER'S MOVES IN FRAMES: HOW LONG AN ATTACK TAKES, HOW IT CHAINS, HOW A HIT IS RECOVERED FROM

Kalli (Grok Bot), research, 2026-09-13, one pass. Task: `research/TASK_K37.md`. Written into the repo by Claude
from Kalli's reply; the tables are Kalli's. Published developer words, the game's UI and community measurements only -
no datamined or decrypted data (the install's pak index is AES-encrypted and was not touched).

## DECISIONS (Claude's reading, for the capture)

1. **Absolver counts frames at 30 fps** in its own deck editor (start-up, advantage on hit, advantage on guard);
   fastest start-ups ~9-10 f (300-333 ms: Direct Punch, Wrist Jab), Hook 12 f, Spiral Palm 24 f - SECONDARY.
2. **Chaining is authored, not blended:** every attack starts and ends in one of four stances (DOCUMENTED, Sloclap);
   a timed "goldlink" cancels ~4 f of the previous attack's recovery (community, disputed). No blend or montage
   milliseconds were ever published (NOT FOUND) - so a capture is the only way to get Absolver's join speeds.
3. **Hand-keyed, not motion capture** (Tarno via Eurogamer, DOCUMENTED): a stylised reference, never a realism anchor.
4. **Defence and stun:** style abilities 3 f to active then 5 f active; guard-break stun ~45 f (1.5 s) - SECONDARY.
5. **Offline mode exists** (Options -> Offline Mode, official FAQ) - the capture uses it; Steam ownership still assumed.
6. **For our capture:** check the rig against three long, high-contrast timings first (a named attack's start-up to
   contact, a goldlinked vs late chain gap, a guard-break stun) before trusting it on the joins.

## KALLI'S TABLES
### 1. Attack frame data

| Finding | Number or rule | Label | Source |
|---|---|---|---|
| Deck editor detail view exposes per-attack Start up, Advantage on hit, Adv. on guard, plus hitbox height / movement | Press L / click right stick in deck editor; bars (power/speed/range) are approximate only | DOCUMENTED (UI, described) | obliviondoll, guide to the basics of Absolver, Steam, Jul 2018 / upd. Feb 2019 — https://steamcommunity.com/sharedfiles/filedetails/?id=1423320634 |
| Frame unit | Absolver UI frame counts are 30 fps; vs Street Fighter/Tekken (60), double the Absolver number for wall-clock compare | SECONDARY (guide author; matches Steam FAQ PC 60 / PS4 30 render note) | Same Steam guide; Official FAQ “What’s the deal on framerate?” — https://steamcommunity.com/app/473690/discussions/0/2579854400733819593 |
| “Speed” bar | Rough indicator of startup and recovery — not a hard class table (no published ms bands for Fast/Med/Slow) | DOCUMENTED (UI text via guide) | obliviondoll Steam guide (Attack properties) |
| Fastest published startups (examples) | Community cites Direct Punch ~9f, Wrist Jab ~10f as among the fastest; no attack faster than 9f claimed | SECONDARY (player tests / deck theory) | r/absolver “Teach Me About Frames” (2018) — https://www.reddit.com/r/absolver/comments/98y4ec/teach_me_about_frames_reddit_senseis/ ; “Regarding frame data…” — https://www.reddit.com/r/absolver/comments/991j23/regarding_frame_data_startups_and_followups/ |
| Named example: Spiral Palm | Startup 24f; adv on hit 12f; adv on guard 12f (30f clock) | SECONDARY | Same “Teach Me About Frames” thread |
| Named example: Hook | Startup 12f; adv on hit 6f | SECONDARY | r/absolver “Advantage on Hit Explained…” — https://www.reddit.com/r/absolver/comments/c2jwbz/advantage_on_hit_explained_and_how_it_can_deal/ |
| Full per-attack startup / active / recovery / stance bridge tables | Community spreadsheet (Ab-Science / balistafreak Move Data Compendium) aggregates coverage, relative speed, and (updated) in-game numbers for 1.24+; Steam guide points at sheet — this pass does not re-copy the entire sheet | SECONDARY (community measurement + in-game detail view re-entry) | Steam: https://steamcommunity.com/sharedfiles/filedetails/?id=1226563063 · Sheet: https://docs.google.com/spreadsheets/d/1_6kC-2C-bfgDwfI-R2UZCTa9rEa4vr2Q6ZKep88CA9E · Reddit Ab-Science 1.24 update: https://www.reddit.com/r/absolver/comments/9jbc8h/abscience_sheets_have_been_updated_for_124/ |
| Active frames + full recovery (hit → next input / back to guard) as a complete official table | Not published as a single developer sheet; recovery is partly implied by goldlink (cancels recovery) and by adv on hit/guard | NOT FOUND (official complete active/recovery) | — |
| Style / school on each attack | Present in UI and community lists; start/end stance shown per slot in deck editor | DOCUMENTED (UI) | obliviondoll Steam guide; Eurogamer feature (stance begin/end) — https://www.eurogamer.net/the-quest-for-the-ultimate-videogame-martial-art |

### 2. Chaining

| Finding | Number or rule | Label | Source |
|---|---|---|---|
| Combat Deck vocabulary | Four stances (FR/FL/BL/BR); per stance a sequence (up to 3 slots when fully unlocked) + one alternative; attacks have start stance and end stance; alts must change stance | DOCUMENTED | Sloclap Combat Overview (marketing) + GamingBolt interview (Pierre Tarno / SloClap), 9 Aug 2017 — https://gamingbolt.com/absolver-interview-dancing-with-combat ; obliviondoll Steam guide |
| Fluid chain rule (design intent) | Sequences and alts “chain fluidly without interruption”; next attack starts from the pose the last ended in | DOCUMENTED | Official Combat Overview + GamingBolt interview; Eurogamer (extends our J19) |
| Goldlinking | Timed follow-up input (markers on stamina bar) cancels recovery of the current attack so the next startup begins sooner; deliberate miss = slower chain | DOCUMENTED (mechanic) / SECONDARY (timing numbers) | obliviondoll Steam guide (“goldlinking”); Fextralife Combat — https://absolver.wiki.fextralife.com/Combat |
| What goldlink does to frames | Cancels active/recovery of the previous move; does not shorten the next move’s startup; deck-editor frame data is generally read assuming goldlink | SECONDARY | r/absolver Faejin / goldlink Q&A — https://www.reddit.com/r/absolver/comments/t0tn6w/some_questions_about_faijin_backstance_avoid/ ; https://www.reddit.com/r/absolver/comments/w9gco9/when_i_speed_up_a_move_with_gold_attack_do_frames/ |
| Goldlink savings / window | Player tests commonly cite ~4f recovery cancelled / ~4f input window (two close timings); contested vs “UI data incomplete” | SECONDARY (player measurement; disputed) | r/AbsolverGame “Missing Frames found Goldlinking” — https://www.reddit.com/r/AbsolverGame/comments/8ymj3m/missing_frames_found_goldlinking/ ; Fextralife Combat Deck frametrap formula uses +4f goldlink — https://absolver.wiki.fextralife.com/Combat_Deck |
| Frametrap rule of thumb | [next startup] − ([adv] + 4) = opponent free frames; style ability hard under ~3f; jabs often under ~9–11f | SECONDARY | Fextralife Combat Deck |
| Alternate attack timing | Alt usable “at any time” to break sequence and change stance; no separate published ms window beyond goldlink/sequence rules | DOCUMENTED (rule) / NOT FOUND (distinct alt-only frame window) | GamingBolt interview; Combat Overview |
| Manual stance change | Separate input (hold RT + stick / QEZC); telegraphed; used instead of attacking into a bridge | DOCUMENTED | obliviondoll Steam guide |

### 3. Defence and hit timings

| Finding | Number or rule | Label | Source |
|---|---|---|---|
| Frame clock for style abilities | 30 fps; basic style abilities: 3f delay to active (0.1 s), then 5f active; Faejin low parry active 3f | SECONDARY (experienced guide author on Steam Q&A) | obliviondoll answer, Steam “What are the parry timing numbers?”, Jun 2020 — https://steamcommunity.com/app/473690/discussions/0/2288338908683605683/ |
| Forsaken parry | Direction + timing; successful parry = fixed stun; buffered confirms commonly ≤15f startup (occasional 16–17f with latency) | SECONDARY (wiki + players) | Fextralife Forsaken — https://absolver.wiki.fextralife.com/Forsaken ; Steam discussion linked above |
| Forsaken parry active window | 5f active (same as other basic abilities) | SECONDARY | obliviondoll Steam guide + Jun 2020 Steam answer |
| Kahlt absorb | On success: ignore stun (better than block); damage becomes regenerable white HP; short resilience; breaking attacks cannot be absorbed | DOCUMENTED (ability rules via guides) / NOT FOUND (exact absorb active/recovery frame sheet from Sloclap) | obliviondoll Steam guide |
| Windfall avoid | Directional (jump / duck / side); correct avoid slows opponent, blocks goldlink, drains stamina; too-early avoid fails on slow (~20f+) attacks | DOCUMENTED (rules) / SECONDARY (timing feel) | obliviondoll; r/absolver Faejin avoid thread |
| Manual dodge i-frames | ~2 invincibility frames early in the dodge; host advantage may lengthen | SECONDARY (wiki) | Fextralife Combat |
| Hit / block stun (normal) | Brief stun on hit or block; cancellable into guard → true combos generally require guard break | SECONDARY | Fextralife Combat |
| Guard break / stamina break stun | Broken-guard stun ~45 frames @ 30 fps (~1.5 s); cannot cancel into block; enables multi-hit confirms | SECONDARY | Fextralife Combat; r/absolver guardbreak punish threads (e.g. https://www.reddit.com/r/absolver/comments/8zgcq7/guardbreak_combos/) |
| Exact hitstun ms per attack (non–guard-break) | Only via Advantage on hit in UI / sheets — not a separate “hit reaction length” developer table | NOT FOUND (official hit-reaction duration table) | — |
| Stagger style stumble timings | Style attacks with defensive properties; Ab-Science author planned retests — no stable published frame table found in this pass | NOT FOUND (complete Stagger frame sheet in-pass) | Reddit Ab-Science 1.24 post (pipeline only) |

### 4. Sloclap’s own words (animation / chaining)

| Finding | Number or rule | Label | Source |
|---|---|---|---|
| Combat as dance / stance→stance authoring | Four stances = orientation to enemy; every attack starts and ends in a stance; Combat Deck = player choreography; alts break sequence into another stance | DOCUMENTED | GamingBolt interview, 9 Aug 2017 — https://gamingbolt.com/absolver-interview-dancing-with-combat |
| UE4: customized animation system | Studio customized engine needs “from the online architecture to the animation system”; Blueprint for designers/artists | DOCUMENTED | Unreal Engine interview Crafting A Unique Combat Experience in Absolver (Pierre Tarno) — https://www.unrealengine.com/developer-interviews/crafting-a-unique-combat-experience-in-absolver |
| Hand animation, not mocap (Absolver) | Tarno: could not afford mocap; did not work directly with hired martial artists; two main animators were martial artists and hip-hop dancers; “combat is a dance” | DOCUMENTED | Eurogamer, Edwin Evans-Thirlwell, updated 11 May 2020 — https://www.eurogamer.net/the-quest-for-the-ultimate-videogame-martial-art |
| Organic joins (design goal) | Moves carry organically into the next; readable silhouettes; contrast with games that “blink” between states | DOCUMENTED (dev quoted in feature) / SECONDARY (writer observation) | Same Eurogamer feature |
| Published blend / transition milliseconds | No GDC/Unreal Fest paper found in this pass that publishes Absolver punch→punch blend ms or authoring frame budgets | NOT FOUND | Searched Unreal interviews, GamingBolt, Eurogamer, community; no numbered blend table |
| Balance method (context) | Pre-launch: Excel formulas + internal tournaments + beta tracking of winning decks — not animation timings | DOCUMENTED | Eurogamer (Layani / Tarno quotes) |

### 5. Offline mode

| Finding | Number or rule | Label | Source |
|---|---|---|---|
| Offline play exists | Official FAQ: players can play offline / limit others joining; story completable offline; online still recommended | DOCUMENTED | Absolver Official FAQ (br33dlove / Sloclap–Devolver), 16 Aug 2017 — https://steamcommunity.com/app/473690/discussions/0/2579854400733819593 |
| How to enable | Options → Offline Mode: Yes (disconnects from servers); also when Steam itself is offline | SECONDARY (players) | r/absolver “Can I play this without internet?” — https://www.reddit.com/r/absolver/comments/93o6ke/can_i_play_this_without_internet/ ; Steam discussion “Singleplayer / Offline…” — https://steamcommunity.com/app/473690/discussions/0/1636417554415560655/ |
| Solo capture-relevant content | Open-world AI, story path, practice/meditation, Downfall solo possible; PvP / schools / some rematches / CT-locked store need online | SECONDARY + DOCUMENTED mix | Official FAQ + Steam player clarifications |
| Play with no platform account at all | Steam/PS ownership and client launch still assumed; FAQ does not claim a cracked/accountless build. No “no Steam account” offline SKU found | NOT FOUND (accountless) / DOCUMENTED (offline mode yes) | Official FAQ |

#### GAPS
No official Sloclap spreadsheet of startup / active / recovery for every move.

Active-frame lengths rarely listed separately from startup + advantage.

Goldlink window / “perfect +4f” remains community-measured and partly disputed.

Windfall / Kahlt / Stagger lack a single DOCUMENTED frame sheet matching Forsaken’s 3+5 community numbers.

No published animation blend ms or Unreal Montage timings from Sloclap for Absolver joins.

balistafreak / Ab-Science sheet is the practical full table — verify patch version against the operator’s build before treating numbers as capture ground truth.

#### Capture priorities (offline play)

Three timings a screen capture can check most reliably against the published numbers above:

Deck-editor startup vs first contact — Pick a few named moves (e.g. Spiral Palm 24f, Hook 12f, a ~9–10f jab). Film at known fps, count frames from input to hitbox contact, convert with the 30f UI clock. This is the cleanest agree/disagree with the game’s own detail view.

Goldlinked vs non-goldlinked chain gap — Same two-move bridge, once with stamina-bar goldlink and once deliberately late. Measure recovery remaining between hit and next startup; community expects roughly a ~4f @ 30 recovery cancel if goldlink lands.

Style-ability or guard-break stun length — Forsaken parry confirm window (community: ~15f buffered punish) or stamina-break open (~45f @ 30). Both are long, high-contrast freezes that survive camera noise better than sub-frame blend joins.

Those three give an independent ruler for Absolver’s published combat clock before you trust capture timings on the harder problem: how long a join looks versus how long the next clip’s startup actually is.

