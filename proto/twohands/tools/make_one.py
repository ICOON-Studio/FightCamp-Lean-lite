"""make_one.py - one.html: the boxing page (order.html) with ONE HAND ACTION a beat (ONEACT1, S568).

Owner S568: "i am think to make a version where 1 action per player instead of 3 (increase beats) to see if it s faster
and feels better". Measured in docs/ONEACT1_RESULT.md: V1 (one action of any kind a beat) collapses to both men trading
jabs at Long; this page is V2 - one hand acts a beat, the feet move first and are free of the action, 12 beats a round.

    python proto/twohands/tools/make_one.py [ops/research/s558_balance/oneact_v2.json]

The RULES are the measured tweak file, applied text for text. The PAGE part is patched here: one hand in the plan, the
help box, the strip with two places a side (feet, hand) and no numbers, no "moment" in the story.
Every anchor must be found exactly once: an edit to order.html that moves one stops the build with its text.
order.html is never written. Run again after order.html changes.
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"
OUT = HERE.parent / "one.html"
TWEAK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "ops/research/s558_balance/oneact_v2.json"

HOW_FROM = "<b>A beat is three moments.</b>"
HOW_TO = "Feet take a moment too: step in and then hook, or jab and then back off."

# (text on the page, its replacement, what it is)
PAGE = [
    ("[ordOf(p).map((sl, i) => `${i + 1} ${actName(p, sl)}`).join(', ') || 'no action',",
     "[ordOf(p).map((sl) => actName(p, sl)).join(', then ') || 'no action',",
     "a plan in words: no numbers, the step then the hand"),
    ("<title>Puncher's chance</title>",
     "<title>Puncher's chance - one hand a beat</title>",
     "title"),
    ("<span id=\"where\"></span>",
     "<span class=\"lab\" title=\"A trial page (ONEACT1): one hand acts a beat, your feet move first, 12 beats a round. The main page is order.html.\">trial: one hand a beat</span><span id=\"where\"></span>",
     "the trial tag"),
    ("title=\"The order you click is the order you throw. Drag a card in the strip under the ring to change it.\"",
     "title=\"One hand acts a beat: a punch, a feint or a push off. Your feet move first, then your hand. Nothing to order.\"",
     "the top hint"),
    ("</head>",
     "<style>#strip>div.slot:nth-of-type(3),#strip .hisrow .hslot:nth-of-type(3){display:none!important}#strip .slot .no,#strip .hslot .no{display:none!important}#strip .slot{padding-left:.55rem!important}#strip .hslot{padding-right:.55rem!important}</style></head>",
     "the strip: two places a side (feet, hand), no numbers"),
    ("function plan() { phase = 'plan'; draw();",
     "let oneWas = { lead: null, rear: null };   /* ONEACT1 (S568): one hand acts a beat - the hand chosen last stays, the other goes home */\nfunction oneFix() { if (!P.clinch && P.lead && P.rear) { if (P.rear !== oneWas.rear) P.lead = null; else P.rear = null; } P.ord = ordOf(P); oneWas = { lead: P.lead, rear: P.rear }; }\nfunction plan() { phase = 'plan'; oneFix(); draw();",
     "one hand in the plan"),
    ("<span class=\"lab\">Your order - drag to change</span>",
     "<span class=\"lab\">This beat: feet first, then your hand</span>",
     "the order label"),
    ("'Hold it high' : 'Hold it low', '+1 stamina',",
     "'Hold it high' : 'Hold it low', 'free',",
     "a held hand gives no stamina here"),
    ("1 comes back each beat, and 1 more for each hand you hold instead of punching.\\nA body hook",
     "1 comes back each beat.\\nA body hook",
     "the stamina gauge words"),
    ("1 stamina comes back each beat, and 1 more for each hand you hold.'",
     "1 stamina comes back each beat.'",
     "the switched-off words"),
    ("${e.m != null ? `<span style=\"color:var(--gold)\">${e.m + 1}</span> ` : ''}${cardLinks(label, e.k)}",
     "${cardLinks(label, e.k)}",
     "no moment number in the story"),
    ("cp.textContent = (e.m != null ? `Moment ${e.m + 1}: ` : '') + label",
     "cp.textContent = label",
     "no moment number in the caption"),
    ("L.push('Feet take a moment of the beat, like a punch.');",
     "L.push('Feet move first in the beat, before the hands.');",
     "rule words: feet"),
    ("L.push(\"After a blocked punch the other man's later punches this beat are counters (+1 health).\"); }",
     "L.push(\"After a blocked punch the other man's punch NEXT beat is a counter (+1 health).\"); }",
     "rule words: block"),
    ("L.push(\"After a miss the other man's later punches this beat are counters (+1 health).\"); }",
     "L.push(\"After a miss the other man's punch NEXT beat is a counter (+1 health).\"); }",
     "rule words: miss"),
    ("L.push('A feint draws his hands: the punch in the next moment cannot be blocked.');",
     "L.push('A feint draws his hands: the punch in the next beat cannot be blocked.');",
     "rule words: feint hit"),
    ("L.push('Counter: his punch missed or was blocked earlier this beat, so this one does +1 health.');",
     "L.push('Counter: his punch missed or was blocked last beat, so this one does +1 health.');",
     "rule words: counter"),
    ("L.push('A feint draws his hands: your punch in the NEXT moment cannot be blocked. 1 stamina, no damage.');",
     "L.push('A feint draws his hands: your punch in the NEXT BEAT cannot be blocked. 1 stamina, no damage. He sees it.');",
     "rule words: feint"),
    ("<b>Each hand</b> throws one punch a beat, or stays home.",
     "<b>One hand acts a beat</b>: a punch, a feint or a push off. Or both hands stay home.",
     "how: one hand"),
    ("A punch of his that misses or is blocked makes your later punches counters (+1).",
     "A punch of his that misses or is blocked makes your punch NEXT beat a counter (+1). <b>A feint</b> makes your punch next beat impossible to block - and he sees the feint.",
     "how: counters"),
    ("<b>Stamina:</b> 1 comes back each beat, and 1 more for each hand you held instead of punching.",
     "<b>Stamina:</b> 1 comes back each beat. The clinch gives 2.",
     "how: stamina"),
    ("setup();\nif (/peek=/",
     "window.addEventListener('DOMContentLoaded', () => { const sideFix = [[/Each hand does ONE thing a beat, and so do the feet: up to three moves\\. Click another row below to add a move; click a row again to change it\\. Drag the cards under the ring to change their order\\./, 'One hand acts a beat; your feet may move first. Click a row below to change it. Choosing the other hand sends this one home.'], [/Each hand does ONE thing a beat\\. Mouse over/, 'ONE hand acts a beat, and your feet may move first. Mouse over'], [/ - (1st|2nd|3rd)$/, ''], [/ no step: it takes no moment/, ' no step'], [/The cards under the ring play left to right, against his, moment by moment\\./, 'Your feet move first, then your hand, against his.']], side = document.getElementById('side');\n  const fixSide = () => { const w = document.createTreeWalker(side, NodeFilter.SHOW_TEXT); for (let n = w.nextNode(); n; n = w.nextNode()) { let t = n.nodeValue; for (const [a, b] of sideFix) t = t.replace(a, b); if (t !== n.nodeValue) n.nodeValue = t; } };   /* body_ui.js is shared with the main page: its words about three moves and their order are put right here */\n  new MutationObserver(fixSide).observe(side, { childList: true, subtree: true, characterData: true }); fixSide();\n  const board9 = board; board = function () { board9(); for (const c of document.querySelectorAll('#strip .slot.full')) c.dataset.tip = 'Your beat: your feet move first, then your one hand. Nothing to order.'; const h = document.querySelector('#strip .hisrow'); if (h && h.dataset.tip) h.dataset.tip = 'His beat: feet, then one hand. Hidden until the beat is fought: what you see here is what he did LAST beat.'; }; if (phase === 'plan') plan(); });   /* ONEACT1: the strip's hover words (strip_ui.js is shared with the main page) */\nsetup();\nif (/peek=/",
     "the strip's hover words"),
]
HOW_NEW = "<b>A beat is one exchange.</b> Both men's feet move first, then both men's hands go at the same time. <b>The hand that punches is out of its guard</b>: its line is open while it punches. The other hand stays home, high or low, and blocks. Step in and hook, or back off and jab, in one beat: the step always comes first."


def main() -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read().replace("\r\n", "\n")   # S570: the checkout may hand order.html over as CRLF
    tw = json.load(io.open(TWEAK, encoding="utf-8"))

    def rep(a: str, b: str, what: str) -> None:
        nonlocal s
        if s.count(a) != 1:
            sys.exit(f"MAKE_ONE FAIL {what}: anchor found {s.count(a)} times: {a[:90]!r}")
        s = s.replace(a, b)

    # ---- the rules: the tweak file as measured
    for i, (a, b) in enumerate(tw["src"]):
        rep(a, b, f"tweak src {i}")

    # ---- the page
    for a, b, what in PAGE:
        rep(a, b, what)
    if s.count(HOW_FROM) != 1 or s.count(HOW_TO) != 1:
        sys.exit("MAKE_ONE FAIL how: the three-moments paragraph of the help box moved")
    i, j = s.index(HOW_FROM), s.index(HOW_TO) + len(HOW_TO)
    s = s[:i] + HOW_NEW + s[j:]
    # the opponent's look-ahead: this page's own table (12 beats, one hand a beat), built with
    # balance.mjs table tweak=<the tweak> out=proto/twohands/vtable_one.json
    own = (HERE.parent / "vtable_one.json").exists()
    if own:
        rep("fetch('vtable.json')", "fetch('vtable_one.json')", "its own look-ahead table")
    io.open(OUT, "w", encoding="utf-8", newline="").write(s)
    print("MAKE_ONE look-ahead table: " + ("vtable_one.json (its own)" if own else "NONE OF ITS OWN: build vtable_one.json, the main page's table is for 6 beats of three moments"))
    print(f"MAKE_ONE wrote {OUT.name} from {SRC.name} + {TWEAK.name} ({len(tw['src'])} rule edits, {len(PAGE) + 1} page edits)")


if __name__ == "__main__":
    main()
