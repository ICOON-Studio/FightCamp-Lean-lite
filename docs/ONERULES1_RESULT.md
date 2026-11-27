# ONERULES1 - one rules core for every page (S570, Claude in session)

Owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the current changes ?"

## Step 1-2: every page built from order.html - DONE for head and one, READY for kick
| page | before | now | builder | tests |
|---|---|---|---|---|
| head.html | hand-kept copy (S559) | order.html + 16 head-move edits | make_head.py + s558_balance/head_page.json | head_test 11, page_play_test 4, anim_check 160/160 |
| one.html | built, but before the feint fix | rebuilt (oneact_v1/v2 feint anchor updated) | make_one.py | page_play_test 4 |
| kick.html | hand-kept copy (S559) | builder ready, NOT swapped: KICKFIX5's F5 runs read kick.html until its chain ends | make_kick.py + s558_balance/kick_page.json (28 edits) | on a side copy: kick_test 12, page_play_test 4; F3, F4, F5 tweaks all apply |

What the rebuilt pages gain from order.html (nothing else changed - the diff old -> new is only these):
- the v0.568.12 feint fix (a feinting lead hand guards nothing before its feint) - marker `leadAway` in resolve;
- the S560 pull counter (a back off arms the next punch that beat, +1);
- kick.html also STEPFIX1 (a step that cannot change the range has no picture).
How the pairs were found: kick.html / head.html were unchanged since 369173f03; diffed against order.html of that commit;
edits that only REMOVED order.html text (the copy was older than order.html) are drift and were not carried.

Also fixed on the way: make_one / make_punch / make_wait read order.html CRLF-safe (git's checkout hands it over CRLF;
make_one failed on a two-line anchor). The commentator called a slipped jab at Long "Too close ... smothered".

## Still to do
- Swap kick.html (`python proto/twohands/tools/make_kick.py`) when KICKFIX5's chain is done; then step 3: its winner (or
  best) re-measured on the rebuilt kick.html, both seeds.
- vtable_one.json was built on pre-feint-fix rules: rebuild it (`balance.mjs table tweak=oneact_v2.json`) when the PC
  has room.
- Step 4: stack the measured winners one at a time (COUNTERS2 has none - BLOCKED; RULES569 and kicks when they land).
