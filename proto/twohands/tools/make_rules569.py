"""make_rules569.py - rules.html: the boxing page (order.html) with the owner's three rule ideas of S569 (RULES569).

Owner S569: "a switch that sets the power that goes to your punches would be a good idea"; "the bars up there all health,
stamina, guard etc they all need to affect each other in a way . what if we may a guard 1 action like both hands up and
hands do not punch at the same time and move some things into the rules instead of having them as actions".
Measured in docs/RULES569_RESULT.md. A toy to click: the guard as one card failed its trial (5 of 9 bars v 6).

    python proto/twohands/tools/make_rules569.py [ops/research/s558_balance/rules569_r3.json]

The RULES are the measured tweak file, applied text for text (the first place each text is found, as tools/balance.mjs
applies a tweak). The PAGE part is patched here: no Low guard switches, the Guard up card with a picture, the FULL POWER
tag on a chosen punch card, the gauges' words and tags for each bar link. PAGE below is JSON: [text on the page, its
replacement, what it is]. Every page anchor must be found exactly once: an edit to order.html that moves one stops the
build with its text. order.html is never written. Run again after order.html changes.
"""
from __future__ import annotations

import io
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SRC = HERE.parent / "order.html"
OUT = HERE.parent / "rules.html"
TWEAK = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "ops/research/s558_balance/rules569_r3.json"

