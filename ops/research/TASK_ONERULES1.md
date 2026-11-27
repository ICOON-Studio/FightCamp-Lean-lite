# TASK ONERULES1 - one rules core for every page; then the winners stacked and measured together (S569)

Kind: refactor + measure. Model: Opus 5.5 console worker (PC) or Claude in session. Discipline: Puncher's chance.
Owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the current changes ?"

## The defect (found S569)
order.html holds the rules. punch.html, wait.html, one.html, mmc.html are BUILT from it (make_*.py + a tweak file), so a
rule fix there reaches them on the next build. kick.html and head.html are HAND-KEPT COPIES: they do not have the
v0.568.12 feint fix (grep "guards nothing before its feint": order 1, punch 1, wait 1, mmc 1, kick 0, head 0, one 0 -
one.html was built before the fix). KICKFIX5 therefore measures kicks on yesterday's rules.

## Do
1. make_kick.py and make_head.py like make_punch.py: kick.html = order.html + a kicks tweak (the kick rules as `src`
   pairs, taken from today's kick.html by diffing it against the order.html it was copied from - find that commit), and
   the same for head.html. Rebuild one.html. After this, `grep` shows the feint fix on every page.
2. page_play_test on every rebuilt page; kick_test.mjs; head_test.mjs; anim_check.mjs; a full-size still of each page.
3. Re-run KICKFIX5's winning version (or its best, if none won) on the rebuilt kick.html: the nine bars on both seeds.
4. INTEGRATION: the measured winners of COUNTERS2 (H3b: 8 and 8 of 9), RULES569 (whichever hold) and KICKFIX5, added
   ONE AT A TIME to the main page's rules in the order they landed, the nine bars + the feint loop measured after each.
   A pair that clashes (bars drop below either alone) goes to the owner as one short question with the trade-off.
5. docs/ONERULES1_RESULT.md; one version.js line per page change; last line `ONERULES1 DONE` or `ONERULES1 BLOCKED: <why>`.

## Feedback loops
None in step 1-2 (a refactor: every page must play exactly as before except the feint fix now on kick/head). Step 4:
the interactions ARE the measure - each addition is measured alone first (done by its worker), then stacked.

## Contract
- OWNS: proto/twohands/tools/make_kick.py, proto/twohands/tools/make_head.py, ops/research/s558_balance/kick_page.json,
  ops/research/s558_balance/head_page.json, proto/twohands/kick.html, proto/twohands/head.html, proto/twohands/one.html,
  proto/twohands/version.js (one line a change), docs/ONERULES1_RESULT.md
- RED_TEST: grep "guards nothing before its feint" proto/twohands/kick.html -> 0 (should be 1)
- REGRESSION: page_play_test.mjs on every page, kick_test.mjs, head_test.mjs, rules_test.mjs, anim_check.mjs
- VISUAL: a full-size still of kick.html and head.html after the rebuild
