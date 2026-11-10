# Critic brief: "a week worth playing" - the joined design v2 and its two screens (S425)

You review a design BEFORE it is built. The owner is the playtester: 40 years of games, a boxing and BJJ background, no
patience for a decision that is not one.

## The owner's words (verbatim)
- "the focus needs to be for the player to have things to do during a week make him anticipate the changes and be more
  interactive with deicions/choices and rewarding for keep playing and progressing"
- "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10".
  Score honestly: a 7 from you means you would defend it to him. Do not round up.
- On a mechanic a critic had scored 10: "need to improve the depth of the mechanic, , rated 4/10". Depth to him is
  decisions that lead into each other across the week, the camp, the fight and the career, each option with a case where
  it is the right one.
- On screens: "do not write desciptions and useless text ... make the play understand what you want by using icons
  graphics,meters,toolitps,animations and whatever aaa titles do , why you do not use the owrd pending instead of all htat
  crap ?" A sentence or a description on a screen is a hard fail (look capped at 3): a word, an icon, a number, a meter,
  a clock; explanations in tooltips. Your own drawing obeys this.

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game as it is today) and `ops/research/CRITIC_ACCESS.md`.
2. The design under review: `ops/research/WEEK_DESIGN_V2_S425.md`. Its plan-reading part is written twice: SMALL (what
   stands on today's measurements) and FULL (conditional on a measurement still running). Score the design with the
   SMALL one, and say separately what the FULL one would add. Rows marked INVENTED are not measured; its own list
   says which measurements could kill it.
3. The screens under review: `docs/mockups/s425/week_v2.png` (Home on a Monday) and
   `docs/mockups/s425/week_v2_thursday.png` (the Thursday decision).
4. For the look: `docs/mockups/s419/training_b.png` and `docs/mockups/s416/overview_painted_ludo.png`.
Do NOT read scripts/, tests/, any other file in docs/mockups/s425, any file named WEEK_DEPTH_* or WEEK_DESIGN_V1*, or other
critics' files.
Open images with your file tool only; start no app, no Godot.

## Your review, in this order
1. PLAY TWO WEEKS IN YOUR HEAD, a camp week and a quiet week, as the design describes them. Day by day: what did you
   decide, what were you waiting for, what landed, what did you get? Mark every day with nothing to do and every decision
   you would hand to an auto-button from week 3 on.
2. IS EACH DECISION REAL? For every decision and option in the four mechanics: the case where it is right, or DEAD
   (never right / always right), or CHORE. Check the chain: does one week's choice truly show up in the next week, the
   fight and the career, or is the link only stated?
3. ANTICIPATION AND REWARD: what does the player look forward to on Thursday, next Monday, fight night, next season? Is
   the reward something that opens a new choice, or only a bigger number?
4. WHAT RESTS ON INVENTED NUMBERS: which invented rule, if it measured badly, would collapse the design, and what is left.
5. WIRED AND SHOWN: go through the menu table. Right place? Would the player find it? Anything shown he cannot act on?
6. THE TWO SCREENS, element by element: KEEP, CHANGE (how) or CUT. Hard fails cap the look at 4: type under 20 px, a block of
   text, a table of label and value rows, a label that needs a manual. Is it too much for one screen?
7. Scores 0 to 10: look, clarity in five seconds, depth, things to do in a week, anticipation, reward for playing on.
8. HOW TO REACH 10/10: the concrete list of changes, most important first, each specific enough to build.
9. DRAW YOUR 10/10: one 1920x1080 HTML page at the path given in your prompt, self-contained CSS in the slate and wood look
   of `docs/mockups/s425/week_v2.html` (you may copy its CSS; portraits in `assets/ui/face/`). Render with
   `python tools/render_mockup.py <your html>` (off screen), open the PNG with your file tool, fix overlaps, render again.
   No type under 24 px.

## What to deliver
- The review as markdown at the path given in your prompt (sections 1 to 8, under 130 lines).
- The drawing (html + png) at the path given.
- Your final message: the six scores, the three most important changes, the one invented rule the design most depends on,
  and your file paths. Nothing else.