PAGE = json.loads(r'''[
 [
  "<title>Puncher's chance</title>",
  "<title>Puncher's chance - three rule ideas</title>",
  "title"
 ],
 [
  "<span id=\"where\"></span>",
  "<span class=\"lab\" title=\"A trial page (RULES569): the guard is one card, the last punch of a beat can be thrown at full power, and the bars affect each other. The main page is order.html.\">trial: 3 rule ideas</span><span id=\"where\"></span>",
  "the trial tag"
 ],
 [
  "</head>",
  "<style>.pwt{position:absolute;right:.12rem;top:1.15rem;z-index:3;font-size:.56rem;line-height:1.2;font-weight:700;letter-spacing:.03em;padding:.02rem .28rem;border-radius:.3rem;border:1px solid #c9a54a;color:#c9a54a;background:#000c;cursor:pointer}.pwt.on{background:#c9a54a;color:#15161b}.pwt.no{opacity:.4;cursor:not-allowed}#board .sw.pc>.pwt,#board .sw>.pwt{display:block!important}#board .sw{position:relative}</style></head>",
  "the full-power tag's look"
 ],
 [
  "['high', 'low'].map((g) => sw(slot, g, g === 'high' ? 'Hold it high' : 'Hold it low', '+1 stamina', `Blocks ${STOPS[COVER[g][h]]}`,",
  "['high'].map((g) => sw(slot, g, 'Stance guard', '+1 stamina', `A hand with no card is back in its stance guard by itself. Blocks ${STOPS[COVER[g][h]]}. The body and the uppercut line stay open: only Guard up covers them.`,",
  "no Low switch: the stance guard"
 ],
 [
  "Held, it stops what comes from the side (high) or from below (low).",
  "Home in its stance it stops what comes from the side: his lead hook and his overhand.",
  "rear hand words"
 ],
 [
  "Held, it stops straight punches (high) or body punches (low).",
  "Home in its stance it stops straight punches: his jab and his cross.",
  "lead hand words"
 ],
 [
  "function board() { const me = F[0], left = me.st - cost(P);",
  "function board() { if (P.pw && (P.pw !== lastPunch(P) || cost(P) > F[0].st)) P.pw = null; const me = F[0], left = me.st - cost(P);",
  "full power goes off with its punch"
 ],
 [
  "const actName = (p, sl) => (sl === 'feet' ? FEET[p.feet].n : ACT[p[sl]].n);",
  "const actName = (p, sl) => (sl === 'feet' ? FEET[p.feet].n : ACT[p[sl]].n + (p.pw === sl && ACT[p[sl]].d ? ' at full power' : ''));",
  "a plan in words says full power"
 ],
 [
  "${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}",
  "${m.g <= 0 ? '<span class=\"tag\">guard broken</span>' : ''}${[m.g > 0 && m.g <= N.lk3 ? 'soft guard' : '', m.st <= N.lk2 ? 'tired arms' : '', m.wide ? 'wide open' : ''].filter(Boolean).join(', ').replace(/^(.+)$/, '<span class=\"tag\">$1</span>')}",
  "the link tags on a man's card"
 ],
 [
  "At 0 a man goes down.`",
  "At 0 a man goes down.\\nLinked to stamina: every third of a man's health lost takes 1 off the top of his stamina bar${m.hc ? ` (it has taken ${m.hc})` : ''}.`",
  "health gauge words"
 ],
 [
  "(body shots took ${N.st - m.cap} off the top)",
  "(${[N.st - m.cap - (m.hct || 0) ? `body shots took ${N.st - m.cap - (m.hct || 0)} off the top` : '', m.hct ? `lost health took ${m.hct} off the top` : ''].filter(Boolean).join(', ')})",
  "stamina gauge: the cap"
 ],
 [
  "It never goes under ${N.capMin}.`",
  "It never goes under ${N.capMin}.\\nLow: a man who starts a beat on ${N.lk2} or less has tired arms - his punches of 2 or more do 1 less.\\nFull power on a punch costs 2 more.`",
  "stamina gauge words"
 ],
 [
  "A hand left off blocks. Every big punch it blocks wears the guard 1; a jab does not. 1 comes back each beat.`",
  "The stance blocks his jab, cross, lead hook and overhand, and each punch it blocks wears the guard: 1, a big punch 2. Guard up blocks everything and wears nothing. 1 comes back each beat.\\nLow: a man who starts a beat on ${N.lk3} or less has a soft guard - a big punch he blocks lets 1 through.\\nOn the ropes every punch he blocks takes 1 more guard.`",
  "guard gauge words"
 ],
 [
  "on the ropes and cannot back off. A step in wins it back.",
  "on the ropes and cannot back off, and every punch blocked there takes 1 more guard. A step in wins it back.",
  "ground words"
 ],
 [
  "<b>A hand that does not punch is held high or low, and blocks</b>: the lead hand high stops straight head punches, low stops body punches; the rear hand high stops hooks, low stops uppercuts.",
  "<b>A hand with no card is back in its stance guard by itself</b>: the lead glove stops his jab and cross, the rear glove stops his lead hook and overhand. A stance leaves the body and the uppercut line open. <b>Guard up is one card</b>: both gloves high, elbows in - everything is blocked from its moment until your next action, but a feint still draws it. <b>Full power</b>: the last punch of your beat can be thrown at full power (the tag on its card): 2 more stamina, 1 more health, a step slower - blocked or short, you are wide open in your next moment. <b>The bars are linked</b>: lost health shortens the stamina bar, low stamina weakens punches, a low guard lets big punches through, the ropes wear the guard.",
  "how: the three ideas"
 ],
 [
  " <b>A hand that punches is held HIGH in the other moments of the beat</b>: to guard low, that hand must stay home.",
  "",
  "how: no low guard"
 ],
 [
  "held = a ? `${LINE[a.line]} is stopped only by the ${slotOf(a.line)} hand held ${COVER.high.includes(a.line) ? 'high' : 'low'}` : '';",
  "held = a ? (COVER.high.includes(a.line) ? `${LINE[a.line]} is stopped by the ${slotOf(a.line)} hand in its stance guard, or by Guard up` : `${LINE[a.line]} is stopped only by Guard up: a stance leaves it open`) : '';",
  "rule words: what stops a line"
 ],
 [
  "if (a.d >= 3) L.push('A big punch that is blocked wears the guard by 1.');",
  "L.push(/Guard up/.test(o) ? 'Guard up blocks every line and wears no guard.' : `A punch blocked by the stance wears the guard by ${a.d >= 3 ? 2 : 1}.`); if (/gets through/.test(o)) L.push('A soft guard (2 or less at the start of the beat) lets 1 through from a big punch.'); if (/on the ropes/.test(o)) L.push('On the ropes every blocked punch takes 1 more guard.');",
  "rule words: a block"
 ],
 [
  "else if (/was held/.test(o)) L.push(held + '.');",
  "else if (/stance guard does not cover/.test(o)) L.push(held + '.'); if (/FULL POWER/.test(o)) L.push('Full power (the last punch of a beat): 2 more stamina, 1 more health, one step slower.'); if (/wide open/.test(o)) L.push('A full-power punch that is blocked or falls short leaves its thrower wide open in his next moment: nothing is covered.'); if (/tired arms/.test(o)) L.push('Tired arms: a man who starts a beat on 2 stamina or less does 1 less with his punches of 2 or more.'); if (/health lost/.test(o)) L.push('Every third of his health lost takes 1 off the top of his stamina bar.');",
  "rule words: a hit"
 ],
 [
  "else if (/^feint/.test(e.a || '')) L.push(",
  "else if (/^guards up/.test(e.a || '')) L.push('Guard up: both gloves high, elbows in. Every line is blocked from this moment until his next action. A feint still draws it. 1 stamina.');\n  else if (/^feint/.test(e.a || '')) L.push(",
  "rule words: Guard up"
 ],
 [
  "return /^feint/.test(e.a) ? `${col}_feint` : /^push/.test(e.a) ? ",
  "return /^guards up/.test(e.a) ? (ANIM[`${col}_both_high_high`] ? `${col}_both_high_high` : '') : /^feint/.test(e.a) ? `${col}_feint` : /^push/.test(e.a) ? ",
  "Guard up's picture in the beat (a stand-in)"
 ],
 [
  "setup();\nif (/peek=/",
  "const lastPunch = (p) => (p.clinch ? null : [...ordOf(p)].reverse().find((sl) => sl !== 'feet' && ACT[p[sl]].d) || null);\n/* RULES569: the FULL POWER tag on the card of the LAST punch of the beat, and the Guard up card's picture (a stand-in: the both-hands-high guard run) */\nfunction deco569() { const brd = document.getElementById('board'); if (!brd || phase !== 'plan' || !brd.querySelectorAll) return; const last = lastPunch(P);\n  for (const b of brd.querySelectorAll('.sw')) { const g = b.dataset.g, id = b.dataset.id;\n    if (g === last && ACT[id] && ACT[id].d && b.classList.contains('on') && !b.querySelector('.pwt')) { const on = P.pw === g, can = on || cost({ ...P, pw: g }) <= F[0].st, s = document.createElement('span');\n      s.className = 'pwt' + (on ? ' on' : '') + (can ? '' : ' no'); s.textContent = on ? 'FULL' : 'full?';\n      s.dataset.tip = (on ? 'FULL POWER is on for this punch. Click to throw it normally.' : can ? 'Throw this punch at FULL POWER: the last punch of your beat can be.' : 'Full power needs 2 more stamina.') + '\\n+2 stamina, +1 health, one step slower.\\nBlocked or short: you are wide open in your next moment.';\n      s.onclick = (e) => { e.stopPropagation(); if (!can) return; P.pw = on ? null : g; plan(); }; b.appendChild(s); }\n    if (g === 'lead' && id === 'guard' && window.cardAnim && !b.querySelector('.cpic')) { const sf = range === 3 ? '' : '_r' + range, run = ['blue_both_high_high_bob' + sf, 'blue_both_high_high' + sf, 'blue_both_high_high'].find((n) => ANIM[n]);\n      if (run) { b.classList.add('pc'); const box = document.createElement('div'); box.className = 'cpic'; b.prepend(box); window.cardAnim.attach(box, run, 0.26); } } } }\nwindow.addEventListener('load', () => setTimeout(() => { const plan569 = plan; plan = function () { plan569(); deco569(); }; if (phase === 'plan') deco569(); }, 60));\nsetup();\nif (/peek=/",
  "the full-power tag and the Guard up picture"
 ]
]''')


