# TASK G154 - THE OFFER DESK: every offer the career makes reaches the player as a decision (UI + wiring, Grok CLI)
Owner: Grok (Grok Build CLI). Worktree D:/FightCamp/wt/G154, branch grok/g154-offer-desk (from master).
Operator 2026-10-01, verbatim: "wire everything with all the agents ... prioritize game loop to be fun and addictive ...
everything needs to have a meaning and reward the player for progressing and try to get the feeling of just one more turn".
S137_LOOP_PLAN.md rows L2 + L4; S137_WIRING_AUDIT.md section B (44 GameState actions with no button).

## Why
GameState builds offers the player never sees or can never answer - no shipped script calls these (S137 census):
get_short_notice_offers (~11159) + accept_short_notice (~11207) + pass_short_notice (~11229);
get_promotion_bouts (~8657) + accept_promotion_bout (~8689) + decline_promotion_bout (~8706);
get_signing_offers (~8082) + accept_signing_offer (~8133); accept_contender_series_invite (~8274);
get_retention_offers (~8986) / accept_renewal / decline_retention_offer; get_sponsorship_offers (~376) (accept is wired in
OfficeHubPanel ~1555); estimate_win_chance (never called). GameState.gd is 17,655 lines - `sed -n` windows only.
D66_STRICT_REVIEW.md #6: "Fight offers have no difficulty indicator ... Accepting fights is blind".

## Prior research
`python Tools/prior_research.py offers booking short notice promotion signing contender`; D66_STRICT_REVIEW.md;
Godot/scripts/ScheduleHubPanel.gd (2,642 lines; the OFFERS desk ~852-1000, `_offer_rows`, `_build_cards`, `_build_book_bar`);
tests/schedule_hub_panel_test.gd, gf1_offers_camp_tips_test.gd (how the desk is tested); DesignLibrary/GLOSSARY.md
(icon with tooltip). Read `get_fight_offers()` first: grudge matches, superfights and Grand Prix ALREADY append into it.

## What would a human do?
Football Manager's inbox + Motorsport Manager's sponsor deals: every offer is a card with WHO, WHAT IT PAYS, WHAT IT
RISKS, a deadline, and two buttons. Short notice is urgent (red deadline). A signing / contender invite is a career
moment (gold). Each fight card shows the matchup: records, ranking gap, projected win % (estimate_win_chance), purse vs
fame. Deciding is one click; the result line says what changed.

## Owned files
- `Godot/scripts/ScheduleHubPanel.gd`: a section per missing offer kind in the OFFERS desk, using the SAME card style the
  desk already draws; buttons call the existing GameState actions; a projected win % + one-line matchup on every fight
  card (L4). Name every edited line range in the digest.
- `Godot/scripts/GameState.gd`: ONLY if a getter needs a thin read for the screen (no rule changes).
- `Godot/scripts/FighterCard*`/profile: retention/renewal offers on the fighter's card ONLY if the desk cannot host them
  (say which in the digest).
- NEW `Godot/tests/offer_desk_test.gd`: for EACH offer kind, a career state where the offer exists -> the desk shows it ->
  pressing accept calls the real GameState action and the booking/signing is recorded; decline/pass removes it. Two
  fighters in any fixture DIFFER.
- Stills (hidden windowed, `Tools\godot_hidden.ps1`) of the desk with each kind visible -> `previews/g154/`.
  OPEN THEM. NEW `research/G154_DIGEST.md`: census table (kind | getter | was reachable? | now: where + button).

## Tests
Parse gate (`python Godot/tools/check_scripts.py <touched .gd>`), the new test, then
`python Godot/tools/run_tests.py --jobs 2 --only offer,schedule_hub,booking,short_notice,promotion,signing,contender,retention,gf1`.
Watchdog first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## Art direction (operator, binding)
"another art direction is use icons when its possible to skip text (with the necessary toolltip of course)" (2026-10-01;
first given 2026-09-30). Use DesignLibrary/GLOSSARY.md "Icon with tooltip": purse, fame, ranking gap, win %, deadline,
risk are an ICON + value with a framed tooltip (title, total, breakdown), never a text label; text only where no icon can
carry the meaning. Icons come from the repo's icon set (`DesignLibrary/icons`, the UIKit icon helper) - grep for how
existing screens place one before adding any.

## The one trap
Full-rect-anchored Controls: never assign `size` on mount; `remove_child` before `queue_free` on rebuilds. A Variant
return must be typed (`var d: Dictionary = ...`). Do not change any offer RULE - this task wires and presents.

## Finish
git add by explicit path, commit, git push -u origin grok/g154-offer-desk. Do not stop at "written".
