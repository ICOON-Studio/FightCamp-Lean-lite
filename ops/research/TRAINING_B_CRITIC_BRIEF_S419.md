# Critic brief: the Training tab, approach B (S419)

The operator: "i want the screen reveiewed by critics and you and decide what should be displayed and how".

## Read first, in this order
1. `ops/research/CRITIC_PACK.md` (the whole game) and `ops/research/CRITIC_ACCESS.md` (where the real screens and mockups are). Sections 4.1 and 4.2 of the pack are this tab's mechanics; read the rest so you know what the other screens already show and what the fight later uses.
2. The screen under review: `docs/mockups/s419/training_b.png` (layout, real words and numbers) and `docs/mockups/s419/training_b_painted_ludo.png` (the same screen painted in the game's look; its small words are garbled by the painter, ignore that).
3. For contrast only, two other approaches drawn the same day: `docs/mockups/s419/training_a.png`, `docs/mockups/s419/training_c.png`. Take a part from them if it does a job better.

Do NOT read scripts/ or any still of the page that exists in the game today, and do not read the other critics' files.

## What the operator has said about this tab
"your fonts are small"; a row of seven small fatigue bars "needs to be displayed difrfentely"; "toomuch text cut uncessary"; panels must not look like a spreadsheet; show only what the player can do something about; he liked approach B.

## Your review, in this order
1. THE LOOK FIRST, with hard fails. Score the picture as a game screen (0 to 10) before anything else. Hard fails cap the score at 4: any type under 20 px, a block of text, a table of label and value rows, an element whose meaning needs a manual, emoji standing in for game art in the final (say which icons need painting).
2. WHAT IS DISPLAYED. Go element by element (day tile, intensity pips, drill dots, the tiredness curve and its 80 line, the peak number, the intensity lever with its two numbers per step, the session row, the goal bar, the evening type tiles, the minute split bar, each drill card's parts, the hand of drills, the coach bar, the diet buttons and weight, Start week). For each: KEEP, CHANGE (how), or CUT, and what the player can do about it.
3. WHAT IS MISSING. Which decisions or consequences from the pack does this screen not let the player make or see (examples to check, not a list to agree with: injury risk and training load spikes, weight and the cut, the coach's quality and areas, the camp phase and days to the fight, a second boxer sharing pad nights, which stat a session trains, what the opponent is weak to, the week's cost in money, mastery fading when undrilled)? For each: does it belong on THIS screen, as a picture, or on another screen? Name the picture.
4. WHAT IS USELESS. Anything shown that changes no decision.
5. THE FLOW. The three or four clicks of a normal week, and the clicks of an unusual week (fight week; an injury; two boxers). Where does the player get stuck?
6. Scores 0 to 10: look, clarity in five seconds, depth of the decision, fun of the planning itself.
7. HOW TO REACH 10/10: the concrete list of changes, most important first, each specific enough to build.
8. DRAW YOUR 10/10: one 1920x1080 HTML page at the path given in your prompt, self-contained CSS, slate and wood look (pieces in `assets/ui/wood/*.png`, reference `docs/mockups/s416/overview_painted_ludo.png`), nothing under 20 px, at most 70 words not counting session and move names and numbers. Render it with `python tools/render_mockup.py <your html>` run from the repo root, open the PNG with your file tool, fix what is cut or overlapping, render again.

## Rules
Never "he" or "she" for a boxer: the name or "the boxer". Nothing opens on a monitor: file tools only. Write only your own two files in `docs/mockups/s419/`. Your lens (in your prompt) decides what you weigh most; say plainly where you disagree with the screen.

## Hand back
Your scores, the keep / change / cut table, the missing and useless lists, the 10/10 list, and the PNG path of your drawing.