def main() -> None:
    s = io.open(SRC, encoding="utf-8", newline="").read()
    crlf = "\r\n" in s   # the checkout may hold either line ending: work on LF, write back what was there
    s = s.replace("\r\n", "\n")
    tw = json.load(io.open(TWEAK, encoding="utf-8"))
    for i, (a, b) in enumerate(tw["src"]):
        if a not in s:
            sys.exit(f"MAKE_RULES569 FAIL tweak src {i}: not on the page: {a[:90]!r}")
        s = s.replace(a, b, 1)
    for a, b, what in PAGE:
        if s.count(a) != 1:
            sys.exit(f"MAKE_RULES569 FAIL {what}: anchor found {s.count(a)} times: {a[:90]!r}")
        s = s.replace(a, b)
    own = (HERE.parent / "vtable_rules.json").exists()
    if own:
        if s.count("fetch('vtable.json')") != 1:
            sys.exit("MAKE_RULES569 FAIL its own look-ahead table: anchor moved")
        s = s.replace("fetch('vtable.json')", "fetch('vtable_rules.json')")
    io.open(OUT, "w", encoding="utf-8", newline="").write(s.replace("\n", "\r\n") if crlf else s)
    print("MAKE_RULES569 look-ahead table: " + ("vtable_rules.json (its own)" if own else "the main page's (vtable.json): none of its own built"))
    print(f"MAKE_RULES569 wrote {OUT.name} from {SRC.name} + {TWEAK.name} ({len(tw['src'])} rule edits, {len(PAGE)} page edits)")


if __name__ == "__main__":
    main()
