# MENUDIR S388: how should FightCamp's management screens be presented? (code seats)

You have the whole repo. Read the real code before answering. This is a READ-ONLY design review: change NO game code, tests or tools.
Write only the two files named at the end. Do not read any other MENUDIR_*_S388 answer.

CONTEXT: a PC boxing gym management game in Godot 4.7.2, tiny budget. Almost all play time is in 2D screens, not the 3D fight.
The owner has 40 years of playing games and will choose the direction from your work on a board.

READ FIRST: CLAUDE.md, scripts/ui/Main.gd, scripts/ui/Shell.gd, scripts/ui/UI.gd (colours, fonts), scripts/ui/areas/Home.gd,
scripts/ui/HomeBoard.gd, scripts/ui/FighterTile.gd, scripts/ui/RosterSummary.gd, scripts/state/Needs.gd, every file in
scripts/ui/areas/, docs/menu_prototype.html.

OWNER'S RECENT NOTES: too little information on fighters; RPG elements should show more often; each playthrough should feel unique;
Home should be a dashboard with shortcuts and key information such as fighter and coach cards.

THE CHOICE:
A. Keep the menus and improve them: same structure, richer cards, more information, a better dashboard Home.
B. Desk Home: Home becomes a simple stylized 2D top-down office desk. Objects are live shortcuts (folder = finance with cash shown,
   computer = mail, rankings, scouting; phone = bout offers ringing; fighter and coach cards on the desk). Other screens stay menus.
C. Interactive office everywhere: most screens become illustrated places or objects (desk, filing cabinet, whiteboard, window on the
   gym floor), with transitions between them instead of a menu.
D. Your own direction, if you think all three are wrong.

FILE 1, ops/research/MENUDIR_<SEAT>_S388.md, under 400 words, plain words:
1. Your pick and the one main reason.
2. Its biggest risk.
3. From the real code: which files change for A, B and C, and a rough size for each (small, medium, large), naming what already
   helps or blocks each one (for example how routes, act() and Needs work).
4. Which game data exists today but is not shown on any screen, that would make screens richer or playthroughs more unique.
5. One idea nobody listed that would make these screens more fun or interactive.
6. Score A, B and C from 1 to 10 for a solo tiny-budget team.

FILE 2, ops/research/MENUDIR_<SEAT>_S388.html: ONE self-contained static page, exactly 1920x1080, no scripts, no external files, that
previews your pick's Home screen. Use the game's real colours from UI.gd, and the real names and numbers (Lucy Jackson 3-1, Reid the
coach, $14,600). Plain CSS shapes only. Your own design: no other game's look.

<SEAT> is your seat name in capitals, given below.
