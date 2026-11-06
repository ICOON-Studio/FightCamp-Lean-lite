# FightCamp game bible (v2, S388, 2026-11-06)

Written by Claude as designer, at the operator's request: "how can we get you to know how to fully design and deliver the game".
This page decides what the game is. A new idea is tested against it. Change it on purpose, never by drift.
v1 scored 5/10 from an independent producer critic; his findings are in ops/research/CRITIC_BIBLE_S388.md and are worked in here.

## 1. The game in one line
You run a small boxing gym. You plan every week and design every fight plan, then watch the fight prove you right or wrong.

## 2. Who it is for
PC players of deep management games (Football Manager, Motorsport Manager, Out of the Park Baseball) who also like combat sports.
Not mobile, not casual: no timers, gacha, daily rewards or ads.
**Open problem:** that audience expects long careers and depth. Our content ends at first pro fights with a small roster. See section 8.

## 3. Market, honestly
Rough third-party estimates: World Championship Boxing Manager 2 about 2,700 copies, Boxing Club Manager about 2,760, both Mixed. Punch
Club has about 12,000 reviews at 81%, but is a different kind of game. Others in our survey (ops/research/G62_COMPETITOR_SURVEY.md, from
September) include The Fight Business, Promoter, MMA Sim King and Believr. So the space is not empty, and the proven audience is small.
A 3D pitch alone did not save Boxing Club Manager: an opaque system did not earn trust. The survey's lesson is ours: **show why a fight
went the way it did.**

## 4. The hook and whether it is true yet
**The hook:** your plan visibly decides the fight.
**Today it is half true.** Checked in scripts/state/LiveRound.gd: the plan does add to each exchange before the dice. But the critic
measured a small edge against big dice, the plan's effect on screen is mostly a caption, ring position is not staged, the verdict often
reads "too early" in a short bout, and hints give the answer away. It influences; it does not decide. **Making this true is the first
design job, ahead of any art.** Until strangers feel it, the game has no proven reason to exist.

## 5. The four pillars (goals, not claims about today)
1. **The plan is the star.** Designed by the player, and shown working or failing.
2. **Every week costs something.** Training, weight, fatigue and money pull against each other.
3. **Fighters are people.** Traits, habits, ambitions and history differ and change how each one responds.
4. **Fast and honest.** Anything is one click from anywhere; numbers are true; every choice changes something.
Known breaks today: the camp bonus counts twice in Sim.daily_gain; the ambition on the signing card does nothing.

## 6. How an idea is judged
In order; a "no" stops it. 1. Does it serve a pillar? 2. Does it improve the hook or the first three hours? 3. Can we finish it to the
bar with what we have? 4. Does it remove more confusion than it adds? Verdict is yes, later or no, with the reason.

## 7. Who decides
- **Claude owns:** design, structure, balance, code, order of work.
- **The operator owns:** scope, money, taste vetoes, anything he marks "decision". His "this is boring" or "I don't get it" outranks any score.
- **Outside judges own what Claude cannot see:** blind critics for clarity and looks, real strangers for fun, wishlists for demand.
- His ideas are input, not orders. Agreement is not the job. Nothing reaches him unjudged: critics first.

## 8. Scope for the first release
**In:** boxing; one gym; a small roster; training week; Playbook; offers, camp, weigh-in, fight night; money and rankings; interview and
signing with a career goal; Records; save and load; settings.
**Out (later or never):** 3D gym floor, MMA, multiplayer, facility building, more gyms, mobile, the gi.
**To settle in the structure design:** how far a career runs. Ending at first pro fights is probably too short for this audience.

## 9. Structure comes first
Operator: "the problem is not art , i think the preoblem is structure". Evidence agrees: critic S386 gave menu structure 4/10, "FM-sized
menus over Punch-Club content"; today 6 areas with 25 tabs plus 8 fighter tabs for one or two fighters; Training in 2 places, Camp in 4,
Goals in 3, Money in 4; stubs such as Gym > Floor. Screens were added one at a time and nobody designed the player's path.
**Order:** design the player's week and one home for each job on paper; build it as plain screens; test on strangers; choose the skin last.
Fixed points: one-click reach stays (FM26 is the warning); empty stubs go; training, camp and goals live with the fighter.

**Signing is an interview** (in): find a fighter, interview, agree a career goal and a focus, sign. The goal must be real.

## 10. Look and sound, after structure
Blind art critic S388, 8 being shippable: pinned-board office 6, Gemini's dashboard 5, desk 4, today's Home 4, tile grid 3. None passes.
Only the office has any identity. So office against dashboard stays open until structure is done; v1's "no office" is withdrawn.
Target is a polished indie, not AAA. Wireframes are labelled as wireframes. Sound is part of the look.

## 11. Quality bars
- Hook: strangers can say why they won or lost a fight, unprompted.
- First hour: critic 8/10; 4 of 5 strangers reach their first fight without help.
- Screens: blind critic 8/10 beside a reference game.
- Fun: 3 of 5 strangers choose to keep playing past the time asked.
- Fight motion: see decision 2 below.
Tests prove code works. They never prove a bar is met.

## 12. Decisions needed from the operator
1. **BJJ.** Recommendation: out of the first release, a free update later. It doubles the work while boxing's core is unproven. His S353
   decision was to ship it, so this is his call.
2. **Fight motion bar.** His S386 rule: every critic 8/10. But critics gave Undisputed itself 7, so that bar means beating a big studio.
   Recommendation: "nothing visibly broken", judged by strangers.
3. **Stranger test now.** Recommendation: 5 strangers play the current build before more is built. Only he can find them.
4. **Art director.** Recommendation: yes, but after structure, not before.
