# S81 - COMPETITOR SURVEY: Punch Club 2: Fast Forward (Steam app 1161590; demo 2362100)
Claude, 2026-09-26. The operator installed the demo (Steam, E:\SteamLibrary). Sources: the Steam store page, Steam's
review API (4,589 reviews; the 100 newest positive and 42 negative English reviews read, ranked by helpful votes).
**Demo NOT played yet**: it is a Unity game with no debug port, so playing it means driving the operator's real mouse
and screen - asked, not done. Companion to `S81_CAGE_LEGACY_SURVEY.md` and `S81_FIGHT_BUSINESS_SURVEY.md`.

## What it is
- Lazy Bear Games / tinyBuild, released **20 Jul 2023**, $4.99 on sale (75% off). Sequel to Punch Club (2016).
  **Very Positive: 3,785 up / 804 down (82%).**
- Store line: "Mentor your fighter and guide him to become the ultimate champion: choose from different combat
  styles, control his routine, and watch him kick some butt like a proud sensei!"
- **You ARE the fighter** (one young man in a comic cyberpunk 1980s city), not a gym owner. The loop: manage his day
  (eat, sleep, mood, work a job for money), train stats, learn techniques from fighting schools, sign up for fights,
  climb the leagues. Pixel art, heavy on story, quests and pop-culture jokes.
- Fights: auto-resolved; the player sets the plan beforehand - style, moves in slots, "plan your match and create your
  own school of fighting". Tags: Time Management, Resource Management, Tactical RPG, Turn-Based Tactics, Life Sim.

## What players praise (helpful positive reviews)
- The art, animation and world; the soundtrack; the humour for those who like it.
- The fights "require tactical thinking" - picking moves and styles is the part they call a game.
- A faster, better sequel to the first; branching story; more moves and mechanics than the original.

## What players hate (helpful negative reviews)
- **The grind**: "eating, sleeping, entertainment, and exercising - a repetitive cycle"; "the start of the game is
  the same as the end"; "doing the same over and over for little progress".
- **Too much quirky dialogue** that breaks the pace; a two-hour dialogue ending.
- **No information on moves and skills** - "supposed to appeal to those that love min/maxxing... and then doesn't let
  you min max".
- **Bugs left unfixed for years** (a quest that never triggers, "almost 3 years").
- Tiny inventory forcing shop trips - friction that reads as padding.

## Read against FightCamp
- **Different seat, same promise.** They make you the fighter and the grind is the game; we make you the gym and the
  fighters are yours. Their negative reviews are a list of what our gym seat can avoid: we never make the player feed
  and water one man by hand.
- **The fight view is still the weak spot of the genre**: their fight is a pixel animation of an auto-resolved plan;
  Cage Legacy's is a text log; The Fight Business claims 3D and shows none. Ours is simulated bodies in 3D. The
  consistent praise across all three is for the tactical PLAN before and between rounds - our corner must make that
  plan readable, which is exactly their "no information on moves" complaint turned into a rule.
- **Say what a move does.** Their players asked for numbers on moves and skills and did not get them. Our technique
  tree and skill bands should always show what a thing does and by how much.
- **Pace**: dialogue is the top complaint after the grind. Our news, coach lines and events should stay short and
  skippable - matches the operator's standing "be concise" rule.

## DEMO PLAYED, PARTLY (2026-09-26 ~01:00, demo ver 0.104, Normal difficulty)
Operator: "I go sleep you can check it freely". Driven by screenshots + real mouse clicks (Tools: session-only
`desk.ps1`); master volume set to 0 first. **Stopped after the prologue and the city map because the PC reached
93 C** (the overlay's reading; the operator's PC has a known ~90 C limit, and the demo renders uncapped at 500-1,200 fps
even with its VSync option on). The fight system was NOT reached.

**What the hub is.** One hand-drawn, side-on pixel ROOM per place - the garage gym, the family house - with the
fighter walking to objects that ARE the actions: the rug (exercise), a weight bench, a kitchen robot ("Time for
breakfast?"), the door, a map button. A glowing "!" marks the next object during the tutorial. Stat icons pop over his
head when he trains. **This is option B of TASK_HUB_DISPLAY_EVAL (2.5D animated rooms) in a shipped, well-reviewed
game**: the room IS the menu. The city map is an isometric pixel city where each building is a destination.

**Onboarding.** A cutscene, then a long guided story prologue (father, mother, a robot), one marked object at a time.
It is slow - dozens of clicks of dialogue before any choice - which matches the reviews' "too much dialogue".

**For FightCamp.** Their hub proves B is loved when the ROOM is the interface and every object does something - and it
costs them a hand-painted room per location plus an animation per action. Our C (3D engine) option gets the same
"the room is the menu" effect from our own floor data and fighters (C208 measured 3 idling fighters at 5.8 ms/frame).
Either way the lesson is the same: **objects in the picture must be the buttons**, which is what our HOME pins are
already reaching for.

## Next
- **Finish the demo to the first fight** in a cooler run: switch it to windowed 1280x720 first (less GPU load), and
  stop at 88 C. The fight view is the part we most need to see.
